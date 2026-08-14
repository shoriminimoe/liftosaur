import Foundation
import OSLog

@objc class LftUpdaterPath: NSObject {
  private static let activeUpdateIdKey = "LftUpdater.activeUpdateId"

  static var otaRoot: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ota")
  }

  @objc static func embeddedBundleURL() -> URL? {
    return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
  }

  // Builds before updates were removed could download a JS bundle and launch from it instead of
  // the embedded one. Those bundles survive an app upgrade, so delete them on every launch.
  @objc static func purgeDownloadedBundles() {
    let fm = FileManager.default
    let root = otaRoot
    if fm.fileExists(atPath: root.path) {
      try? fm.removeItem(at: root)
      Logger.ota.info("purged downloaded bundles at \(root.path)")
    }
    UserDefaults.standard.removeObject(forKey: activeUpdateIdKey)
  }
}
