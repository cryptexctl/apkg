import Foundation

class APKG {
    private let basePath: String
    private let dbPath: String
    private var installedPackages: [String: [String: Any]]
    
    init() {
        #if arch(arm64)
        basePath = "/opt/pkg"
        #else
        basePath = "/usr/local"
        #endif
        
        let fm = FileManager.default
        let dirs = [
            "\(basePath)/var",
            "\(basePath)/var/db",
            "\(basePath)/var/db/apkg",
            "\(basePath)/packages"
        ]
        
        for dir in dirs {
            if !fm.fileExists(atPath: dir) {
                try? fm.createDirectory(atPath: dir, withIntermediateDirectories: true)
            }
        }
        
        dbPath = "\(basePath)/var/db/apkg/packages.db"
        installedPackages = [:]
        
        if !loadDatabase() {
            print("Failed to load database")
            exit(1)
        }
    }
    
    private func loadDatabase() -> Bool {
        let fm = FileManager.default
        let dbDir = (dbPath as NSString).deletingLastPathComponent
        
        if !fm.fileExists(atPath: dbDir) {
            try? fm.createDirectory(atPath: dbDir, withIntermediateDirectories: true)
        }
        
        if !fm.fileExists(atPath: dbPath) {
            installedPackages = [:]
            return true
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: dbPath)) else {
            installedPackages = [:]
            return true
        }
        
        if data.isEmpty {
            installedPackages = [:]
            return true
        }
        
        do {
            if let dict = try JSONSerialization.jsonObject(with: data) as? [String: [String: Any]] {
                installedPackages = dict
                return true
            }
        } catch {
            print("Failed to parse database: \(error)")
        }
        
        installedPackages = [:]
        return true
    }
    
    private func saveDatabase() {
        do {
            let data = try JSONSerialization.data(withJSONObject: installedPackages)
            try data.write(to: URL(fileURLWithPath: dbPath))
        } catch {
            print("Failed to save database: \(error)")
        }
    }
    
    private func getPackageVersion(_ package: String) -> String? {
        let pkgPath = "\(basePath)/packages/\(package).apkgpkg"
        let manifestPath = "\(pkgPath)/manifest.json"
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: manifestPath)),
              let manifest = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let version = manifest["version"] as? String else {
            return nil
        }
        
        return version
    }
    
    func install(_ package: String) {
        if installedPackages[package] != nil {
            print(String(format: L10n.alreadyInstalled, package))
            return
        }
        
        let pkgPath = "\(basePath)/packages/\(package).apkgpkg"
        let fm = FileManager.default
        
        if !fm.fileExists(atPath: pkgPath) {
            print(String(format: L10n.packageNotFound, pkgPath))
            return
        }
        
        guard let version = getPackageVersion(package) else {
            print("Failed to get package version")
            return
        }
        
        let pkg = Package(name: package, version: version)
        if !pkg.validate() {
            print(String(format: L10n.invalidPackage, package))
            return
        }
        
        if !pkg.verifyChecksum() {
            print(String(format: L10n.checksumFailed, package))
            return
        }
        
        if !pkg.runScript("pre-install") {
            print(String(format: L10n.preInstallFailed, package))
            return
        }
        
        let installPath = "\(basePath)/\(package)"
        if !pkg.extractToPath(installPath) {
            print(String(format: L10n.extractFailed, package))
            return
        }
        
        if !pkg.runScript("post-install") {
            print(String(format: L10n.postInstallFailed, package))
            return
        }
        
        installedPackages[package] = pkg.toDictionary()
        saveDatabase()
        print(String(format: L10n.installSuccess, package, version))
    }
    
    func remove(_ package: String) {
        guard let dict = installedPackages[package] else {
            print(String(format: L10n.notInstalled, package))
            return
        }
        
        let version = dict["version"] as? String ?? "unknown"
        let pkg = Package(name: package, version: version)
        
        if !pkg.runScript("pre-deinstall") {
            print(String(format: L10n.preDeinstallFailed, package))
            return
        }
        
        let installPath = "\(basePath)/\(package)"
        let fm = FileManager.default
        try? fm.removeItem(atPath: installPath)
        
        if !pkg.runScript("post-deinstall") {
            print(String(format: L10n.postDeinstallFailed, package))
            return
        }
        
        installedPackages.removeValue(forKey: package)
        saveDatabase()
        print(String(format: L10n.removeSuccess, package, version))
    }
    
    func list() {
        for (package, info) in installedPackages {
            let version = info["version"] as? String ?? "unknown"
            let installed = info["installed"] as? String ?? "unknown"
            print(String(format: "%@ %@ (installed: %@)", package, version, installed))
        }
    }
    
    func search(_ query: String) {
        let fm = FileManager.default
        let packagesPath = "\(basePath)/packages"
        
        guard let files = try? fm.contentsOfDirectory(atPath: packagesPath) else {
            print(L10n.readPackagesFailed)
            return
        }
        
        for file in files where file.hasSuffix(".apkgpkg") {
            let package = (file as NSString).deletingPathExtension
            if package.localizedCaseInsensitiveContains(query) {
                if let version = getPackageVersion(package) {
                    print("\(package) \(version)")
                } else {
                    print(package)
                }
            }
        }
    }
    
    func info(_ package: String) {
        if let info = installedPackages[package] {
            let version = info["version"] as? String ?? "unknown"
            let installed = info["installed"] as? String ?? "unknown"
            print(String(format: L10n.packageInfo, package))
            print(String(format: L10n.versionInfo, version))
            print(String(format: L10n.installedInfo, installed))
        } else {
            print(String(format: L10n.notInstalled, package))
        }
    }
    
    func update() {
        let fm = FileManager.default
        let packagesPath = "\(basePath)/packages"
        
        guard let files = try? fm.contentsOfDirectory(atPath: packagesPath) else {
            print(L10n.readPackagesFailed)
            return
        }
        
        for file in files where file.hasSuffix(".apkgpkg") {
            let package = (file as NSString).deletingPathExtension
            if let installedInfo = installedPackages[package],
               let installedVersion = installedInfo["version"] as? String,
               let newVersion = getPackageVersion(package),
               installedVersion != newVersion {
                print(String(format: L10n.updateAvailable, package, installedVersion, newVersion))
                install(package)
            }
        }
    }
} 