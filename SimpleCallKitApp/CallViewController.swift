//
//  ViewController.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 10.12.23..
//

import UIKit
import AgoraRtcKit
import CallKit
import AVFoundation

class CallViewController: UIViewController, CallViewModelDelegate, CallViewDelegate {
    var viewModel: CallViewModel!
    var callView: CallView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let callManager = DefaultCallManager()
               viewModel = CallViewModel(callManager: callManager)
               viewModel.delegate = self

               callView = CallView()
               callView.delegate = self
               view.addSubview(callView)

               setupConstraints()
           }

    func setupConstraints() {
        callView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            callView.topAnchor.constraint(equalTo: view.topAnchor),
            callView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            callView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            callView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - CallViewModelDelegate
    func updateUI() {
        DispatchQueue.main.async {
            switch self.viewModel.callState {
            case .connecting:
                // Update UI to show connecting state
                self.callView.statusLabel.text = "Connecting... 👀"
            case .connected:
                // Update UI to show connected state
                self.callView.statusLabel.text = "Connected ✅"
                self.callView.callButton.setTitle("End Call", for: .normal)
            case .disconnected:
                // Update UI to show disconnected state
                self.callView.statusLabel.text = "Disconnected ❌"
                self.callView.callButton.setTitle("Call", for: .normal)
            default:
                break
            }
        }
    }

    // MARK: - CallViewDelegate
    func didTapCallButton() {
        viewModel.toggleCallState()
//        updateUI()
    }
}

extension CallViewController: AgoraRtcEngineDelegate {
// Implement Agora delegate methods here
}

extension CallViewController: CXProviderDelegate {
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Handle answer call action (e.g., join Agora channel)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Handle end call action (e.g., leave Agora channel)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        // Start audio session handling for the call
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        // End audio session handling for the call
    }
    
    func providerDidReset(_ provider: CXProvider) {
        // Handle provider reset if needed
    }
}
