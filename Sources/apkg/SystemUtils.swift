import Foundation

enum SystemUtils {
    static var systemLanguage: String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        return preferredLanguage.prefix(2).lowercased()
    }
    
    static var isRunningAsRoot: Bool {
        return geteuid() == 0
    }
    
    static var architecture: String {
        #if arch(arm64)
        return "arm64"
        #else
        return "x86_64"
        #endif
    }
    
    static var systemVersion: String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/sw_vers")
        process.arguments = ["-productVersion"]
        let pipe = Pipe()
        process.standardOutput = pipe
        try? process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "unknown"
    }
    
    static func checkSystemRequirements() -> Bool {
        let version = systemVersion
        let components = version.split(separator: ".")
        guard components.count >= 2,
              let major = Int(components[0]),
              let minor = Int(components[1]) else {
            return false
        }
        return major >= 13
    }
    
    static func getSystemInfo() -> [String: String] {
        return [
            "language": systemLanguage,
            "architecture": architecture,
            "version": systemVersion,
            "isRoot": String(isRunningAsRoot)
        ]
    }
} 