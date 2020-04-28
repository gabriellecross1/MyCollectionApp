//
//  BoardGame.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 12/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//
import Foundation

struct BoardGame{
    var id : String = ""
    var name : String = ""
    var yearPublished : String = ""
    var playingTime : String = ""
    var minage : String = ""
    var minPlayers: String = ""
    var maxPlayers: String = ""
    var thumbnail: String = ""
    var image: String = ""
    var gameDescription: String = ""
    var publisher: [String] = []
    var designer: String  = ""
    var wishList: Bool = false
    var collection: Bool = false
    var levenshteinDistanceScore: Double = 0.0
}
