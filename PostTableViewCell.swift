//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by 日向野卓也 on 2017/04/06.
//  Copyright © 2017年 GitHubhiganot. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var postImageView: UIImageView!
  
  @IBOutlet weak var likeButton: UIButton!
  
  @IBOutlet weak var commentButton: UIButton!
  
  @IBOutlet weak var likeLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var captionLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setPostData(postData: PostData) {
    self.postImageView.image = postData.image
    
    var captionAndComment = "\(postData.name!) : \(postData.caption!)\n"
    
    for index in 0..<postData.comment.count {
      
      let comment = postData.comment[index]
      let commenter = postData.commenter[index]
      captionAndComment += "\(commenter) : \(comment)\n"
  
    }
    
    self.captionLabel.text = captionAndComment
    
    let likeNumber = postData.likes.count
    likeLabel.text = "\(likeNumber)"
    
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    let dateString:String = formatter.string(from: postData.date! as Date)
    self.dateLabel.text = dateString
    
    if postData.isLiked {
      let buttonImage = UIImage(named: "like_exist")
      self.likeButton.setImage(buttonImage, for: UIControlState.normal)
    } else {
      let buttonImage = UIImage(named: "like_none")
      self.likeButton.setImage(buttonImage, for: UIControlState.normal)
    }
  }
}
