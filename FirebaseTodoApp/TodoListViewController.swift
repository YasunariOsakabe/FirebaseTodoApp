//
//  TodoListViewController.swift
//  FirebaseTodoApp
//
//  Created by 小坂部泰成 on 2023/02/23.
//

import UIKit
import Firebase


class TodoListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //①ログイン状態かどうかを確認(ログイン済みであればcurrentUserにログインしているユーザー情報が入ります。(未ログインの場合はnil)
        if let user = Auth.auth().currentUser {
            //②ログインしているユーザー名の取得
            //(Firestoreからある特定のデータを取得する場合は、collection("取得したいコレクション名").document("取得するID").getDocumentで取得)
            Firestore.firestore().collection("users").document(user.uid).getDocument(completion: {(snapshot,error) in
                if let snap = snapshot {
                    if let data = snap.data() {
                        self.userNameLabel.text = data["name"] as? String
                    }
                } else if let error = error {
                    //②エラーの場合の処理(ログイン状態でなかった場合)
                    print("ユーザー名取得失敗: " + error.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        
    }
    
    @IBAction func tapLogoutButton(_ sender: Any) {
        // ①ログイン済みかどうかを確認
        if Auth.auth().currentUser != nil {
            // ②ログアウトの処理
            do {
                try Auth.auth().signOut()
                print("ログアウト完了")
                // ③成功した場合はログイン画面へ遷移
                let storyboard: UIStoryboard = self.storyboard!
                let next = storyboard.instantiateViewController(withIdentifier: "ViewController")
                next.modalPresentationStyle = .fullScreen
                self.present(next, animated: true, completion: nil)
            } catch let error as NSError {
                print("ログアウト失敗: " + error.localizedDescription)
                // ②が失敗した場合
                let dialog = UIAlertController(title: "ログアウト失敗", message: error.localizedDescription, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default))
                dialog.modalPresentationStyle = .fullScreen
                self.present(dialog, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func changeDoneControl(_ sender: UISegmentedControl) {
        
    }
    
}
