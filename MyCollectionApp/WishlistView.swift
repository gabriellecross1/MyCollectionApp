//
//  WishlistView.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 01/03/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation
import UIKit

class WishlistView: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var games: [BoardGame] = []
    var db:OpaquePointer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
        
        db = Database.openDatabase()!
        games = Database.getWishList(connection: db)
        WishList.dataSource = self
        WishList.delegate = self
        WishList.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        WishList.reloadData()
        
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
    
    @IBOutlet weak var WishList: UITableView!
    
}
