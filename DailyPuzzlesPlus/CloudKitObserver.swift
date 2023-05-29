import UIKit
import CloudKit
//import BlackLabs

typealias CloudKitFileContents = Array<String>
let CloudKitDataReceivedNotification = Notification.Name(rawValue: "CloudKitDataReceivedNotification")

class CloudKitObserver: NSObject {
    
    internal static let CLOUD_KIT_ASSET_NAME = "data"
    internal static let CLOUD_KIT_RESOURCES = ["factoids", "factoidUpdates"]
//    internal static let CLOUD_KIT_RESOURCES = ["cryptogram_year", "cryptofamilies_year", "memory_year", "quotefalls_year", "sudoku_year", "wordsearch", "factoids_year", "factoid_updates"]

    fileprivate static func isKnownRecordName(_ name: String) -> Bool {
        return CLOUD_KIT_RESOURCES.contains(name)
    }

    /// All resources updated remotely by CloudKit are always stored in the app support dir.
    /// So the app only has to look one place for those resources, we move the defaults shipped
    /// with the app there the first time the app is run.
    static func moveDefaultsToAppSupportDir() {
        for name in CLOUD_KIT_RESOURCES {
            moveBundledFileToAppSupportDir (name)
        }
    }

    fileprivate static func moveBundledFileToAppSupportDir(_ name: String) {
        if let fileContent = Bundle.lines(from: name) {
            AppSupportFile.save(fileContent, fileName: "\(name).txt")
        }
    }

    /// Requests the latest resources from CloudKit and stores reponse data in the Documents Directory.
    static func fetchCloudKitResources() {
        for name in CLOUD_KIT_RESOURCES {
            CKRecord.fetchRecordAsset(recordName: name, assetName: CLOUD_KIT_ASSET_NAME) { (data) in
                if let data = data {
                    let fileContent = data.components(separatedBy: CharacterSet.newlines)
                    AppSupportFile.save(fileContent, fileName: "\(name).txt")
                }
            }
        }
    }
    
    /// Observes CloudKit updates and saves them to the Documents Directory.
    ///
    /// Assumptions:
    ///  - Requests are made to CloudKit's Public Data Default Zone.
    ///  - CloudKit Records all have an asset named "data".
    ///  - CloudKit Records names with appended '.txt' are used to store files in the Documents Directory.
    ///  - All file data is an array of strings, type CloudKitFileContents.
    static func handleRemoteNotification(userInfo: [AnyHashable : Any]) {
        if let recordID = CKNotification.recordId(fromUserInfo: userInfo) {
            if isKnownRecordName(recordID.recordName) {
                CKContainer.init(identifier: "iCloud.blacklabs.dailyPuzzlesPlus").publicCloudDatabase.fetch(withRecordID: recordID, completionHandler: { (record, error) in
                    if let data = record?.stringFromAsset(assetName: CLOUD_KIT_ASSET_NAME) {
                        let fileContent = data.components(separatedBy: CharacterSet.newlines)
                        AppSupportFile.save(fileContent, fileName: "\(recordID.recordName).txt")
                        let typeDict:[String: String] = ["type": recordID.recordName]
                        NotificationCenter.default.post(name: CloudKitDataReceivedNotification, object: nil, userInfo: typeDict)
                   }
                })
            }
        }
    }
}

public extension CKRecord {

    static func fetchRecordAsset(recordName: String, assetName: String, completion: @escaping (String?)->Swift.Void) {
        let publicDatabase = CKContainer.init(identifier: "iCloud.blacklabs.dailyPuzzlesPlus").publicCloudDatabase
        let recordId = CKRecord.ID(recordName: recordName)
        publicDatabase.fetch(withRecordID: recordId) { (record, error) in
            if let text = record?.stringFromAsset(assetName: assetName) {
                completion(text)
            }
            completion(nil)
        }
    }

    func stringFromAsset(assetName: String) -> String? {
        if let asset = self[assetName] as? CKAsset,
           let content = FileManager.default.contents(atPath: asset.fileURL!.path) ,
           let text = NSString(data: content, encoding: String.Encoding.utf8.rawValue) as String? {
            return text
        }
        return nil
    }

    /*
     Do this once. It should appear https://icloud.developer.apple.com/dashboard/#containers/iCloud.dailyPuzzles/environments/Development/data/subscriptions/public
     import CloudKit
     CKRecord.subscribeToRecordUpdate(recordType: "FileAssetRecord") { (error) in
     if error == nil { print("success") }
     }


     https://developer.apple.com/library/archive/qa/qa1917/_index.html
     Note: The initializers for creating a CKSubscription object with a subscriptionID are deprecated, so use CKQuerySubscription, CKRecordZoneSubscription, or CKDatabaseSubscription on iOS 10.0+, macOS 10.12+, and tvOS 10.0+. Be aware that CKQuerySubscription is not supported in the shared database, and CKDatabaseSubscription currently only tracks the changes from custom zones in the private and shared database.

     static func subscribeToRecordUpdate(recordType: String, completion: @escaping (Error?)->Swift.Void) {
     let subscription = CKSubscription(
     recordType: recordType,
     predicate: NSPredicate(value: true),
     options: .firesOnRecordUpdate
     )
     let notificationInfo = CKSubscription.NotificationInfo()
     notificationInfo.shouldSendContentAvailable = true
     subscription.notificationInfo = notificationInfo

     let publicDatabase = CKContainer.init(identifier: "iCloud.blacklabs.dailyPuzzlesPlus").publicCloudDatabase
     publicDatabase.save(subscription) { (sub, error) in
     completion(error)
     }
     }
     */
    static func subscribeToRecordUpdate(recordType: String, completion: @escaping (Error?)->Swift.Void) {
        let subscription = CKQuerySubscription(
            recordType: recordType,
            predicate: NSPredicate(value: true),
            options: .firesOnRecordUpdate
        )
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo

        let publicDatabase = CKContainer.init(identifier: "iCloud.blacklabs.dailyPuzzlesPlus").publicCloudDatabase
        publicDatabase.save(subscription) { (sub, error) in
            completion(error)
        }
    }
}

public extension CKNotification {

    static func recordId(fromUserInfo userInfo: [AnyHashable : Any]) ->CKRecord.ID? {
        let ckNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])!
        if ckNotification.notificationType == .query, // maybe .recordZone
           let queryNotification = ckNotification as? CKQueryNotification {
            let recordID = queryNotification.recordID
            return recordID
        }
        return nil
    }
}
