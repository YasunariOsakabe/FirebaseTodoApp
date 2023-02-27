//
//  TodoAddViewController.swift
//  FirebaseTodoApp
//
//  Created by 小坂部泰成 on 2023/02/23.
//

import UIKit

class TodoAddViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        // TextViewのレイアウトをTextField似合わせるためのコード
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    
    @IBAction func tapAddButton(_ sender: Any) {

    }
}
