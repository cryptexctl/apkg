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
        #elseif arch(x86_64)
        return "x86_64"
        #else
        return "unknown"
        #endif
    }
    
    static var isAppleSilicon: Bool {
        return architecture == "arm64"
    }
    
    static var isRunningUnderRosetta: Bool {
        var ret = Int32(0)
        var size = Int(MemoryLayout<Int32>.size)
        return sysctlbyname("sysctl.proc_translated", &ret, &size, nil, 0) == 0 && ret == 1
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
        
        if isAppleSilicon {
            return major >= 11
        } else {
            return major >= 10 && minor >= 15
        }
    }
    
    static func getSystemInfo() -> [String: String] {
        return [
            "language": systemLanguage,
            "architecture": architecture,
            "isAppleSilicon": String(isAppleSilicon),
            "isRosetta": String(isRunningUnderRosetta),
            "version": systemVersion,
            "isRoot": String(isRunningAsRoot)
        ]
    }
    
    static func getCacheDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("apkg")
    }
    
    static func getPackageDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("apkg")
    }
} 