//
//  ViewController.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 10.12.23..
//

import UIKit
import AVFoundation

class CallViewController: UIViewController {
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
}

// MARK: - CallViewModelDelegate
extension CallViewController: CallViewModelDelegate {
    func updateUI() {
        DispatchQueue.main.async {
            switch self.viewModel.callState {
            case .connecting:
                self.callView.statusLabel.text = "Connecting... 👀"
            case .connected:
                self.callView.statusLabel.text = "Connected ✅"
                self.callView.callButton.setTitle("End Call", for: .normal)
            case .disconnected:
                self.callView.statusLabel.text = "Disconnected ❌"
                self.callView.callButton.setTitle("Call", for: .normal)
            default:
                break
            }
        }
    }

}

// MARK: - CallViewDelegate
extension CallViewController: CallViewDelegate {
    func didTapCallButton() {
        viewModel.toggleCallState()
    }
}
