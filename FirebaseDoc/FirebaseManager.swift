import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(collection: String, docName: String, completion: @escaping(Document?) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument(completion: {(document, error) in
            guard error == nil else { completion(nil); return }
            let doc = Document(field1: document?.get("field1") as! String)
            completion(doc)
        })
    }
}

