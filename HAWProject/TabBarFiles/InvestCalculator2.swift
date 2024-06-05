import UIKit
import SnapKit

class InvestCalculatorSecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var startAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Начальная сумма"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let startAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.cornerRadius = 35
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    lazy var interestRateLabel: UILabel = {
        let label = UILabel()
        label.text = "% годовая ставка"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let interestRateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.cornerRadius = 35
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    lazy var goalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "Желаемая сумма"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let goalAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.layer.cornerRadius = 35
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let reinvestmentPeriodPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let additionalContributionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ежемесячный дополнительный взнос"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Рассчитать", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(calculateInvestmentPeriod), for: .touchUpInside)
        return button
    }()
    
    private let reinvestmentPeriods = ["Нет", "Ежемесячно", "Ежеквартально", "Раз в полгода", "Раз в год"]
    private var selectedReinvestmentPeriod: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reinvestmentPeriodPicker.delegate = self
        reinvestmentPeriodPicker.dataSource = self
        selectedReinvestmentPeriod = reinvestmentPeriods.first
    }
    
    private func setupUI() {
        view = backImage
        backImage.addSubview(startAmountLabel)
        backImage.addSubview(startAmountTextField)
        backImage.addSubview(interestRateLabel)
        backImage.addSubview(interestRateTextField)
        backImage.addSubview(goalAmountLabel)
        backImage.addSubview(goalAmountTextField)
        backImage.addSubview(reinvestmentPeriodPicker)
        backImage.addSubview(additionalContributionTextField)
        backImage.addSubview(resultLabel)
        backImage.addSubview(calculateButton)
        
        startAmountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview() }
        
        startAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(startAmountLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(70) }
        
        interestRateLabel.snp.makeConstraints { make in
            make.top.equalTo(startAmountTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        interestRateTextField.snp.makeConstraints { make in
            make.top.equalTo(interestRateLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(120) }
        
        goalAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(interestRateTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        goalAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(goalAmountLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(70) }
        
        reinvestmentPeriodPicker.snp.makeConstraints { make in
            make.top.equalTo(goalAmountTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(100) }
        
        additionalContributionTextField.snp.makeConstraints { make in
            make.top.equalTo(reinvestmentPeriodPicker.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20) }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(additionalContributionTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20) }
        
        calculateButton.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(70)
            make.height.equalTo(40) }
        
    }
    
    @objc private func calculateInvestmentPeriod() {
        guard let startAmountText = startAmountTextField.text, let startAmount = Double(startAmountText),
              let interestRateText = interestRateTextField.text, let interestRate = Double(interestRateText),
              let goalAmountText = goalAmountTextField.text, let goalAmount = Double(goalAmountText),
              let additionalContributionText = additionalContributionTextField.text, let additionalContribution = Double(additionalContributionText) else {
            resultLabel.text = "Please enter valid numbers"
            return
        }
        
        let monthlyRate = (interestRate / 100) / 12
        var months = 0
        var amount = startAmount
        var reinvestmentPeriodMonths: Int
        
        switch selectedReinvestmentPeriod {
        case "None":
            reinvestmentPeriodMonths = 0
        case "Monthly":
            reinvestmentPeriodMonths = 1
        case "Quarterly":
            reinvestmentPeriodMonths = 3
        case "Semi-Annually":
            reinvestmentPeriodMonths = 6
        case "Annually":
            reinvestmentPeriodMonths = 12
        default:
            reinvestmentPeriodMonths = 0
        }
        
        while amount < goalAmount {
            amount += amount * monthlyRate
            if reinvestmentPeriodMonths > 0 && months % reinvestmentPeriodMonths == 0 && months != 0 {
                amount += additionalContribution
            }
            months += 1
        }
        
        let years = months / 12
        let remainingMonths = months % 12
        
        resultLabel.text = "Вам потребуется \(years) лет и \(remainingMonths) месяцев для достижения цели."
    }
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reinvestmentPeriods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reinvestmentPeriods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedReinvestmentPeriod = reinvestmentPeriods[row]
    }
}

