//
//  LoginViewController.swift
//  ecommerce-demo
//
//  Created by Christina on 9/19/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import IBAnimatable

enum LoginVCStrings {
    static var login = "login"
    static var register = "register"
    static var forgot = "forgot"
    static var loginFailed = "loginFailed"
}

struct LoginState {
    var email: String?
    var password: String?
    
    func isValidEmail() -> Bool {
        guard let email = email else {
            return false
        }
        return email.isValidEmail
    }
    
    func isValidPassword() -> Bool {
        if password == nil ||
        password == ""  {
            return false
        }
        return true
    }
    
}

class LoginViewController: DemoViewController {

    @IBOutlet weak var emailField: AnimatableTextField?
    @IBOutlet weak var passwordField: AnimatableTextField?
    @IBOutlet weak var loginButton: LoadingButton?
    @IBOutlet weak var forgotPasswordButton: LoadingButton?
    var state: LoginState = LoginState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addKeyboardNotificationListeners()
        setupTextFields()
        setupButtons()
        initialState()
    }
    
    func setupTextFields() {
        emailField?.delegate = self
        emailField?.textColor = .white
        emailField?.backgroundColor = UIColor.dim()
        emailField?.placeholder = "email".localized()
        emailField?.placeholderColor = .lightGray
        emailField?.autocorrectionType = .no
        passwordField?.delegate = self
        passwordField?.textColor = .white
        passwordField?.isSecureTextEntry = true
        passwordField?.backgroundColor = UIColor.dim()
        passwordField?.autocorrectionType = .no
        passwordField?.placeholder = "password".localized()
        passwordField?.placeholderColor = .lightGray
    }
    
    func setupButtons() {
        loginButton?.setTitle("login".localized(), for: .normal)
        loginButton?.setTitleColor(.white, for: .normal)
        loginButton?.backgroundColor = UIColor.Emporium.purple
        forgotPasswordButton?.setTitle("forgot_password".localized(), for: .normal)
        forgotPasswordButton?.setTitleColor(.white, for: .normal)        
    }
    
    func triggerStateChange() {
        stateChanged(self.state)
    }
    
    private func initialState() {
        DispatchQueue.main.async { [weak self] in
            self?.emailField?.becomeFirstResponder()
            self?.passwordField?.alpha = 0.0
            self?.loginButton?.alpha = 0.0
        }
        //forgotPasswordButton?.alpha = 0.0 - uncomment once we have forgotPassword hooked up

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        passwordField?.text = nil
        loginButton?.alpha = 0.0
        super.viewWillDisappear(animated)
    }
    
    private func stateChanged(_ state: LoginState) {
        
        if state.isValidEmail() == true {
            passwordField?.reveal()
        } else {
            passwordField?.hide()
            loginButton?.hide()
        }
        if state.isValidPassword() == true {
            loginButton?.reveal()
        } else {
            loginButton?.hide()
        }
        
    }
    
    func invalidLogin() {
        self.passwordField?.animate(.shake(repeatCount: 1), force:0.5)
        self.passwordField?.text = ""
        forgotPasswordButton?.reveal()
    }
    
    func validLogin(){
        // TODO: Animation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginButton?.hideLoading()
    }
    
    func startLoading(_ message: String) {
        loginButton?.showLoading()
    }
    
    func stopLoading() {
        loginButton?.hideLoading()
    }

    @IBAction func triggerLogin(_ sender: Any?) {
        self.triggerEmptyBlock(named: LoginVCStrings.login)
    }

//    @objc override func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else {return}
//        guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {return}
//        let keyboardFrame = keyboardSize.cgRectValue
//        if self.view.frame.origin.y == 0{
//            UIView.animate(withDuration: 0.5, animations: {
//                self.view.frame.origin.y -= keyboardFrame.height/2
//            })
//        }
//    }
//
//    @objc override func keyboardWillHide(notification: NSNotification) {
//        if self.view.frame.origin.y != 0{
//            UIView.animate(withDuration: 0.5, animations: {
//                self.view.frame.origin.y = 0
//            })
//        }
//    }
    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    // TODO: login failed
    @IBAction func triggerLoginFailed(_ sender: Any?){
        DispatchQueue.main.async {
            self.invalidLogin()
            self.stopLoading()
            self.loginButton?.hideLoading()
        }
    }
    
    // TODO: registration
    @IBAction func triggerRegister(_ sender: Any?) {
        self.triggerEmptyBlock(named: LoginVCStrings.register)
    }
    
    // TODO: forgot password
    @IBAction func triggerForgotPassword(_ sender: Any?) {
        self.triggerEmptyBlock(named: LoginVCStrings.register)
    }
    
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 &&
            string == "" {
            updated(textField: textField,
                    string: string)
        } else {
            updated(textField: textField,
                    string: textField.text)
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updated(textField: textField,
                string: textField.text)
    }
    
    func updated(textField: UITextField,
                 string: String?) {
        if textField == emailField { self.state.email = string }
        if textField == passwordField { self.state.password = string }
        triggerStateChange()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

