import UIKit
import Flutter
import PushKit
import CallKit
import flutter_callkit_incoming

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate, CXProviderDelegate {

    var provider: CXProvider?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]

        let config = CXProviderConfiguration(localizedName: "VoIPCallKit")
        config.supportsVideo = true
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]
        provider = CXProvider(configuration: config)
        provider?.setDelegate(self, queue: nil)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // MARK: - PushKit
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    }

    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {
        let id = payload.dictionaryPayload["uuid"] as? String ?? UUID().uuidString
        let handle = payload.dictionaryPayload["handle"] as? String ?? "unknown"
        let name = payload.dictionaryPayload["name"] as? String ?? "Caller"

        let data = flutter_callkit_incoming.Data(args: [
            "id": id,
            "nameCaller": name,
            "handle": handle,
            "type": 1,
        ])
        SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(data, fromPushKit: true)
        completion()
    }

    // MARK: - CXProviderDelegate
    func providerDidReset(_ provider: CXProvider) {}
}
