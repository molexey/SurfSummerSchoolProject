//
//  LoginViewController.swift
//  SurfEducationProject
//
//  Created by molexey on 18.08.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Views
    
    @IBOutlet weak var loginTextField: MDFilledTextField!
    @IBOutlet weak var passwordTextField: SecureTextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let login = loginTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let credentials = AuthRequestModel(phone: login, password: password)
        
        AuthService()
            .performLoginRequestAndSaveToken(credentials: credentials) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            delegate.runMainFlow()
                        }
                    }
                    
                case .failure:
                    // TODO: - Handle error, if token was not received
                    break
                }
            }
        
        print(login, password)
    }
    
    private func setupUI() {
        self.navigationItem.title = "Вход"
    }
    
}
