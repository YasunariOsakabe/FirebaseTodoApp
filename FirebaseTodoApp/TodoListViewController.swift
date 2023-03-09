//
//  TodoListViewController.swift
//  FirebaseTodoApp
//
//  Created by 小坂部泰成 on 2023/02/23.
//

import UIKit
import Firebase


class TodoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    // Firestoreから取得するTodoのid,title,detail,isDoneを入れる配列を用意
    var todoIdArray: [String] = []
    var todoTitleArray: [String] = []
    var todoDetailArray: [String] = []
    var todoIsDoneArray: [Bool] = []
    // 画面下部の未完了、完了済みを判定するフラグ(falseは未完了)
    var isDone: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
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
            })  //ここまでユーザー名を取得する処理
            
            //ここからFirestoreからTodoデータを取得
            //1.検索 - FirestoreではwhereField()を使用する事でコレクション内で検索をすることができます。
            
            //2.並び替え - Firestoreではorder(by: "並び替えするフィールド名")で並び替えをすることができます。
            //  今回は、Todoデータの作成時刻の昇順で並び替えをしたかったので、order(by: "createdAt")となる。
            //  降順の場合はorder(by: "createdAt",descending: true)となる。
            
            //3.複合クエリ - 検索、並び替えの二つ以上を併用する場合はその項目でindexを作成する必要があります。(users/userID/todos内でisDone(完了か未完了)で検索,createdAt(日付順)で並び替え)
            //             indexの作成は、FirebaseのConsole画面から行います。
        
            //4.getDocumentsとaddSnapshotListener -
            //  Firestoreからデータを取得する方法として、getDocument()
            //  複数のデータを取得する場合は、getDocuments()とaddSnapshotListener() → getDocumentの複数番
            
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone).order(by: "createdAt").addSnapshotListener({ (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    // ③Firestoreから取得したデータを入れる配列を用意してfor文で追加する
                    var idArray:[String] = []
                    var titleArray:[String] = []
                    var detailArray:[String] = []
                    var isDoneArray:[Bool] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        isDoneArray.append(data["isDone"] as! Bool)
                    }
                    // ④classで用意した変数に代入してtableViewをリロード
                    self.todoIdArray = idArray
                    self.todoTitleArray = titleArray
                    self.todoDetailArray = detailArray
                    self.todoIsDoneArray = isDoneArray
                    self.tableView.reloadData()
                    
                } else if let error = error {
                    print("TODO取得失敗: " + error.localizedDescription)
                }
            })
        }
    }
    
    
    
    //＋ボタンタップ時の処理(TodoAddViewControllerに遷移)
    @IBAction func tapAddButton(_ sender: Any) {
        // ①Todo作成画面に画面遷移
        let storyboard: UIStoryboard = self.storyboard!
        let next = storyboard.instantiateViewController(withIdentifier: "TodoAddViewController")
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
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
        switch sender.selectedSegmentIndex {
        case 0:
            // 未完了、完了を切り替える
            isDone = false
            // firestoreからデータを取得
            getTodoDataForFirestore()
        case 1:
            isDone = true
            getTodoDataForFirestore()
        // ないとエラーになるので定義している
        default:
            isDone = false
            getTodoDataForFirestore()
        }
    }

    // FirestoreからTodoを取得する処理
    func getTodoDataForFirestore() {
        if let user = Auth.auth().currentUser {
            Firestore.firestore().collection("users/\(user.uid)/todos").whereField("isDone", isEqualTo: isDone).order(by: "createdAt").getDocuments(completion: { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var idArray:[String] = []
                    var titleArray:[String] = []
                    var detailArray:[String] = []
                    var isDoneArray:[Bool] = []
                    for doc in querySnapshot.documents {
                        let data = doc.data()
                        idArray.append(doc.documentID)
                        titleArray.append(data["title"] as! String)
                        detailArray.append(data["detail"] as! String)
                        isDoneArray.append(data["isDone"] as! Bool)
                    }
                    self.todoIdArray = idArray
                    self.todoTitleArray = titleArray
                    self.todoDetailArray = detailArray
                    self.todoIsDoneArray = isDoneArray
                    print(self.todoTitleArray)
                    self.tableView.reloadData()
                    
                } else if let error = error {
                    print("TODO取得失敗: " + error.localizedDescription)
                }
            })
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todoTitleArray[indexPath.row]
        return cell
    }
    
}
