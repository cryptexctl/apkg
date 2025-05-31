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
    
    func install(_ package: String) {
        if installedPackages[package] != nil {
            print("Package \(package) is already installed")
            return
        }
        
        let pkgPath = "\(basePath)/packages/\(package).apkgpkg"
        let fm = FileManager.default
        
        if !fm.fileExists(atPath: pkgPath) {
            print("Package file not found: \(pkgPath)")
            return
        }
        
        let pkg = Package(name: package, version: "1.0")
        if !pkg.validate() {
            print("Invalid package: \(package)")
            return
        }
        
        if !pkg.verifyChecksum() {
            print("Package checksum verification failed: \(package)")
            return
        }
        
        if !pkg.runScript("pre-install") {
            print("Pre-install script failed: \(package)")
            return
        }
        
        let installPath = "\(basePath)/\(package)"
        if !pkg.extractToPath(installPath) {
            print("Failed to extract package: \(package)")
            return
        }
        
        if !pkg.runScript("post-install") {
            print("Post-install script failed: \(package)")
            return
        }
        
        installedPackages[package] = pkg.toDictionary()
        saveDatabase()
        print("Successfully installed \(package)")
    }
    
    func remove(_ package: String) {
        guard let dict = installedPackages[package] else {
            print("Package \(package) is not installed")
            return
        }
        
        let pkg = Package(name: package, version: dict["version"] as? String ?? "1.0")
        
        if !pkg.runScript("pre-deinstall") {
            print("Pre-deinstall script failed: \(package)")
            return
        }
        
        let installPath = "\(basePath)/\(package)"
        let fm = FileManager.default
        try? fm.removeItem(atPath: installPath)
        
        if !pkg.runScript("post-deinstall") {
            print("Post-deinstall script failed: \(package)")
            return
        }
        
        installedPackages.removeValue(forKey: package)
        saveDatabase()
        print("Successfully removed \(package)")
    }
    
    func list() {
        for (package, info) in installedPackages {
            print("\(package) (\(info["version"] as? String ?? "unknown"))")
        }
    }
    
    func search(_ query: String) {
        let fm = FileManager.default
        let packagesPath = "\(basePath)/packages"
        
        guard let files = try? fm.contentsOfDirectory(atPath: packagesPath) else {
            print("Failed to read packages directory")
            return
        }
        
        for file in files where file.hasSuffix(".apkgpkg") {
            let package = (file as NSString).deletingPathExtension
            if package.localizedCaseInsensitiveContains(query) {
                print(package)
            }
        }
    }
    
    func info(_ package: String) {
        if let info = installedPackages[package] {
            print("Package: \(package)")
            print("Version: \(info["version"] as? String ?? "unknown")")
            print("Installed: \(info["installed"] as? String ?? "unknown")")
        } else {
            print("Package \(package) is not installed")
        }
    }
    
    func update() {
        let fm = FileManager.default
        let packagesPath = "\(basePath)/packages"
        
        guard let files = try? fm.contentsOfDirectory(atPath: packagesPath) else {
            print("Failed to read packages directory")
            return
        }
        
        for file in files where file.hasSuffix(".apkgpkg") {
            let package = (file as NSString).deletingPathExtension
            install(package)
        }
    }
} 