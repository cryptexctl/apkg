import Foundation

class CacheManager {
    static let shared = CacheManager()
    private let fileManager = FileManager.default
    
    private init() {
        createCacheDirectoryIfNeeded()
    }
    
    private func createCacheDirectoryIfNeeded() {
        let cacheDir = SystemUtils.getCacheDirectory()
        if !fileManager.fileExists(atPath: cacheDir.path) {
            try? fileManager.createDirectory(at: cacheDir, withIntermediateDirectories: true)
        }
    }
    
    func cachePackage(name: String, data: Data) throws {
        let cacheFile = SystemUtils.getCacheDirectory().appendingPathComponent("\(name).pkg")
        try data.write(to: cacheFile)
    }
    
    func getCachedPackage(name: String) -> Data? {
        let cacheFile = SystemUtils.getCacheDirectory().appendingPathComponent("\(name).pkg")
        return try? Data(contentsOf: cacheFile)
    }
    
    func clearCache() throws {
        let cacheDir = SystemUtils.getCacheDirectory()
        let contents = try fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
        for file in contents {
            try fileManager.removeItem(at: file)
        }
    }
    
    func getCacheSize() throws -> Int64 {
        let cacheDir = SystemUtils.getCacheDirectory()
        let contents = try fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: [.fileSizeKey])
        return try contents.reduce(0) { sum, url in
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            return sum + (attributes[.size] as? Int64 ?? 0)
        }
    }
} 