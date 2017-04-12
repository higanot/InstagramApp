//
//  HomeViewController.swift
//  Instagram
//
//  Created by higanot on 2017/04/03.
//  Copyright © 2017年 GitHubhiganot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var postArray: [PostData] = []
  
  // FIRDatabaseのobserveEventの登録状態を表す
  var observing = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    // テーブルセルのタップを無効にする
    tableView.allowsSelection = false
    
    let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "Cell")
    tableView.rowHeight = UITableViewAutomaticDimension

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("DEBUG_PRINT: viewWillAppear")
    
    if FIRAuth.auth()?.currentUser != nil {
      if self.observing == false {
        
        // 要素が追加されたらpostArrayに追加してTableViewを再表示する
      let postsRef = FIRDatabase.database().reference().child(Const.PostPath)
      
        postsRef.observe(.childAdded, with: { snapshot in
          print("DEBUG_PRINT: .childAddedイベントが発生しました。")
          
          // postDataクラスを生成して受け取ったデータを設定する
          if let uid = FIRAuth.auth()?.currentUser?.uid {
            let postData = PostData(snapshot: snapshot, myId: uid)
            self.postArray.insert(postData, at: 0)
            
            // TableViewを再表示する
            self.tableView.reloadData()
          }
          
        })
        
        // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加して
        // TableViewを再表示する
        postsRef.observe(.childChanged, with: { snapshot in
          print("DEBUG_PRINT: .childChangedイベントが発生しました。")
          
          if let uid = FIRAuth.auth()?.currentUser?.uid {
            
            // PostDataクラスを生成して受け取ったデータを設定する
            let postData = PostData(snapshot: snapshot, myId: uid)
            
            // 保持している配列からidが同じものを探す
            var index:Int = 0
            for post in self.postArray {
              if post.id == postData.id {
                index = self.postArray.index(of: post)!
                break
              }
            }
            
            // 差し替えるため一度削除する
            self.postArray.remove(at: index)
            
            // 削除したところに更新済みのデータを追加する
            self.postArray.insert(postData, at:index)
            
            // TableViewの現在表示されているセルを更新する
            self.tableView.reloadData()
          }
        
        })
        
        // FIRDatabaseのobserveEventが上記コードより登録されたため、trueとする
        observing = true
    }
    } else {
      if observing == true {
        // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
        // テーブルをクリアする
        postArray = []
        tableView.reloadData()
        // オブザーバーを削除する
        FIRDatabase.database().reference().removeAllObservers()
        
        // FIRDatabaseのobserveEventが上記コードにより解除されたため
        // falseとする
        observing = false
      }
    }
      
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // セルを取得してデータを設定する
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as! PostTableViewCell
    cell.setPostData(postData: postArray[indexPath.row])
    
    // セル内のボタンのアクションをソースコードで設定する
    cell.likeButton.addTarget(self, action:#selector(handleButton(sender:event:)), for:  UIControlEvents.touchUpInside)
    
    cell.commentButton.addTarget(self, action:#selector(commentButton(sender:event:)), for: UIControlEvents.touchUpInside)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    // Auto Layoutを使ってセルの高さを動的に変更する
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // セルをタップされたら何もせずに選択状態を解除する
    tableView.deselectRow(at: indexPath as IndexPath, animated: true)
  }
  
  // セル内のcommentボタンがタップされた時に呼ばれるメソッド
  func commentButton(sender: UIButton, event:UIEvent) {
    print("DEBUG_PRINT: commentボタンがタップされました。")
    let touch = event.allTouches?.first
    let point = touch!.location(in: self.tableView)
    let indexPath = tableView.indexPathForRow(at: point)
    let postData = postArray[indexPath!.row]
    
    
    // コメントボタンをセルに追加する
    // コメントボタンが押された時にコメントを追加するためのビューを開く
    //   - UIAlertController を使う。
    //     - textfield を設定する
    //     - action item で OK のとき、コメントを追加する処理
    // コメントを追加するためのビューを開く。
    
    // UIAlertControllerクラスのインスタンスを生成
    // タイトル、メッセージ、Alertのスタイルを指定する
    // 第三引数のpreferredStyleでアラートの表示スタイルを指定する
    let comment: UIAlertController = UIAlertController(title: "コメント", message: "コメントを入力して下さい", preferredStyle:  UIAlertControllerStyle.alert)
    
    // Actionの設定
    // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
    // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
    // OKボタン
    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
      // ボタンが押された時の処理を書く（クロージャ実装）
      (action: UIAlertAction!) -> Void in
      
      // 入力したテキストをコンソールに表示する
      let textField = comment.textFields![0] as UITextField
      let commentText = textField.text
      print("OK")
      
      // 増えたcommentをFirebaseに保存する
      // firebaseへコメントを投稿する
      let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!)
      postData.comment.append(commentText!)
      postData.commenter.append(FIRAuth.auth()?.currentUser?.displayName ?? "")

      let commentData = ["comment": postData.comment, "commenter": postData.commenter]
      postRef.updateChildValues(commentData)

    })
    // キャンセルボタン
    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
      // ボタンが押された時の処理を書く（クロージャ実装）
      (action: UIAlertAction!) -> Void in
      print("Cancel")
    })
    
    // UIAlertControllerにActionを追加
    comment.addAction(cancelAction)
    comment.addAction(defaultAction)
    
    // textFieldを追加する
    comment.addTextField(configurationHandler: {(text:UITextField!) -> Void in
    })
    
    // Alertを表示
    present(comment, animated: true, completion: nil)
    
  }
  
  // セル内のlikeボタンがタップされた時に呼ばれるメソッド
  func handleButton(sender: UIButton, event:UIEvent) {
    print("DEBUG_PRINT: likeボタンがタップされました。")
    
    // タップされたセルのインデックスを求める
    let touch = event.allTouches?.first
    let point = touch!.location(in: self.tableView)
    let indexPath = tableView.indexPathForRow(at: point)
    
    // 配列からタップされたインデックスのデータを取り出す
    let postData = postArray[indexPath!.row]
    
    // Firebaseに保存するデータの準備
    if let uid = FIRAuth.auth()?.currentUser?.uid {
      if postData.isLiked {
        // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
        var index = -1
        for likeId in postData.likes {
          if likeId == uid {
            // 削除するためにインデックスを保持しておく
            index = postData.likes.index(of: likeId)!
            break
          }
        }
        postData.likes.remove(at: index)
      } else {
        postData.likes.append(uid)
      }
      
      // 増えたlikesをFirebaseに保存する
      let postRef = FIRDatabase.database().reference().child(Const.PostPath).child(postData.id!)
      let likes = ["likes": postData.likes]
      postRef.updateChildValues(likes)
      
    }
  }
}

