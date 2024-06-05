import UIKit

class FileContentViewController: UIViewController {
  
    var fileContent: String?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = .white
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        if let content = fileContent {
            textView.text = content
        }
    }
}
