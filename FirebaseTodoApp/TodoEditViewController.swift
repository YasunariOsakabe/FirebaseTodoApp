//
//  TodoEditViewController.swift
//  FirebaseTodoApp
//
//  Created by 小坂部泰成 on 2023/02/23.
//

import UIKit
import Firebase

class TodoEditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var isDoneLabel: UILabel!
    
    //TodoListViewControllerから受け取る変数の箱を準備
    var todoId: String!
    var todoTitle: String!
    var todoDetail: String!
    var todoIsDone: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期値をセット
        titleTextField.text = todoTitle
        detailTextView.text = todoDetail
        
        switch todoIsDone {
        case false:
            isDoneLabel.text = "未完了"
            doneButton.setTitle("完了済みにする", for: .normal)
        default:
            isDoneLabel.text = "完了"
            doneButton.setTitle("未完了にする", for: .normal)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    
    //編集ボタン実装
    @IBAction func tapEditButton(_ sender: Any) {
        if let title = titleTextField.text,
           let detail = detailTextView.text {
            if let user = Auth.auth().currentUser {
                Firestore.firestore().collection("users/\(user.uid)/todos").document(todoId).updateData(
                    [
                        "title": title,
                        "detail": detail,
                        "updatedAt": FieldValue.serverTimestamp()
                    ]
                    ,completion: { error in
                        if let error = error {
                            print("TODO更新失敗: " + error.localizedDescription)
                            let dialog = UIAlertController(title: "TODO更新失敗", message: error.localizedDescription, preferredStyle: .alert)
                            dialog.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(dialog, animated: true, completion: nil)
                        } else {
                            print("TODO更新成功")
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
            }
            
        }
        
    }
    @IBAction func tapDoneButton(_ sender: Any) {
        
    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {
        
    }
}

