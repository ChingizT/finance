import UIKit
import SnapKit

protocol DatePickerViewControllerDelegate: AnyObject {
    func didUpdateIncome(_ income: Double, period: Double)
}

class DatePickerViewController: UIViewController {
    
    weak var delegate: DatePickerViewControllerDelegate?
    var userIncome: Double = 0 // Переменная для хранения дохода пользователя
    var userPeriod: Double = 1 // Период в днях по умолчанию
    
    lazy var periodTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.textColor = .black
        textField.placeholder = "Введите период в днях"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Текущий доход: \(userIncome) минут"
        return label
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var incomePerSecondLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        presentIncomeAlert()
    }
    
    private func setUI() {
        view.addSubview(periodTextField)
        view.addSubview(incomeLabel)
        view.addSubview(saveButton)
        view.addSubview(incomePerSecondLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        periodTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        incomeLabel.snp.makeConstraints { make in
            make.top.equalTo(periodTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(incomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        incomePerSecondLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    @objc func saveButtonTapped() {
        guard let periodText = periodTextField.text, let period = Double(periodText) else {
            print("Ошибка ввода данных")
            return
        }
        
        userPeriod = period
        calculateIncomePerSecond()
        delegate?.didUpdateIncome(userIncome, period: userPeriod)
        navigationController?.popViewController(animated: true)
    }
    
    private func presentIncomeAlert() {
        let alert = UIAlertController(title: "Доход", message: "Введите сумму дохода", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Сумма дохода"
            textField.keyboardType = .decimalPad
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let incomeText = alert.textFields?.first?.text, let income = Double(incomeText) {
                self.userIncome = income
                self.incomeLabel.text = "Текущий доход: \(self.userIncome)"
                self.calculateIncomePerSecond()
            }
        }
        
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func calculateIncomePerSecond() {
        let secondsInADay = 86400.0 // 24 * 60 * 60
        let totalSeconds = userPeriod * secondsInADay
        let incomePerSecond = userIncome / totalSeconds
        let incomePerMinute = incomePerSecond * 60
        let incomePerHour = incomePerMinute * 60
        let incomePerDay = incomePerHour * 24
        
        incomePerSecondLabel.text = String(format: """
            Доход за период: \(userIncome)
            Доход в секунду: %.6f
            Доход в минуту: %.6f
            Доход в час: %.6f
            Доход в день: %.6f
            """, incomePerSecond, incomePerMinute, incomePerHour, incomePerDay)
    }
}
