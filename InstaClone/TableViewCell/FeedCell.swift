//
//  FeedCell.swift
//  InstaClone
//
//  Created by Apple on 28.07.2020.
//  Copyright © 2020 erdogan. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var documentIDLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["likes": likeCount + 1] as [String: Any]
            // merge ile sadece istenilen yerin güncellenmesi sağlanır
            firestoreDatabase.collection("Posts").document(documentIDLable.text!).setData(likeStore, merge: true)
        }
        
    }
    
}
