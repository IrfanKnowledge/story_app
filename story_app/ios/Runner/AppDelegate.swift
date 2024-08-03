import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // google maps API Key
    GMSServices.provideAPIKey("AIzaSyAgcKtmaJq4Rh11GL476U7Nwz48nxGM56o")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
