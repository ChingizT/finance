import UIKit

class InvestCalculatorViewController: UIViewController {
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
  
    lazy var summaLabel: UILabel = {
        let label = UILabel()
        label.text = "Стартовый капитал"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var firstTextField: UITextField = {
        let textfield = UITextField()
        textfield.layer.shadowColor = UIColor.black.cgColor
        textfield.layer.shadowOffset = CGSize(width: 0, height: 2)
        textfield.layer.shadowOpacity = 0.3
        textfield.layer.shadowRadius = 4
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = .black
        textfield.placeholder = ""
        return textfield
    }()
    
    lazy var percentLabel: UILabel = {
        let label = UILabel()
        label.text = "% ставка годовых"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var percentTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = .black
        textfield.placeholder = ""
        return textfield
    }()
    
    lazy var popolnenieLabel: UILabel = {
        let label = UILabel()
        label.text = "Ежемесячные пополнения"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var popolnenieTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = .black
        textfield.placeholder = ""
        return textfield
    }()
    
    let popolnenieSegmentedControl = UISegmentedControl(items: ["Ежемесячно", "Ежеквартально", "Раз в полгода", "Ежегодно"])
    
    
    lazy var reinvestLabel: UILabel = {
        let label = UILabel()
        label.text = "Период Реинвестирования"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .tabBarItemLight
        label.numberOfLines = 0
        return label
    }()
    
    lazy var reinvestTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 15
        textfield.textColor = .black
        textfield.placeholder = ""
        return textfield
    }()
    
    let reinvestSegmentedControl = UISegmentedControl(items: ["Нет", "Ежемесячно", "Ежеквартально", "Раз в полгода", "Ежегодно"])
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок инвестирования (лет)"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var timeTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 35
        textfield.textColor = .black
        textfield.placeholder = ""
        return textfield
    }()
  
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.alpha = 0
        return label
    }()
    
    lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Рассчитать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        
        popolnenieSegmentedControl.selectedSegmentIndex = 0
        popolnenieSegmentedControl.selectedSegmentTintColor = .white
        popolnenieSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        popolnenieSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

        reinvestSegmentedControl.selectedSegmentIndex = 0
        reinvestSegmentedControl.selectedSegmentTintColor = .white
        reinvestSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        reinvestSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

        view = backImage
        backImage.addSubview(summaLabel)
        backImage.addSubview(firstTextField)
        backImage.addSubview(percentTextField)
        backImage.addSubview(popolnenieLabel)
        backImage.addSubview(popolnenieTextField)
        backImage.addSubview(popolnenieSegmentedControl)
        backImage.addSubview(reinvestLabel)
        backImage.addSubview(reinvestTextField)
        backImage.addSubview(reinvestSegmentedControl)
        backImage.addSubview(timeTextField)
        backImage.addSubview(resultLabel)
        backImage.addSubview(calculateButton)
        backImage.addSubview(percentLabel)
        backImage.addSubview(timeLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        
        summaLabel.snp.makeConstraints {make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview() }
        
        firstTextField.snp.makeConstraints { make in
            make.top.equalTo(summaLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        percentLabel.snp.makeConstraints {make in
            make.top.equalTo(firstTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        percentTextField.snp.makeConstraints { make in
            make.top.equalTo(percentLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        popolnenieLabel.snp.makeConstraints {make in
            make.top.equalTo(percentTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        popolnenieTextField.snp.makeConstraints { make in
            make.top.equalTo(popolnenieLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        popolnenieSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(popolnenieTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10) }
        
        reinvestLabel.snp.makeConstraints {make in
            make.top.equalTo(popolnenieSegmentedControl.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        reinvestTextField.snp.makeConstraints {make in
            make.top.equalTo(reinvestLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        reinvestSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(reinvestTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10) }
        
        timeLabel.snp.makeConstraints {make in
            make.top.equalTo(reinvestSegmentedControl.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(70) }
        
        resultLabel.snp.makeConstraints {make in
            make.top.equalTo(timeTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview() }
        
        calculateButton.snp.makeConstraints {make in
            make.top.equalTo(resultLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(70)
            make.height.equalTo(40) }
        }
    
    @objc func calculateButtonTapped() {
        
        UIView.animate(withDuration: 0.1, animations: {
               self.calculateButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
           }) { _ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.calculateButton.transform = CGAffineTransform.identity
               })
           }
        
        guard let firstText = firstTextField.text,
              let percentText = percentTextField.text,
              let timeText = timeTextField.text,
              let popolnenieText = popolnenieTextField.text,
              let reinvestText = reinvestTextField.text,
              let first = Double(firstText),
              let percent = Double(percentText),
              let time = Double(timeText),
              let popolnenie = Double(popolnenieText),
              let reinvest = Double(reinvestText) else {
            resultLabel.text = "Пожалуйста, введите корректные значения."
            return
    }
        
        let popolnenieS = popolnenieSegmentedControl.selectedSegmentIndex
        let reinvestS = reinvestSegmentedControl.selectedSegmentIndex
        let result = calculateCompoundInterest(first: first, percent: percent, time: time, popolnenie: popolnenie, reinvest: reinvest, popolnenieS: popolnenieS, reinvestS: reinvestS)
        resultLabel.text = String(format: "Конечная сумма: %.2f", result)
    }
    
    func calculateCompoundInterest(first: Double, percent: Double, time: Double, popolnenie: Double, reinvest: Double, popolnenieS: Int, reinvestS: Int) -> Double {
        let months = time * 12
        let popolnenie = reinvest / 12 / 100
        var futureValue = first
        var periodsPerYear = 1.0
        
        switch popolnenie {
        case 1: // Ежемесячно
            periodsPerYear = 12.0
        case 2: // Ежеквартально
            periodsPerYear = 4.0
        case 3: // Раз в полгода
            periodsPerYear = 2.0
        case 4: // Ежегодно
            periodsPerYear = 1.0
        default: // Нет реинвестирования (простой процент)
            periodsPerYear = 0.0
    }
        
        var additionalContributionPeriodsPerYear = 1.0
        
        switch reinvest {
        case 0: // Ежемесячно
            additionalContributionPeriodsPerYear = 12.0
        case 1: // Ежеквартально
            additionalContributionPeriodsPerYear = 4.0
        case 2: // Раз в полгода
            additionalContributionPeriodsPerYear = 2.0
        case 3: // Ежегодно
            additionalContributionPeriodsPerYear = 1.0
        default:
            additionalContributionPeriodsPerYear = 0.0
    }
        
        if periodsPerYear > 0 {
            let compoundPeriods = time * periodsPerYear
            let ratePerPeriod = percent / periodsPerYear / 100
            
            for i in 1...Int(compoundPeriods) {
                if additionalContributionPeriodsPerYear > 0 && i % Int(periodsPerYear / additionalContributionPeriodsPerYear) == 0 {
                    futureValue += reinvest
                }
                futureValue += popolnenie * 12.0 / periodsPerYear
                futureValue *= (1 + ratePerPeriod)
            }
        } else {
            futureValue += popolnenie * 12.0 * time
            if additionalContributionPeriodsPerYear > 0 {
                futureValue += reinvest * time * additionalContributionPeriodsPerYear
            }
            futureValue *= (1 + percent / 100 * time)
        }
        return futureValue
    }
}
