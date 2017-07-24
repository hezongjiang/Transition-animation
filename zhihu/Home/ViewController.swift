//
//  ViewController.swift
//  zhihu
//
//  Created by he on 2017/7/21.
//  Copyright © 2017年 hezongjiang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import YYModel

class ViewController: UITableViewController {

    fileprivate lazy var dataSource = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.loadData { (data) in
            guard let data = data else { return }
            self.dataSource = data
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! DetailViewController
        navigationController?.delegate = vc
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        vc.model = dataSource[indexPath.row]
        
    }
}
