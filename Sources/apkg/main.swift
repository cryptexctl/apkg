import Foundation

let apkg = APKG()
let args = CommandLine.arguments

guard args.count > 1 else {
    print("Usage: apkg <command> [package]")
    exit(1)
}

let command = args[1]
let package = args.count > 2 ? args[2] : nil

switch command {
case "install":
    guard let package = package else {
        print("Package name required")
        exit(1)
    }
    apkg.install(package)
case "remove":
    guard let package = package else {
        print("Package name required")
        exit(1)
    }
    apkg.remove(package)
case "list":
    apkg.list()
case "search":
    guard let package = package else {
        print("Search query required")
        exit(1)
    }
    apkg.search(package)
case "info":
    guard let package = package else {
        print("Package name required")
        exit(1)
    }
    apkg.info(package)
case "update":
    apkg.update()
default:
    print("Unknown command: \(command)")
    exit(1)
} 