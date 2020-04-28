//
//  DetailsVM.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 17/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation
import UIKit

class DetailsVM: UIViewController{
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var yearPublisherTxt: UITextField!
    @IBOutlet weak var playerCountTxt: UITextField!
    @IBOutlet weak var minAgeTxt: UITextField!
    @IBOutlet weak var designerTxt: UITextField!
    @IBOutlet weak var publisherTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var addToWishListBtn: UIButton!
    @IBOutlet weak var addToCollectionBtn: UIButton!
    @IBOutlet weak var displayImage: UIImageView!
    
    @IBOutlet weak var WishListButton: UIButton!
    @IBOutlet weak var CollectionButton: UIButton!
    
    @IBAction func ManageCollection(_ sender: Any) {
        db = Database.openDatabase()!
        
        if(game.collection)
        {
            game.collection = false
            if !game.wishList
            {
                Database.deleteBoardGame(connection: db, boardGame: game)
            }
            else
            {
                Database.insertBoardGame(connection: db, boardGame: game)
            }
        }
        else
        {
            game.collection = true
            Database.insertBoardGame(connection: db, boardGame: game)
            
        }
        UpdateLabels()
        
    }
    
    @IBAction func ManageWishList(_ sender: UIButton) {
        
        db = Database.openDatabase()!
        
        if(game.wishList)
        {
            game.wishList = false
            if !game.collection
            {
                Database.deleteBoardGame(connection: db, boardGame: game)
            }
            else
            {
                Database.insertBoardGame(connection: db, boardGame: game)
            }
        }
        else
        {
            game.wishList = true
            Database.insertBoardGame(connection: db, boardGame: game)
            
        }
        UpdateLabels()
    }
    
    var db:OpaquePointer!
    let AddCollection: String = "Add To Collection"
    let RemoveCollection: String = "Remove From Collection"
    let AddWishList: String = "Add To WishList"
    let RemoveWishList: String = "Remove From WishList"
    
    var game : BoardGame!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTxt.text = game.name
        yearPublisherTxt.text = game.yearPublished
        playerCountTxt.text = game.minPlayers + " To " + game.maxPlayers
        minAgeTxt.text = game.minage
        publisherTxt.text = game.publisher[0]
        designerTxt.text = game.designer
        descriptionTxt.text = String(game.gameDescription.dropFirst(72))
        setImage(from:String(game.image.dropFirst(7)))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UpdateLabels()
    }
    func UpdateLabels() {
        
        if game.collection == true {
            CollectionButton.setTitle(RemoveCollection, for: .normal)
        }
        else{
            CollectionButton.setTitle(AddCollection, for: .normal)
        }
        
        if game.wishList == true
        {
            WishListButton.setTitle(RemoveWishList, for: .normal)
        }
        else{
            WishListButton.setTitle(AddWishList, for: .normal)
        }
    }
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.displayImage.image = image
            }
        }
    }
}
