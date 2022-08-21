//
//  ProfileViewController.swift
//  SurfEducationProject
//
//  Created by Malygin Georgii on 03.08.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        showLogoutAlert()
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    // MARK: - Private methods
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Внимание", message: "Вы точно хотите выйти из приложения?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Да, точно", style: .default, handler: { (action) in
            LogoutService().performLogoutRequestAndRemoveAllData() { result in
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            delegate.runAuthFlow()
                        }
                    }
                    
                case .failure:
                    // TODO: - Handle error, if token was not received
                    print(result)
                    break
                }
            }
        }))
        
        alert.preferredAction = alert.actions[1]
        present(alert, animated: true, completion: nil)
    }

}
