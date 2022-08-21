//
//  MDFilledTextField.swift
//  SurfEducationProject
//
//  Created by molexey on 18.08.2022.
//  Forked form https://github.com/DannyBloky/textfields
//

import UIKit

private extension TimeInterval {
    static let animation250ms: TimeInterval = 0.25
}

private extension UIColor {
    static let inactive: UIColor = UIColor(displayP3Red: 0xB0 / 255, green: 0xB0 / 255, blue: 0xB0 / 255, alpha: 1)
}

private enum Constants {
    static let offset: CGFloat = -10
    static let placeholderSize: CGFloat = 12
}

class MDFilledTextField: UITextField {
    
    // MARK: - Subviews
    
    private var border = UIView()
    private var floatingLabel = UILabel()
    
//    var showTextButton = UIButton(type: .custom)
    
    // MARK: - Private Properties
    
    private var scale: CGFloat {
        Constants.placeholderSize / fontSize
    }
    
    private var fontSize: CGFloat {
        font?.pointSize ?? 0
    }
    
    private var labelHeight: CGFloat {
        ceil(font?.withSize(Constants.placeholderSize).lineHeight ?? 0)
    }
    
    private var textHeight: CGFloat {
        ceil(font?.lineHeight ?? 0)
    }
    
    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }
    
    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: Constants.offset + labelHeight, left: 18, bottom: Constants.offset, right: 18)
    }
    
    private var labelInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - UITextField
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top + textHeight + textInsets.bottom)
    }
    
    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        updateLabel(animated: false)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .zero
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !isFirstResponder else {
            return
        }
        
        floatingLabel.transform = .identity
        floatingLabel.frame = bounds.inset(by: labelInsets)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        borderStyle = .none
        
        clipsToBounds = true
        backgroundColor = UIColor(displayP3Red: 0xFB / 255, green: 0xFB / 255, blue: 0xFB / 255, alpha: 1)
        
        self.layer.cornerRadius = 10
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        border.backgroundColor = UIColor(displayP3Red: 0xDF / 255, green: 0xDF / 255, blue: 0xDF / 255, alpha: 1)
        border.isUserInteractionEnabled = false
        addSubview(border)
        
        floatingLabel.textColor = .inactive
        floatingLabel.font = font
        floatingLabel.text = placeholder
        floatingLabel.isUserInteractionEnabled = false
        
        addSubview(floatingLabel)
        
        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }
    
    @objc
    private func handleEditing() {
        updateLabel()
        updateBorder()
    }
    
    private func updateBorder() {
        let borderColor = isFirstResponder ? tintColor : .inactive
        UIView.animate(withDuration: .animation250ms) {
            self.border.backgroundColor = borderColor
        }
    }
    
    private func updateLabel(animated: Bool = true) {
        let isActive = isFirstResponder || !isEmpty
        
        let offsetX = -floatingLabel.bounds.width * (1 - scale) / 2
        let offsetY = -floatingLabel.bounds.height * (1 - scale) / 2
        
        let transform = CGAffineTransform(translationX: offsetX, y: offsetY - labelHeight - Constants.offset)
            .scaledBy(x: scale, y: scale)
        
        guard animated else {
            floatingLabel.transform = isActive ? transform : .identity
            return
        }
        
        UIView.animate(withDuration: .animation250ms) {
            self.floatingLabel.transform = isActive ? transform : .identity
        }
    }
    
}
