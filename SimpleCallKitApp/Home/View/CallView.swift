//
//  CallManager.swift
//  SimpleCallKitApp
//
//  Created by Pajaziti Labinot on 10.12.23..
//

import Foundation
import UIKit

protocol CallViewDelegate: AnyObject {
    func didTapCallButton()
}

class CallView: UIView {
    weak var delegate: CallViewDelegate?

    let callButton = UIButton()
    let statusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBlue

        // Configure callButton
        callButton.setTitle("Call", for: .normal)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        addSubview(callButton)

        // Configure statusLabel
        statusLabel.textAlignment = .center
        statusLabel.textColor = .black
        addSubview(statusLabel)

        // Constraints for callButton
        callButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            callButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            callButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            callButton.widthAnchor.constraint(equalToConstant: 100),
            callButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        // Constraints for statusLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: callButton.bottomAnchor, constant: 20)
        ])
    }

    @objc func callButtonTapped() {
        delegate?.didTapCallButton()
    }
}
