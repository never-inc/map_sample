import Flutter
import UIKit
import flutter_config
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let apiKey = flutter_config.FlutterConfigPlugin.env(for: "GOOGLE_MAP_API_KEY") {
            GMSServices.provideAPIKey(apiKey)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
