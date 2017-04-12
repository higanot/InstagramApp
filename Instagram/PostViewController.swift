//
//  PostViewController.swift
//  Instagram
//
//  Created by higanot on 2017/04/03.
//  Copyright © 2017年 GitHubhiganot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PostViewController: UIViewController {
  var image: UIImage!
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var textField: UITextField!
  
  // 投稿ボタンをタップしたときに呼ばれるメソッド
  @IBAction func handlePostButton(_ sender: UIButton) {
    
    // imageViewから画像を取得する
    let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)
    let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
    
    // postDataに必要な情報を取得しておく
    let time = NSDate.timeIntervalSinceReferenceDate
    let name = FIRAuth.auth()?.currentUser?.displayName
    
    // 辞書を作成してFirebaseに保存する
    let postRef = FIRDatabase.database().reference().child(Const.PostPath)
    let postData = ["caption": textField.text!, "image": imageString, "time": String(time), "name": name!]
    
    postRef.childByAutoId().setValue(postData)
    
    // HUDで投稿完了を表示する
    SVProgressHUD.showSuccess(withStatus: "投稿が完了しました。")
    
    // 全てのモーダルを閉じる
    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    
  }
  
  // キャンセルボタンをタップしたときに呼ばれるメソッド
  @IBAction func handleCancelButton(_ sender: Any) {
    
    // 画面を閉じる
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 受け取った画像をImageView上に表示する
    imageView.image = image
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}
