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

class DefaultCallManager:  NSObject, CallManagerProtocol {
    var delegate: CallManagerDelegate?

    var provider: CXProvider!
    var callController: CXCallController!

    override init() {
        super.init()

        provider = CXProvider(configuration: CXProviderConfiguration(localizedName: "SimpleCallKitApp"))
        callController = CXCallController()
        provider.setDelegate(self, queue: nil)
    }

    func startCall(completion: @escaping (Bool, UUID?) -> Void) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Caller Name")
        update.hasVideo = false

        let uuid = UUID()
        // Replace with the unique identifier for the call
        let callUUID = uuid

        reportIncomingCall(with: callUUID, update: update) { success in
            if success {
                completion(true, callUUID)
            } else {
                completion(false, nil)
            }
        }
    }
    
    func endCall(callUUID: UUID?) {
        guard let callUUID = callUUID else { return }

        let endCallAction = CXEndCallAction(call: callUUID)
        let transaction = CXTransaction(action: endCallAction)

        callController.request(transaction) { [weak self] error in
            if let error = error {
                print("Failed to end the call: \(error.localizedDescription)")
            } else {
                self?.delegate?.callEnded()
            }
        }
    }

    func reportIncomingCall(with callUUID: UUID, update: CXCallUpdate, completion: @escaping (Bool) -> Void) {
        provider.reportNewIncomingCall(with: callUUID, update: update) { error in
            if let error = error {
                print("Failed to report incoming call: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

extension DefaultCallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
        self.delegate?.callEnded()
    }

    // Implement other CXProviderDelegate methods if necessary
}
