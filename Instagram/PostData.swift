//
//  PostData.swift
//  Instagram
//
//  Created by higanot on 2017/04/04.
//  Copyright © 2017年 GitHubhiganot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
  var id: String?
  var image: UIImage?
  var imageString: String?
  var name: String?
  var caption: String?
  var date: NSDate?
  var likes: [String] = []
  var isLiked: Bool = false
  var comment: [String] = []
  var commenter: [String] = []
  
  init(snapshot: FIRDataSnapshot, myId: String) {
    self.id = snapshot.key
    
    let valueDictionary = snapshot.value as! [String: AnyObject]
    
    imageString = valueDictionary["image"] as? String
    image = UIImage(data: NSData(base64Encoded: imageString!, options: .ignoreUnknownCharacters)! as Data)
    
    self.name = valueDictionary["name"] as? String
    
    self.caption = valueDictionary["caption"] as? String
    
    if let comment = valueDictionary["comment"] as? [String] {
      self.comment = comment
    }
    
    if let commenter = valueDictionary["commenter"] as? [String] {
      self.commenter = commenter
    }
    
    func addComment(name: String, msg: String) {
      self.comment.append("\(name) : \(msg)")
      
    }
    
    let time = valueDictionary["time"] as? String
    self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
    
    if let likes = valueDictionary["likes"] as? [String] {
      self.likes = likes
    }
    
    for likeId in self.likes {
      if likeId == myId {
        self.isLiked = true
        break
      }
    }
  }
}
