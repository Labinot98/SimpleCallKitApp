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

    // Implement other PKPushRegistryDelegate methods if necessary


    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        // Handle push token registration, if needed
        print(pushCredentials.token)
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        // Handle invalidation of push token, if needed
        print(registry.pushToken(for: .voIP) ?? "")
    }
}
