//
//  TodoEditViewController.swift
//  FirebaseTodoApp
//
//  Created by 小坂部泰成 on 2023/02/23.
//

import UIKit

class TodoEditViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var isDoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   override func viewDidLayoutSubviews() {
        detailTextView.layer.borderWidth = 1.0
        detailTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        detailTextView.layer.cornerRadius = 5.0
        detailTextView.layer.masksToBounds = true
    }
    
    @IBAction func tapEditButton(_ sender: Any) {

    }
    @IBAction func tapDoneButton(_ sender: Any) {

    }
    
    @IBAction func tapDeleteButton(_ sender: Any) {

    }
}

