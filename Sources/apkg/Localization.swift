import Foundation

enum L10n {
    static let usage = NSLocalizedString("Usage: apkg <command> [package]", comment: "")
    static let packageRequired = NSLocalizedString("Package name required", comment: "")
    static let searchQueryRequired = NSLocalizedString("Search query required", comment: "")
    static let unknownCommand = NSLocalizedString("Unknown command: %@", comment: "")
    
    static let helpTitle = NSLocalizedString("APKG - macOS package manager", comment: "")
    static let helpUsage = NSLocalizedString("Usage:", comment: "")
    static let helpCommands = NSLocalizedString("Commands:", comment: "")
    static let helpInstall = NSLocalizedString("install <package>    Install package", comment: "")
    static let helpRemove = NSLocalizedString("remove <package>     Remove package", comment: "")
    static let helpList = NSLocalizedString("list                 List installed packages", comment: "")
    static let helpSearch = NSLocalizedString("search <query>       Search packages", comment: "")
    static let helpInfo = NSLocalizedString("info <package>       Show package info", comment: "")
    static let helpUpdate = NSLocalizedString("update               Update packages", comment: "")
    static let helpHelp = NSLocalizedString("help                 Show this help", comment: "")
    static let helpSudoNote = NSLocalizedString("Note: All commands require sudo privileges", comment: "")
    
    static let alreadyInstalled = NSLocalizedString("Package %@ is already installed", comment: "")
    static let packageNotFound = NSLocalizedString("Package file not found: %@", comment: "")
    static let invalidPackage = NSLocalizedString("Invalid package: %@", comment: "")
    static let checksumFailed = NSLocalizedString("Package checksum verification failed: %@", comment: "")
    static let preInstallFailed = NSLocalizedString("Pre-install script failed: %@", comment: "")
    static let extractFailed = NSLocalizedString("Failed to extract package: %@", comment: "")
    static let postInstallFailed = NSLocalizedString("Post-install script failed: %@", comment: "")
    static let installSuccess = NSLocalizedString("Successfully installed %@ %@", comment: "")
    
    static let notInstalled = NSLocalizedString("Package %@ is not installed", comment: "")
    static let preDeinstallFailed = NSLocalizedString("Pre-deinstall script failed: %@", comment: "")
    static let postDeinstallFailed = NSLocalizedString("Post-deinstall script failed: %@", comment: "")
    static let removeSuccess = NSLocalizedString("Successfully removed %@ %@", comment: "")
    
    static let packageInfo = NSLocalizedString("Package: %@", comment: "")
    static let versionInfo = NSLocalizedString("Version: %@", comment: "")
    static let installedInfo = NSLocalizedString("Installed: %@", comment: "")
    
    static let updateAvailable = NSLocalizedString("Updating %@ from %@ to %@", comment: "")
    static let readPackagesFailed = NSLocalizedString("Failed to read packages directory", comment: "")
} 