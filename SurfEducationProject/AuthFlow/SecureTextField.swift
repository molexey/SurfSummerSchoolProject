//
//  SecureTextField.swift
//  SurfEducationProject
//
//  Created by molexey on 19.08.2022.
//

import UIKit

class SecureTextField: MDFilledTextField {
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let offset = 16
        let width = 24
        let height = width
        let x = Int(bounds.width) - width - offset
        let y = offset
        let rightViewBounds = CGRect(x: x, y: y, width: width, height: height)
        return rightViewBounds
    }
    
    // MARK: Views
        
    private let showTextButton = UIButton(type: .custom)

    // MARK: Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        initializeSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initializeSetup()
    }
    
    // MARK: Private methods
    
    private func initializeSetup() {
        isSecureTextEntry = true
        configureShowTextButton()
    }
    
    private func configureShowTextButton() {
        showTextButton.setImage(UIImage(named: "showPassword"), for: .normal)
        showTextButton.setImage(UIImage(named: "hidePassword"), for: .selected)
        showTextButton.addTarget(self, action: #selector(showTextButtonTapped), for: .touchUpInside)
        
        self.rightView = showTextButton
        self.rightViewMode = .always
    }
    
    @objc private func showTextButtonTapped(_ sender: UIButton) {
        self.isSecureTextEntry.toggle()
        showTextButton.isSelected.toggle()
    }

}
