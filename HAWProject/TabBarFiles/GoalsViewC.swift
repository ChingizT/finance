import UIKit
import FirebaseFirestore
import FirebaseAuth
import SnapKit

class GoalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var goals: [(id: String, text: String, date: Date, amount: Double)] = []
    let db = Firestore.firestore()

    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название цели"
        textField.borderStyle = .roundedRect
        textField.alpha = 0
        return textField
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.alpha = 0
        return datePicker
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    lazy var goalsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить цель", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .grayCustom
        button.addTarget(self, action: #selector(goalsTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Необходимая сумма"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.alpha = 0
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadGoals()
    }
  
    private func setUI() {
        view = backImage
        backImage.addSubview(goalTextField)
        backImage.addSubview(datePicker)
        backImage.addSubview(tableView)
        backImage.addSubview(goalsButton)
        backImage.addSubview(amountTextField)
        setConstraints()
    }
    
    private func setConstraints() {
        goalTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(goalTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(40)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(goalsButton)
            make.height.equalTo(150)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        goalsButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-110)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let goal = goals[indexPath.row]
            db.collection("goals").document(goal.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    self.goals.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    @objc func goalsTapped() {
        self.goalTextField.isHidden = false
        self.datePicker.isHidden = false
        self.amountTextField.isHidden = false

        UIView.animate(withDuration: 0.3, animations: {
            self.goalTextField.alpha = 1
            self.datePicker.alpha = 1
            self.amountTextField.alpha = 1
        }) { _ in
            self.goalTextField.becomeFirstResponder()
        }

        goalsButton.setTitle("Сохранить цель", for: .normal)
        goalsButton.removeTarget(self, action: #selector(goalsTapped), for: .touchUpInside)
        goalsButton.addTarget(self, action: #selector(saveGoal), for: .touchUpInside)
    }
        
    @objc func saveGoal() {
        print("Сохранение цели начато")
        guard let user = Auth.auth().currentUser else {
            print("Пользователь не найден")
            return
        }
        
        guard let goalText = goalTextField.text, !goalText.isEmpty else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите название цели", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            print("Название цели пустое")
            return
        }
        
        guard let amountText = amountTextField.text, !amountText.isEmpty, let amount = Double(amountText) else {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, введите корректную сумму", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            print("Некорректная сумма")
            return
        }
        
        let goalDate = datePicker.date
        
        let goalData: [String: Any] = [
            "userId": user.uid,
            "text": goalText,
            "date": goalDate,
            "amount": amount
        ]
        
        var ref: DocumentReference? = nil
        ref = db.collection("goals").addDocument(data: goalData) { error in
            if let error = error {
                print("Ошибка добавления документа: \(error)")
            } else {
                print("Документ добавлен с ID: \(ref!.documentID)")
                self.goals.append((id: ref!.documentID, text: goalText, date: goalDate, amount: amount))
                self.tableView.reloadData()
            }
        }

        goalTextField.text = ""
        amountTextField.text = ""

        UIView.animate(withDuration: 0.3, animations: {
            self.goalTextField.alpha = 0
            self.datePicker.alpha = 0
            self.amountTextField.alpha = 0
        }) { _ in
            self.goalTextField.isHidden = true
            self.datePicker.isHidden = true
            self.amountTextField.isHidden = true
            self.goalTextField.resignFirstResponder()
        }

        goalsButton.setTitle("Добавить цель", for: .normal)
        goalsButton.removeTarget(self, action: #selector(saveGoal), for: .touchUpInside)
        goalsButton.addTarget(self, action: #selector(goalsTapped), for: .touchUpInside)
    }
    
    private func loadGoals() {
        guard let user = Auth.auth().currentUser else { return }

        db.collection("goals").whereField("userId", isEqualTo: user.uid).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.goals.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let text = data["text"] as? String ?? ""
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let amount = data["amount"] as? Double ?? 0.0
                    let id = document.documentID
                    self.goals.append((id: id, text: text, date: date, amount: amount))
                }
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let goal = goals[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        cell.textLabel?.text = "\(goal.text) - \(dateFormatter.string(from: goal.date)) - \(goal.amount)."
        return cell
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

