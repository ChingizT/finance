import UIKit
import SnapKit

class CreditCalculatorViewController: UIViewController {
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var summaZaimaLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма кредита"
        label.font = UIFont(name: "San Francisco", size: 24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var summaZaimaTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 4
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.placeholder = "Введите сумму"
        return textField
    }()
    
    lazy var srokCreditaLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок кредита (лет)"
        label.font = UIFont(name: "San Francisco", size: 24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var srokCreditaTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 4
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.placeholder = "Введите срок"
        return textField
    }()
    
    lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.text = "% ставка годовых"
        label.font = UIFont(name: "San Francisco", size: 24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var percentTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 15
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowRadius = 4
        textField.textColor = .black
        textField.keyboardType = .decimalPad
        textField.placeholder = "Введите процент"
        return textField
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "San Francisco", size: 24)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Рассчитать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(calculateMonthly), for: .touchUpInside)
        return button
    }()
    
    lazy var primechanieLabel: UILabel = {
        let label = UILabel()
        label.text = "* Кредитный калькулятор - это удобный инструмент для быстрого самостоятельного расчета кредита онлайн. Калькулятор универсален, не имеет значения тип займа и в каком банке вы будете брать кредит."
        label.font = UIFont(name: "San Francisco", size: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        view = backImage
        backImage.addSubview(summaZaimaLabel)
        backImage.addSubview(summaZaimaTextField)
        backImage.addSubview(srokCreditaLabel)
        backImage.addSubview(srokCreditaTextField)
        backImage.addSubview(percentLabel)
        backImage.addSubview(percentTextField)
        backImage.addSubview(resultLabel)
        backImage.addSubview(calculateButton)
        backImage.addSubview(primechanieLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        summaZaimaLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview() }
        
        summaZaimaTextField.snp.makeConstraints { make in
            make.top.equalTo(summaZaimaLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        srokCreditaLabel.snp.makeConstraints { make in
            make.top.equalTo(summaZaimaTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        srokCreditaTextField.snp.makeConstraints { make in
            make.top.equalTo(srokCreditaLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        percentLabel.snp.makeConstraints { make in
            make.top.equalTo(srokCreditaTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        percentTextField.snp.makeConstraints { make in
            make.top.equalTo(percentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(120) }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(percentTextField.snp.bottom).offset(40)
            make.centerX.equalToSuperview() }
        
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70)
            make.height.equalTo(40) }
        
        primechanieLabel.snp.makeConstraints { make in
            make.top.equalTo(calculateButton.snp.bottom).offset(100)
            make.leading.trailing.equalToSuperview().inset(12) }
    }
    
    @objc func calculateMonthly() {
        guard let summaZaimatText = summaZaimaTextField.text, let summaZaima = Double(summaZaimatText),
              let srokCreditaText = srokCreditaTextField.text, let srokCredita = Double(srokCreditaText),
              let percentText = percentTextField.text, let percent = Double(percentText) else {
            resultLabel.text = "Введите корректные данные."
            return
        }
        
        let monthlyPayment = calculateMonthlyPayment(summaZaima: summaZaima, srokCredita: srokCredita, percent: percent)
        resultLabel.text = String(format: "Ежемесячный платеж: %.2f", monthlyPayment)
        
        UIView.animate(withDuration: 0.3) {
            self.resultLabel.alpha = 1
        }
    }
    
    private func calculateMonthlyPayment(summaZaima: Double, srokCredita: Double, percent: Double) -> Double {
        let monthlyRate = percent / 100 / 12
        let numberOfPayments = srokCredita * 12
        let denominator = pow(1 + monthlyRate, numberOfPayments) - 1
        let monthlyPayment = summaZaima * (monthlyRate + (monthlyRate / denominator))
        return monthlyPayment
    }
}

