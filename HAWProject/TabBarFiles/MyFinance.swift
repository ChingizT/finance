import Foundation
import UIKit
import SnapKit

class MyFinCabViewController: UIViewController {
    
    let netWorkManager = NetworkManager.shared
    var exchangeData: ExchangeData?
    
    var selectedCurrencyFrom: String?
    var selectedCurrencyTo: String?
    
    var isCurrencyFromExpanded = false
    var isCurrencyToExpanded = false
    
    lazy var exchangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "San Francisco", size: 14)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.textColor = .black
        textField.placeholder = "Введите сумму"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    lazy var currencyFromButton: UIButton = {
        let button = UIButton()
        button.setTitle("Валюта", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(currencyFromButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var currencyToButton: UIButton = {
        let button = UIButton()
        button.setTitle("Валюта", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(currencyToButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var currencyFromTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = 1
        return tableView
    }()
    
    lazy var currencyToTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tag = 2
        return tableView
    }()
    
    lazy var convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("↑↓ Конвертировать", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        button.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "San Francisco", size: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
   
    lazy var goButton: UIButton = {
        let button = UIButton()
        button.setTitle("Калькулятор: Инвестиционный", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .grayCustom
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapp), for: .touchUpInside)
        return button
    }()
    
    lazy var pushButton: UIButton = {
        let button = UIButton()
        button.setTitle("Калькулятор: Срок Накопления", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .grayCustom
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var creditButton: UIButton = {
        let button = UIButton()
        button.setTitle("Калькулятор: Кредитный", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .grayCustom
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapMe), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadExchangeData()
    }
    
    private func setUI() {
       
    view = backImage
    backImage.addSubview(goButton)
    backImage.addSubview(pushButton)
    backImage.addSubview(creditButton)
        
        backImage.addSubview(exchangeLabel)
        backImage.addSubview(amountTextField)
        backImage.addSubview(currencyFromButton)
        backImage.addSubview(currencyToButton)
        backImage.addSubview(currencyFromTableView)
        backImage.addSubview(currencyToTableView)
        backImage.addSubview(convertButton)
        backImage.addSubview(resultLabel)
        
    setConstraints()
    }
    
    private func setConstraints() {
    
        goButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
        
        pushButton.snp.makeConstraints { make in
            make.top.equalTo(goButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
        
        creditButton.snp.makeConstraints { make in
            make.top.equalTo(pushButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
        
        exchangeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(convertButton.snp.bottom).offset(-210)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20) }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(exchangeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(100)
            make.width.equalTo(200) }
        
        currencyFromButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField)
            make.left.equalTo(amountTextField.snp.right).offset(8)
           make.right.equalToSuperview().offset(-20)
            make.height.equalTo(amountTextField) }
        
        currencyFromTableView.snp.makeConstraints { make in
            make.top.equalTo(currencyFromButton.snp.bottom).offset(10)
            make.left.equalTo(currencyFromButton.snp.left)
            make.right.equalTo(currencyFromButton.snp.right)
            make.height.equalTo(0) }
        
        currencyToButton.snp.makeConstraints { make in
            make.top.equalTo(currencyFromTableView.snp.bottom).offset(5)
            make.left.equalTo(amountTextField.snp.right).offset(8)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(amountTextField) }
        
        currencyToTableView.snp.makeConstraints { make in
            make.top.equalTo(currencyToButton.snp.bottom).offset(10)
            make.left.equalTo(currencyToButton.snp.left)
            make.right.equalTo(currencyToButton.snp.right)
            make.height.equalTo(0) }
        
        convertButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-115)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(100) }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-160) }
    }
    
 @objc func buttonTapp() {
    print("Tapped")
    navigationController?.pushViewController(InvestCalculatorViewController(), animated: true)
}
    
    @objc func buttonTapped() {
       print("Tapped")
       navigationController?.pushViewController(InvestCalculatorSecondViewController(), animated: true)
}

    @objc func tapMe() {
       print("Tapped")
       navigationController?.pushViewController(CreditCalculatorViewController(), animated: true)
   }

    @objc func currencyFromButtonTapped() {
            isCurrencyFromExpanded.toggle()
            UIView.animate(withDuration: 0.3) {
                self.currencyFromTableView.isHidden = !self.isCurrencyFromExpanded
                self.currencyFromTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.isCurrencyFromExpanded ? 150 : 0)
                    }
                }
            }
            
    @objc func currencyToButtonTapped() {
            isCurrencyToExpanded.toggle()
            UIView.animate(withDuration: 0.3) {
                self.currencyToTableView.isHidden = !self.isCurrencyToExpanded
                self.currencyToTableView.snp.updateConstraints { make in
                    make.height.equalTo(self.isCurrencyToExpanded ? 150 : 0)
                    }
                }
            }
            
    @objc func convertButtonTapped() {
            guard let amountText = amountTextField.text, let amount = Double(amountText),
                let selectedCurrencyFrom = selectedCurrencyFrom, let selectedCurrencyTo = selectedCurrencyTo,
                let rates = exchangeData?.rates else {
                    resultLabel.text = "Ошибка ввода данных"
                    return
                }

    guard let rateFrom = rates[selectedCurrencyFrom], let rateTo = rates[selectedCurrencyTo] else {
    resultLabel.text = "Ошибка с курсами валют"
        return
}
                        
        let usdAmount = amount / rateFrom
        let convertedAmount = usdAmount * rateTo
        resultLabel.text = String(format: "%.2f", convertedAmount)
}
        private func loadExchangeData() {
        netWorkManager.getExchangeData { [weak self] exchangeData in
        guard let exchangeData = exchangeData else {
        return
}

    DispatchQueue.main.async {
        self?.exchangeData = exchangeData
        self?.currencyFromTableView.reloadData()
        self?.currencyToTableView.reloadData()
            }
        }
    }
}

extension MyFinCabViewController: UITableViewDelegate, UITableViewDataSource {
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return exchangeData?.rates.count ?? 0
            }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            if let exchangeData = exchangeData {
                let currencies = Array(exchangeData.rates.keys)
                cell.textLabel?.text = currencies[indexPath.row]
            }
            return cell
        }
            
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let exchangeData = exchangeData {
                let currencies = Array(exchangeData.rates.keys)
                if tableView.tag == 1 {
                    selectedCurrencyFrom = currencies[indexPath.row]
                    currencyFromButton.setTitle(selectedCurrencyFrom, for: .normal)
                    } else if tableView.tag == 2 {
                        selectedCurrencyTo = currencies[indexPath.row]
                        currencyToButton.setTitle(selectedCurrencyTo, for: .normal)
                    }
                    tableView.isHidden = true
                    tableView.snp.updateConstraints { make in
                        make.height.equalTo(0)
            }
        }
    }
}


