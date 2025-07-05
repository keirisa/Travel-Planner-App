//
//  LoginViewController.swift
//  Travel Planner App
//
//  Created by Kate Alyssa Joanna L. de Leon on 4/14/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel! 
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        //view.backgroundColor = UIColor.systemGroupedBackground
        
        // Configure title label from storyboard
        titleLabel.text = "Travel Planner"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        
        // Configure text fields and buttons
        [usernameTextField, passwordTextField, loginButton, signupButton].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            $0?.layer.cornerRadius = 8
            $0?.clipsToBounds = true
        }
        
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        // Login Button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        
        // Sign Up Button - Improved styling
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.systemBlue, for: .normal)
        signupButton.backgroundColor = .clear
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        guard let usernameTextField = usernameTextField,
              let passwordTextField = passwordTextField,
              let loginButton = loginButton,
              let signupButton = signupButton,
              let titleLabel = titleLabel else { return }
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Username
            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 180),
            usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Password
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Login Button
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Signup Button
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 200),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter username and password")
            return
        }
        
        if let user = CoreDataManager.shared.loginUser(username: username, password: password) {
            // Store current user
            UserDefaults.standard.set(username, forKey: "currentUser")
            
            // Navigate to main app
            performSegue(withIdentifier: "loginSuccessfull", sender: user)
        } else {
            showAlert(message: "Invalid username or password")
        }
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter username and password")
            return
        }
        
        if CoreDataManager.shared.registerUser(username: username, password: password) {
            showAlert(message: "Registration successful! Please login.", completion: {
                self.passwordTextField.text = ""
            })
        } else {
            showAlert(message: "Username already exists")
        }
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSuccessfull" {
            // Pass the current user to tab bar controller if needed
        }
    }
}
