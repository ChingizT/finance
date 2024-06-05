import UIKit
import FirebaseStorage
import SnapKit

class PoleznoeViewController: UIViewController {
    
    let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "osnovnoy")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
   
   lazy var modul1Button: UIButton = {
        let button = UIButton()
        button.setTitle("Основы личных финансов", for: .normal)
       button.backgroundColor = .grayCustom
       button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(modul1Tap), for: .touchUpInside)
        return button
    }()
    
    lazy var modul2Button: UIButton = {
        let button = UIButton()
        button.setTitle("Доходы и расходы", for: .normal)
        button.backgroundColor = .grayCustom
        button.layer.cornerRadius = 15
         button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(modul2Tap), for: .touchUpInside)
        return button
    }()
    
   lazy var modul3Button: UIButton = {
        let button = UIButton()
        button.setTitle("Сбережения и инвестиции", for: .normal)
        button.backgroundColor = .grayCustom
        button.layer.cornerRadius = 15
         button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(modul3Tap), for: .touchUpInside)
        return button
    }()
    
    lazy var modul4Button: UIButton = {
        let button = UIButton()
        button.setTitle("Управление долгами", for: .normal)
        button.backgroundColor = .grayCustom
        button.layer.cornerRadius = 15
         button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(modul4Tap), for: .touchUpInside)
        return button
    }()
    
    lazy var modul5Label: UILabel = {
        let label = UILabel()
        label.text = "Пенсионное планирование"
        label.font = UIFont(name: "San Francisco", size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пенсионное планирование", for: .normal)
        button.backgroundColor = .grayCustom
        button.layer.cornerRadius = 15
         button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(downloadFile), for: .touchUpInside)
        return button
    }()
    
   lazy var topBookButton: UIButton = {
        let button = UIButton()
        button.setTitle("ТОП Книг о Финансах", for: .normal)
        button.backgroundColor = .grayCustom
        button.layer.cornerRadius = 15
         button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(topBookTapp), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = backImage
        backImage.addSubview(modul1Button)
        backImage.addSubview(modul2Button)
        backImage.addSubview(modul3Button)
        backImage.addSubview(modul4Button)
        backImage.addSubview(modul5Label)
        backImage.addSubview(downloadButton)
        backImage.addSubview(topBookButton)
        
        modul1Button.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(140)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
       
        modul2Button.snp.makeConstraints { make in
            make.top.equalTo(modul1Button.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
    
        modul3Button.snp.makeConstraints { make in
            make.top.equalTo(modul2Button.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
    
        modul4Button.snp.makeConstraints { make in
            make.top.equalTo(modul3Button.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(modul4Button.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
        
        topBookButton.snp.makeConstraints { make in
            make.top.equalTo(downloadButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(70) }
        
    }
   
    @objc func modul1Tap() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("Основы личных финансов.rtf")
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка получения URL файла: \(error.localizedDescription)")
            } else if let url = url {
                self.fetchFile(from:url)
            }
        }
        
    }
    
    @objc func modul2Tap() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("Доходы и расходы.rtf")
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка получения URL файла: \(error.localizedDescription)")
            } else if let url = url {
                self.fetchFile(from:url)
            }
        }
        
    }
    
    @objc func modul3Tap() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("Сбережения и инвестиции.rtf")
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка получения URL файла: \(error.localizedDescription)")
            } else if let url = url {
                self.fetchFile(from:url)
            }
        }
        
    }
    
    @objc func modul4Tap() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("Управление долгами.rtf")
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка получения URL файла: \(error.localizedDescription)")
            } else if let url = url {
                self.fetchFile(from:url)
            }
        }
        
    }
    
    @objc func downloadFile() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("Пенсионное планирование и страхование.rtf")
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка получения URL файла: \(error.localizedDescription)")
            } else if let url = url {
                self.fetchFile(from:url)
            }
        }
    }
    
    @objc func topBookTapp() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child("ТОП Книг о финансах и саморазвитии.rtf")
        
        fileRef.downloadURL { url, error in
            if let error = error {
                print("Ошибка получения URL файла: \(error.localizedDescription)")
            } else if let url = url {
                self.fetchFile(from:url)
            }
        }
    }
    
    func fetchFile(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка загрузки файла: \(error.localizedDescription)")
            } else if let data = data {
                do {
                    
                    let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                   DispatchQueue.main.async {
                        self.showFileContent(content: attributedString.string)
                   }
                } catch {
                    print("Ошибка обработки файла: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    func showFileContent(content: String) {
        let fileContentVC = FileContentViewController()
        fileContentVC.fileContent = content
        navigationController?.pushViewController(fileContentVC, animated: true)
    }
   }

extension PoleznoeViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Выбор файла отменен.")
    }
}
