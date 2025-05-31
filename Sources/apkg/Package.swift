import Foundation

class Package {
    let name: String
    let version: String
    
    init(name: String, version: String) {
        self.name = name
        self.version = version
    }
    
    func validate() -> Bool {
        let fm = FileManager.default
        let pkgPath = "/opt/pkg/packages/\(name).apkgpkg"
        
        guard fm.fileExists(atPath: pkgPath) else {
            return false
        }
        
        return true
    }
    
    func verifyChecksum() -> Bool {
        let pkgPath = "/opt/pkg/packages/\(name).apkgpkg"
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/shasum")
        process.arguments = ["-a", "256", pkgPath]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8) else {
                return false
            }
            
            let components = output.components(separatedBy: " ")
            guard components.count >= 1 else {
                return false
            }
            
            return true
        } catch {
            return false
        }
    }
    
    func runScript(_ scriptName: String) -> Bool {
        let pkgPath = "/opt/pkg/packages/\(name).apkgpkg"
        let scriptPath = "\(pkgPath)/\(scriptName).sh"
        
        let fm = FileManager.default
        guard fm.fileExists(atPath: scriptPath) else {
            return true
        }
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = [scriptPath]
        
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    func extractToPath(_ path: String) -> Bool {
        let pkgPath = "/opt/pkg/packages/\(name).apkgpkg"
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/tar")
        process.arguments = ["-xf", pkgPath, "-C", path]
        
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "version": version,
            "installed": ISO8601DateFormatter().string(from: Date())
        ]
    }
} 