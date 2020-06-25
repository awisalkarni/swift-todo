//
//  DetailViewController.swift
//  MyTodoList
//
//  Created by Awis Alkarni on 25/06/2020.
//  Copyright © 2020 Awislabs. All rights reserved.
//

import RealmSwift
import UIKit

class DetailViewController: UIViewController {
    
    public var item: TodoListItem?
    
    public var deletionHandler: (() -> Void)?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    let realm = try! Realm()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemLabel.text = item?.item
        dateLabel.text = Self.dateFormatter.string(from: item!.date)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))

        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapDelete(){
        guard let item = self.item else {
            return
        }
        
        realm.beginWrite()
        
        realm.delete(item)
        
        try! realm.commitWrite()
        
        deletionHandler?()
        
        navigationController?.popToRootViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
