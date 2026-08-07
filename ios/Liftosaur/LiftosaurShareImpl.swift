import Foundation
import UIKit

@objc class LiftosaurShareImpl: NSObject {
  @objc static let shared = LiftosaurShareImpl()

  @objc func shareLog(completion: @escaping (String?) -> Void) {
    let phoneLogs = LogFileManager.shared.readLogs()
    LiftosaurWatchImpl.shared.requestLogs { watchLogs in
      let merged = Self.mergeLogs(phoneLogs: phoneLogs, watchLogs: watchLogs ?? "")
      DispatchQueue.main.async {
        self.presentShareSheet(content: merged, completion: completion)
      }
    }
  }

  private static func mergeLogs(phoneLogs: String, watchLogs: String) -> String {
    let phoneLines = phoneLogs.components(separatedBy: "\n").filter { !$0.isEmpty }
    let watchLines = watchLogs.components(separatedBy: "\n").filter { !$0.isEmpty }
    let allLines = (phoneLines + watchLines).sorted { extractTimestamp(from: $0) < extractTimestamp(from: $1) }
    return allLines.joined(separator: "\n")
  }

  private static func extractTimestamp(from line: String) -> String {
    guard line.hasPrefix("["), let endIndex = line.firstIndex(of: "]") else { return "" }
    return String(line[line.index(after: line.startIndex)..<endIndex])
  }

  private func presentShareSheet(content: String, completion: @escaping (String?) -> Void) {
    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("liftosaur-merged.log")
    do {
      try content.write(to: tempURL, atomically: true, encoding: .utf8)
    } catch {
      completion("Failed to write log file: \(error.localizedDescription)")
      return
    }
    guard let rootVC = Self.topViewController() else {
      completion("No view controller to present share sheet")
      return
    }
    let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
    if let popover = activityVC.popoverPresentationController {
      popover.sourceView = rootVC.view
      popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
      popover.permittedArrowDirections = []
    }
    rootVC.present(activityVC, animated: true) {
      completion(nil)
    }
  }

  private static func topViewController() -> UIViewController? {
    let scene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first(where: { $0.activationState == .foregroundActive }) ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    guard let window = scene?.windows.first(where: { $0.isKeyWindow }) ?? scene?.windows.first else { return nil }
    var top = window.rootViewController
    while let presented = top?.presentedViewController { top = presented }
    return top
  }
}
