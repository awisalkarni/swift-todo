//
//  ViewController.swift
//  MyTodoList
//
//  Created by Awis Alkarni on 25/06/2020.
//  Copyright © 2020 Awislabs. All rights reserved.
//

import RealmSwift
import UIKit


class TodoListItem: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var date: Date = Date()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var table: UITableView!
    
    private var data = [TodoListItem]()
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        data = realm.objects(TodoListItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    //Mark: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row].item
        
        return cell
        
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        //open screen where we can see the item and delete
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else {
            return
        }
        
        vc.item = item
        vc.deletionHandler = { [weak self] in
            self?.refresh()
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.item
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapAddButton(){
        
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        
        vc.completionHandler = {[weak self] in
            self?.refresh()
        }
        
        vc.title = "New Item"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func refresh(){
        data = realm.objects(TodoListItem.self).map({ $0 })
        table.reloadData()
    }


}

