//
//  AppDelegate.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 10.12.23..
//

import UIKit
import PushKit
import CallKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate {
    var window: UIWindow?
    var voipRegistry: PKPushRegistry!
    var callManager: DefaultCallManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
        callManager = DefaultCallManager()
        
        return true
    }
    // Handle incoming calls using CallKit
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        guard type == .voIP, let callUUIDString = payload.dictionaryPayload["callUUID"] as? String,
              let callUUID = UUID(uuidString: callUUIDString) else {
            return
        }

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Caller Name")
        update.hasVideo = false

        callManager.reportIncomingCall(with: callUUID, update: update) { success in
            if !success {
                // Handle failure to report incoming call
            }
        }
    }
    // Call this function when the app receives push credentials
    func pushRegistry(_ voipRegistry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // Display the iOS device token in the Xcode console
        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        // Handle invalidation of push token, if needed
        print(registry.pushToken(for: .voIP) ?? "")
    }
}
