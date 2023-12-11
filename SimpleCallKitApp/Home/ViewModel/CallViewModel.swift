//  CallViewModel.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 10.12.23..
//

import Foundation
import CallKit

enum CallState {
    case idle
    case connecting
    case connected
    case disconnected
}

protocol CallViewModelDelegate: AnyObject {
    func updateUI()
}

class CallViewModel {
    weak var delegate: CallViewModelDelegate?
    private var callManager: CallManagerProtocol
    private var callUUID: UUID?

    var callState: CallState = .idle {
        didSet {
            delegate?.updateUI()
        }
    }

    init(callManager: CallManagerProtocol) {
        self.callManager = callManager
        self.callManager.delegate = self
    }

    func toggleCallState() {
        switch callState {
        case .idle, .disconnected:
            callState = .connecting
            initiateCall()
        case .connected, .connecting:
            endCall()
        }
    }

    private func initiateCall() {
        callManager.startCall { [weak self] success, uuid in
            guard let self = self else { return }
            if success {
                self.callState = .connected
                self.callUUID = uuid
            } else {
                self.callState = .disconnected
            }
        }
    }

    private func endCall() {
        callManager.endCall(callUUID: callUUID)
    }
}

extension CallViewModel: CallManagerDelegate {
    func callEnded() {
        callState = .disconnected
    }
}
