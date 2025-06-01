import Foundation

enum L10n {
    private static let bundle: Bundle = {
        let language = SystemUtils.systemLanguage
        if let path = Bundle.module.path(forResource: language, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle
        }
        return Bundle.module
    }()
    
    static func localizedString(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, bundle: bundle, comment: "")
        return String(format: format, arguments: args)
    }
    
    static let usage = localizedString("Usage: apkg <command> [package]")
    static let packageRequired = localizedString("Package name required")
    static let searchQueryRequired = localizedString("Search query required")
    static let unknownCommand = { (cmd: String) in localizedString("Unknown command: %@", cmd) }
    
    static let helpTitle = localizedString("APKG - macOS package manager")
    static let helpUsage = localizedString("Usage:")
    static let helpCommands = localizedString("Commands:")
    static let helpInstall = localizedString("install <package>    Install package")
    static let helpRemove = localizedString("remove <package>     Remove package")
    static let helpList = localizedString("list                 List installed packages")
    static let helpSearch = localizedString("search <query>       Search packages")
    static let helpInfo = localizedString("info <package>       Show package info")
    static let helpUpdate = localizedString("update               Update packages")
    static let helpHelp = localizedString("help                 Show this help")
    static let helpRegister = localizedString("register            Register with system")
    static let helpUnregister = localizedString("unregister          Unregister from system")
    static let helpInstallAgent = localizedString("install-agent       Install update agent")
    static let helpUninstallAgent = localizedString("uninstall-agent     Uninstall update agent")
    static let helpSudoNote = localizedString("Note: All commands require sudo privileges")
    
    static let alreadyInstalled = { (pkg: String) in localizedString("Package %@ is already installed", pkg) }
    static let packageNotFound = { (path: String) in localizedString("Package file not found: %@", path) }
    static let invalidPackage = { (pkg: String) in localizedString("Invalid package: %@", pkg) }
    static let checksumFailed = { (pkg: String) in localizedString("Package checksum verification failed: %@", pkg) }
    static let preInstallFailed = { (pkg: String) in localizedString("Pre-install script failed: %@", pkg) }
    static let extractFailed = { (pkg: String) in localizedString("Failed to extract package: %@", pkg) }
    static let postInstallFailed = { (pkg: String) in localizedString("Post-install script failed: %@", pkg) }
    static let installSuccess = { (pkg: String, ver: String) in localizedString("Successfully installed %@ %@", pkg, ver) }
    
    static let notInstalled = { (pkg: String) in localizedString("Package %@ is not installed", pkg) }
    static let preDeinstallFailed = { (pkg: String) in localizedString("Pre-deinstall script failed: %@", pkg) }
    static let postDeinstallFailed = { (pkg: String) in localizedString("Post-deinstall script failed: %@", pkg) }
    static let removeSuccess = { (pkg: String, ver: String) in localizedString("Successfully removed %@ %@", pkg, ver) }
    
    static let packageInfo = { (pkg: String) in localizedString("Package: %@", pkg) }
    static let versionInfo = { (ver: String) in localizedString("Version: %@", ver) }
    static let installedInfo = { (date: String) in localizedString("Installed: %@", date) }
    
    static let updateAvailable = { (pkg: String, old: String, new: String) in localizedString("Updating %@ from %@ to %@", pkg, old, new) }
    static let readPackagesFailed = localizedString("Failed to read packages directory")
    
    static let systemRequirementsFailed = localizedString("System requirements not met: macOS 13.0 or newer required")
    static let rootRequired = localizedString("This command requires root privileges")
    static let integrationSuccess = { (cmd: String) in localizedString("Successfully %@", cmd) }
    static let integrationFailed = { (cmd: String) in localizedString("Failed to %@", cmd) }
} 