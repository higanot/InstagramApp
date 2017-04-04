//
//  LoginViewController.swift
//  Instagram
//
//  Created by higanot on 2017/04/03.
//  Copyright © 2017年 GitHubhiganot. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
  
  @IBOutlet weak var mailAddressTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var displayNameTextField: UITextField!
  
  // ログインボタンをタップしたときに呼ばれるメソッド
  @IBAction func handleLoginButton(_ sender: Any) {
    
    
    
  }
  
  // アカウント作成ボタンをタップしたとに呼ばれるメソッド
  @IBAction func handleCreateAcountButton(_ sender: Any) {
    
    if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
      
      // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
      if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
        print("DEBUG_PRINT: 何かが空文字です。")
        return
      }
      
      // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログインする。
      FIRAuth.auth()?.createUser(withEmail: address, password: password) { user, error in
        if let error = error {
          
          // エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
          print("DEBUG_PRINT:" + error.localizedDescription)
          return
        }
        
        print("DEBUG_PRINT: ユーザー作成に成功しました。")
        
        // 表示名を設定する
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
          let changeRequest = user.profileChangeRequest()
          changeRequest.displayName = displayName
          changeRequest.commitChanges { error in
            if let error = error {
              print("DEBUG_PRINT:" + error.localizedDescription)
            }
            print("DEBUG_PRINT: + [displayName = \(user.displayName)]の設定に成功しました。")
            
            // 画面を閉じてViewControllerに戻る
            self.dismiss(animated: true, completion: nil)
          }
          
        } else {
          print("DEBUG_PRINT: displayNameの設定に失敗しました。")
        }
        
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
}
