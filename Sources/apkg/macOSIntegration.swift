import Foundation
import ServiceManagement

enum macOSIntegration {
    static func installLaunchAgent() -> Bool {
        let agentPath = "/Library/LaunchAgents/com.apkg.updater.plist"
        let plistContent = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>com.apkg.updater</string>
            <key>ProgramArguments</key>
            <array>
                <string>/usr/local/bin/apkg</string>
                <string>update</string>
            </array>
            <key>StartInterval</key>
            <integer>86400</integer>
            <key>RunAtLoad</key>
            <true/>
        </dict>
        </plist>
        """
        
        do {
            try plistContent.write(toFile: agentPath, atomically: true, encoding: .utf8)
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            process.arguments = ["load", agentPath]
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    static func uninstallLaunchAgent() -> Bool {
        let agentPath = "/Library/LaunchAgents/com.apkg.updater.plist"
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/launchctl")
        process.arguments = ["unload", agentPath]
        do {
            try process.run()
            process.waitUntilExit()
            try FileManager.default.removeItem(atPath: agentPath)
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    static func registerWithSystem() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/pkgutil")
        process.arguments = ["--register", "/usr/local/bin/apkg"]
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
    
    static func unregisterFromSystem() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/pkgutil")
        process.arguments = ["--unregister", "/usr/local/bin/apkg"]
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }
} 