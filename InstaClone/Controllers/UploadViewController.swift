//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Apple on 27.07.2020.
//  Copyright © 2020 erdogan. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true //tıklanabilir yapma
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func chooseImage(){
        let pickerController = UIImagePickerController() //görsel seçmek için galeriye erişme
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    //kullanıcı seçince ne olacak ?
    //info.plist => Privacy - Photo Library Usage Description
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let btnOk = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(btnOk)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage() //instance üretilir
        let storageReference = storage.reference() //yükleme işlemi için referans alınır
        let mediaFolder = storageReference.child("media") //storage daki medya klasörüne erişiyoruz
        //önceden oluşturmasaydık media adında klasör oluştururdu
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            //fotoğrafı kaydetmek için 0.5 oranda sıkıştırarak veriye çevrilir
            let imageReference = mediaFolder.child(UUID().uuidString + ".jpg") //fotoğraf için referans
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { (url, error) in //kaydedilen fotoğrafın url si alınır
                        if error == nil{
                            let imageUrl = url?.absoluteString //url stringe çevrilir
                            
                            //DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference: DocumentReference? = nil
                            let firestorePost = ["imageUrl": imageUrl!,
                                                 "postedBy": Auth.auth().currentUser!.email!,
                                                 "postComment": self.commentText.text!,
                                                 "date": FieldValue.serverTimestamp(),
                                                 "likes": 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
                                } else {
                                    self.imageView.image = UIImage(systemName: "cloud.fill")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0 //tabbardan feed e götürecek
                                }
                            })
                            
                            
                        }
                    }
                }
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
