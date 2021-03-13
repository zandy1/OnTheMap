//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/3/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = ""
        passwordTextField.text = ""
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           
           emailTextField.text = ""
           passwordTextField.text = ""
       }
       
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OnTheMapClient.createSessionId(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: self.handleSessionId(success:error:))
       }

    @IBAction func signUpTapped(_ sender: UIButton) {
        UIApplication.shared.openURL(OnTheMapClient.Endpoints.signup.url)
    }
    
    func handleSessionId(success: Bool, error: Error?) {
            setLoggingIn(false)
            if (success) {
                //DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                //}
            }
            else {
                showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    
    func setLoggingIn(_ loggingIn: Bool) {
            if loggingIn {
                activityIndicator.startAnimating()
            }
            else {
                activityIndicator.stopAnimating()
            }
            emailTextField.isEnabled = !loggingIn
            passwordTextField.isEnabled = !loggingIn
            loginButton.isEnabled = !loggingIn
            signInButton.isEnabled = !loggingIn
        }

    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }

    

}

