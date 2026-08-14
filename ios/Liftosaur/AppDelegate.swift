import UIKit
import OSLog
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import RollbarNotifier
import GoogleAdsOnDeviceConversion

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var reactNativeDelegate: ReactNativeDelegate?
  var reactNativeFactory: RCTReactNativeFactory?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    LftUpdaterPath.purgeDownloadedBundles()

    LiftosaurEventReporterImpl.shared.registerWithMetricKit()
    _ = LiftosaurWorkoutMirroringImpl.shared

    if let cachedUserId = UserDefaults.standard.string(forKey: "LiftosaurCachedUserId") {
      let config = Rollbar.configuration().mutableCopy()
      config.setPersonId(cachedUserId, username: nil, email: nil)
      Rollbar.update(withConfiguration: config)
    }

    ConversionManager.sharedInstance.setFirstLaunchTime(Date())

    RCTFastTextRegistrar.registerComponent()

    let delegate = ReactNativeDelegate()
    let factory = RCTReactNativeFactory(delegate: delegate)
    delegate.dependencyProvider = RCTAppDependencyProvider()

    reactNativeDelegate = delegate
    reactNativeFactory = factory

    return true
  }

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    LiftosaurEventReporterImpl.shared.markGracefulTermination()
  }
}

class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }

  override func bundleURL() -> URL? {
#if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    LftUpdaterPath.embeddedBundleURL()
#endif
  }
}
