//
//  CallManager.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 11.12.23..
//

import Foundation
import CallKit

protocol CallManagerProtocol: AnyObject {
    var delegate: CallManagerDelegate? { get set }
    func startCall(completion: @escaping (Bool, UUID?) -> Void)
    func endCall(callUUID: UUID?)
}

protocol CallManagerDelegate: AnyObject {
    func callEnded()
}

class DefaultCallManager: CallManagerProtocol {
    weak var delegate: CallManagerDelegate?
    
    init(delegate: CallManagerDelegate? = nil) {
        self.delegate = delegate
    }

    func startCall(completion: @escaping (Bool, UUID?) -> Void) {
        // Simulating CallKit report new incoming call
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Caller Name")
        update.hasVideo = false

        let uuid = UUID()
        // Replace with the unique identifier for the call
        let callUUID = uuid

        // Report the new incoming call
        CXProvider(configuration: CXProviderConfiguration(localizedName: "SimpleCallKitApp"))
            .reportNewIncomingCall(with: callUUID, update: update) { error in
                if let error = error {
                    print("Failed to report incoming call: \(error.localizedDescription)")
                    completion(false, nil)
                } else {
                    completion(true, callUUID)
                }
            }
    }

    func endCall(callUUID: UUID?) {
        guard let callUUID = callUUID else { return }

        // End the ongoing call
        let endCallAction = CXEndCallAction(call: callUUID)
        let transaction = CXTransaction(action: endCallAction)
        let callController = CXCallController()

        callController.request(transaction) { [weak self] error in
            if let error = error {
                print("Failed to end the call: \(error.localizedDescription)")
            }
            self?.delegate?.callEnded()
        }
    }
}
