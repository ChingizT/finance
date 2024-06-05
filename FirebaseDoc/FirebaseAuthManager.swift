import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SnapKit

class LoginViewController: UIViewController {
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "newintro")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = backImage
        backImage.addSubview(emailTextField)
        backImage.addSubview(passwordTextField)
        backImage.addSubview(loginButton)
        backImage.addSubview(registerButton)
        backImage.addSubview(forgotPasswordButton)
       
        
        emailTextField.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-270)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
       
    }
    
    @objc func forgotPasswordTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            // Введите адрес электронной почты
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите адрес электронной почты", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Ошибка отправки инструкций по сбросу пароля
                print("Ошибка отправки инструкций по сбросу пароля: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                // Инструкции по сбросу пароля отправлены
                let alert = UIAlertController(title: "Успешно", message: "Инструкции по сбросу пароля отправлены на ваш адрес электронной почты", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

    
    @objc func loginTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите email и пароль", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Проверка наличия регистрации у пользователя
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error as NSError?, error.code == AuthErrorCode.userNotFound.rawValue {
                
                let alert = UIAlertController(title: "Ошибка", message: "Пользователь с таким email не зарегистрирован", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }   else if let error = error {
                print("Ошибка входа: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(alert, animated: true)
                        } else {
                            // Успешный вход
                            self.transitionToMainApp()
                        }
                    }
                }
                
    
    @objc func registerTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите email и пароль", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Ошибка регистрации: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else if let authResult = authResult {
                self.saveUserToDatabase(user: authResult.user)
                self.transitionToMainApp()
            }
        }
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Ошибка входа: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else if let authResult = authResult {
                self.transitionToMainApp()
            }
        }
    }
    
    func saveUserToDatabase(user: User) {
        let ref = Database.database().reference().child("users")
        let usersRef = ref.child("users").child(user.uid)
        let values = ["email": user.email]
        
        usersRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("Ошибка сохранения данных пользователя: \(error.localizedDescription)")
            } else {
                print("Данные пользователя успешно сохранены в базу данных")
            }
        }
    }
    
    func transitionToMainApp() {
        let tabBarController = TabBarController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil)
        }
    }
    
}

