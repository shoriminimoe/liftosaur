import Foundation
import OSLog

// This build never fetches JS bundles from a remote update server - it only ever runs the bundle
// it was compiled with. The native module is kept so the JS spec still resolves, but every entry
// point is inert except revertToEmbedded, which cleans up bundles older builds downloaded.
@objc class LftUpdater: NSObject {
  @objc static let shared = LftUpdater()

  @objc func checkAndDownload(completion: @escaping (String) -> Void) {
    Logger.ota.info("checkAndDownload called; updates are disabled in this build")
    completion("{\"status\":\"no-update\"}")
  }

  @objc func markLaunchSuccessful() {
  }

  @objc func activeBundleId() -> String? {
    return nil
  }

  @objc func revertToEmbedded() {
    LftUpdaterPath.purgeDownloadedBundles()
  }
}
