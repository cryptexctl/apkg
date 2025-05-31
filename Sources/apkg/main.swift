import Foundation

let apkg = APKG()
let args = CommandLine.arguments

guard args.count > 1 else {
    print(L10n.usage)
    exit(1)
}

let command = args[1]
let package = args.count > 2 ? args[2] : nil

switch command {
case "install":
    guard let package = package else {
        print(L10n.packageRequired)
        exit(1)
    }
    apkg.install(package)
case "remove":
    guard let package = package else {
        print(L10n.packageRequired)
        exit(1)
    }
    apkg.remove(package)
case "list":
    apkg.list()
case "search":
    guard let package = package else {
        print(L10n.searchQueryRequired)
        exit(1)
    }
    apkg.search(package)
case "info":
    guard let package = package else {
        print(L10n.packageRequired)
        exit(1)
    }
    apkg.info(package)
case "update":
    apkg.update()
case "help", "--help", "-h":
    printHelp()
case "register":
    if macOSIntegration.registerWithSystem() {
        print("Successfully registered with system")
    } else {
        print("Failed to register with system")
        exit(1)
    }
case "unregister":
    if macOSIntegration.unregisterFromSystem() {
        print("Successfully unregistered from system")
    } else {
        print("Failed to unregister from system")
        exit(1)
    }
case "install-agent":
    if macOSIntegration.installLaunchAgent() {
        print("Successfully installed launch agent")
    } else {
        print("Failed to install launch agent")
        exit(1)
    }
case "uninstall-agent":
    if macOSIntegration.uninstallLaunchAgent() {
        print("Successfully uninstalled launch agent")
    } else {
        print("Failed to uninstall launch agent")
        exit(1)
    }
default:
    print(String(format: L10n.unknownCommand, command))
    printHelp()
    exit(1)
}

func printHelp() {
    print("""
    \(L10n.helpTitle)
    
    \(L10n.helpUsage)
        apkg <command> [package]
    
    \(L10n.helpCommands):
        \(L10n.helpInstall)
        \(L10n.helpRemove)
        \(L10n.helpList)
        \(L10n.helpSearch)
        \(L10n.helpInfo)
        \(L10n.helpUpdate)
        \(L10n.helpHelp)
        register              Register with system
        unregister           Unregister from system
        install-agent        Install update agent
        uninstall-agent      Uninstall update agent
    
    \(L10n.helpSudoNote)
    """)
} 