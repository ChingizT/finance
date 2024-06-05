import UIKit
import FirebaseAuth
import SnapKit

class HomeViewController: UIViewController, DatePickerViewControllerDelegate {
    
    var userTime: Double = 10000 // Начальное количество времени в минутах
    var incomePerSecond: Double = 0 // Доход в секунду
    var timer: Timer?
    
    var earnedToday: Double = 0 // Сумма заработанных средств за сегодня
    var spentToday: Double = 0 // Сумма потраченных средств сегодня
    var invested: Double = 0 // Сумма инвестированных средств
    
    var remainingToSpend: Double {
        return earnedToday - spentToday
    }
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "FINWISE"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .tabBarItemAccent
        label.numberOfLines = 0
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("⍇", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Оставшееся время: \(userTime) минут"
        return label
    }()
    
    lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Текущий доход: 0 минут"
        return label
    }()
    
    lazy var enterIncomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ввести доход", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(enterIncomeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var earnedTodayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var spentTodayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var remainingToSpendLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateLabels()
    }
    
    private func setUI() {
        view = backImage
        backImage.addSubview(nameLabel)
        backImage.addSubview(logoutButton)
        backImage.addSubview(remainingTimeLabel)
        backImage.addSubview(incomeLabel)
        backImage.addSubview(enterIncomeButton)
        backImage.addSubview(earnedTodayLabel)
        backImage.addSubview(spentTodayLabel)
        backImage.addSubview(remainingToSpendLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.left.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(90)
            make.centerX.equalToSuperview()
        }
        
        remainingTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        incomeLabel.snp.makeConstraints { make in
            make.top.equalTo(remainingTimeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        enterIncomeButton.snp.makeConstraints { make in
            make.top.equalTo(incomeLabel.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        earnedTodayLabel.snp.makeConstraints { make in
            make.top.equalTo(enterIncomeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        spentTodayLabel.snp.makeConstraints { make in
            make.top.equalTo(earnedTodayLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        remainingToSpendLabel.snp.makeConstraints { make in
            make.top.equalTo(spentTodayLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    @objc func enterIncomeButtonTapped() {
        let datePickerVC = DatePickerViewController()
        datePickerVC.delegate = self
        navigationController?.pushViewController(datePickerVC, animated: true)
    }
    
    @objc func logoutTapped() {
        do {
            try Auth.auth().signOut()
            // Вернуть пользователя на экран входа
            if let window = UIApplication.shared.windows.first {
                let loginViewController = LoginViewController()
                window.rootViewController = loginViewController
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil)
            }
        } catch let signOutError as NSError {
            print("Ошибка выхода: \(signOutError.localizedDescription)")
            let alert = UIAlertController(title: "Ошибка", message: signOutError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    private func updateLabels() {
        remainingTimeLabel.text = "Оставшееся время: \(userTime) минут"
        incomeLabel.text = String(format: "Доход в секунду: %.6f минут", incomePerSecond * 60)
        earnedTodayLabel.text = String(format: "Заработано сегодня: %.2f минут", earnedToday)
        spentTodayLabel.text = String(format: "Потрачено сегодня: %.2f минут", spentToday)
        remainingToSpendLabel
        remainingToSpendLabel.text = String(format: "Осталось потратить: %.2f минут", remainingToSpend)
    }
    
    private func startIncomeTimer() {
        timer?.invalidate() // Останавливаем предыдущий таймер, если он был
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateIncome), userInfo: nil, repeats: true)
    }
    
    @objc private func updateIncome() {
        userTime += incomePerSecond / 60 // Обновляем доход каждую секунду
        earnedToday += incomePerSecond / 60 // Обновляем сумму заработанного за сегодня
        updateLabels()
    }
    
    // Реализация делегата
    func didUpdateIncome(_ income: Double, period: Double) {
        let secondsInADay = 86400.0 // 24 * 60 * 60
        let totalSeconds = period * secondsInADay
        incomePerSecond = income / totalSeconds
        startIncomeTimer() // Запускаем таймер
    }
}
