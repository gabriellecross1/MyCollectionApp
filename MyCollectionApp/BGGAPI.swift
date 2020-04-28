//
//  BGGAPI.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 12/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation

class BGGAPI: NSObject
{
    var XMLGame = XMLToBoardGame()
    var XMLId = XMLToGameids()
    var baseUrl = "https://www.boardgamegeek.com/xmlapi2/"
    
    func GetGameIds(gameName : String)->[String]
    {
        var x = XMLId.GetGameIds(targetURL: CreateURLSearchName(gameName: ValidateStringForURL(inputString: gameName)))
        return x
    }
    
    func GetGame(gameId:String) -> BoardGame {
        var game = XMLGame.GetGame(targetURL: CreateURLSearchId(gameId: gameId))
        game.id = gameId
        return game
    }
    
    private func ValidateStringForURL(inputString:String)->String
    {
        let returnString  = inputString.replacingOccurrences(of: " ", with: "+")
        return returnString.lowercased()
    }
    
    private func CreateURLSearchId(gameId:String) -> URL
    {
        return URL(string: baseUrl + "thing?id=" + gameId)!
    }
    
    private func CreateURLSearchName(gameName:String) -> URL
    {
        return URL(string: baseUrl + "search?query=" + gameName + "&type=boardgame")!
    }
}
