import Foundation

struct KeyValueStore {
    typealias Key = String
    
    private static let documents = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    )[0]
    
    static func object<T: Decodable>(for key: Key) -> T? {
        let url = documents.appendingPathComponent("KeyValueStore/\(key).json")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        if let data = try? Data(contentsOf: url) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        
        return nil
    }
    
    static func evictObject(for key: Key) throws {
        let url = documents.appendingPathComponent("KeyValueStore/\(key).json")
        try FileManager.default.removeItem(atPath: url.path)
    }
    
    static func set<T: Encodable>(_ object: T, with key: Key) throws {
        let url = documents.appendingPathComponent("KVS-\(key).json")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            FileManager.default.createFile(atPath: url.path, contents: Data())
            return try set(object, with: key)
        }
        
        let encodedJSON = try JSONEncoder().encode(object)
        try encodedJSON.write(to: url, options: .completeFileProtection)
    }
}
