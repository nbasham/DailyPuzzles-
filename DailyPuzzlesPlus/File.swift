import Foundation

public extension URL {

    init(localFile name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else {
            preconditionFailure("Expected local file: \(name)")
        }
        self.init(fileURLWithPath: path)
    }
}

public extension Data {

    /// Assumes that local files are project based and thus expected and fails if not.
    init(localFile name: String) {
        let url = URL(localFile: name)
        do {
            try self.init(contentsOf: url)
        } catch {
            preconditionFailure("Expected local file named: \(name).")
        }
    }

    static func toString(_ localFile: String) -> String? {
        let data = Data(localFile: localFile)
        let fileContents = String(decoding: data, as: UTF8.self)
        return fileContents
    }

    static func parse<T>(localFile name: String, _ callback: (String)->T) -> T? {
        if let str = Data.toString(name) {
            let result = callback(str)
            return result
        }
        return nil
    }

    static func lines(localFile name: String) -> [String]? {
        let result = Data.parse(localFile: name) { str in
            let lines = str.components(separatedBy: CharacterSet.newlines).map { $0.trimmingCharacters(in: .whitespaces) }
            return lines.removeEmptyLines
        }
        return result
    }
}

public protocol IOSDirectoryFile {
    static var dirSelector: FileManager.SearchPathDirectory { get }
}

public extension IOSDirectoryFile {

    static var url: URL {
        return FileManager.default.urls(for: dirSelector, in: .userDomainMask)[0]
    }

    static func path(_ fileName: String) -> String {
        return url.appendingPathComponent(fileName).path
    }

    static func load(_ fileName: String) -> Any? {
        let fullPath = url.appendingPathComponent(fileName)
        if let data = try? Data(contentsOf: fullPath) {
            do {
                return try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSString.self], from: data)
            } catch {
                print("Failed loading \(fileName)")
            }
        }
        return nil
    }

    static func exists(_ fileName: String) -> Bool {
        let fullPath = path(fileName)
        let b = FileManager.default.fileExists(atPath: fullPath)
        return b
    }

    static func save(_ object: Any, fileName: String) {
        // may fail because it may not exist in sandbox, so check existence and create if necessary
        if FileManager.default.fileExists(atPath: url.absoluteString) == false {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        let fullPath = path(fileName)

        if let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false),
           let url = URL(string: fullPath) {
            do {
                try data.write(to: url, options: .atomic)
                print("saved \(fileName)")
            } catch {
                print("Failed saving \(fullPath)")
            }
        }
    }

    static func remove(_ fileName: String) {
        let fullPath = path(fileName)
        try? FileManager.default.removeItem(atPath: fullPath)
    }
}

/// Example usage:
/// - AppSupportFile.load("name.txt")
/// - AppSupportFile.save(fileContents, fileName: "name.txt")
/// - AppSupportFile.remove("name.txt")
public class AppSupportFile: IOSDirectoryFile {
    public static var dirSelector: FileManager.SearchPathDirectory { return .applicationSupportDirectory }
}

/// Example usage:
/// - DocumentsFile.load("name.txt")
/// - DocumentsFile.save(fileContents, fileName: "name.txt")
/// - DocumentsFile.remove("name.txt")
public class DocumentsFile: IOSDirectoryFile {
    public static var dirSelector: FileManager.SearchPathDirectory { return .documentDirectory }
}

/// e.g. `fileNamesFromDir("/Users/Norman/Desktop/")` would return all of the file names on desktop
public func _fileNamesFromDir(_ path: String) -> [String] {
    let fm = FileManager.default
    let fileExists = fm.fileExists(atPath: path)
    guard fileExists else { return [] }
    guard let names = try? fm.contentsOfDirectory(atPath: path) else { return [] }
    return names
}

/// e.g. `_writeStringToDir("/Users/Norman/Desktop/", fileName: "a.txt", fileContents: "Bob")` would write a.txt to the desktop, contents Bob. `print(#file)` can be useful to find currnt project dir.
public func _writeStringToDir(_ dirPath: String, fileName: String, fileContents: String) {
    let fm = FileManager.default
    try? fm.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
    let fileExists = fm.fileExists(atPath: dirPath)
    guard fileExists else { fatalError("Invalid path: \(dirPath)") }
    let path = dirPath.appending(fileName)
    fm.createFile(atPath: path, contents: fileContents.data(using: .utf8), attributes: nil)
}

import UIKit
/// e.g. `_pngFromDir("/Users/Norman/Desktop/")` would return all of the .png's on desktop
public func _pngFromDir(_ path: String) -> [UIImage] {
    let names = _fileNamesFromDir(path)
    let images = names.filter { $0.hasSuffix(".png") }.compactMap { UIImage(contentsOfFile: "\(path)\($0)") }
    return images
}
/// e.g. `_jpgFromDir("/Users/Norman/Desktop/")` would return all of the .jpg's on desktop
public func _jpgFromDir(_ path: String) -> [UIImage] {
    let names = _fileNamesFromDir(path)
    let images = names.filter { $0.hasSuffix(".jpg") }.compactMap { UIImage(contentsOfFile: "\(path)\($0)") }
    return images
}
