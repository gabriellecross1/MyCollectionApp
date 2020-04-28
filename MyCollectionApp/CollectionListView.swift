//
//  CollectionListView.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 12/03/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation
import UIKit

class CollectionListView: UIViewController,UITableViewDataSource, UITableViewDelegate{

    var games: [BoardGame] = []
    var db:OpaquePointer!
    
    @IBOutlet weak var CollectionList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db = Database.openDatabase()!
        games = Database.getCollectionList(connection: db)
        CollectionList.dataSource = self
        CollectionList.delegate = self
        CollectionList.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        CollectionList.reloadData()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath)
        cell.textLabel?.text = games[indexPath.item].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let MainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let targetView = (MainStoryBoard.instantiateViewController(identifier: "DetailsVM")as? DetailsVM)!
        targetView.game = games[indexPath.item]
        navigationController?.pushViewController(targetView,animated: true)
        
    }
    
}
