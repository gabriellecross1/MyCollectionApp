//
//  XMLToBoardGame.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 12/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation


class XMLToBoardGame: NSObject,XMLParserDelegate
{
    var game = BoardGame()
    var mainParser = XMLParser()
    var foundCharacters = ""
    
    func GetGame(targetURL:URL)->BoardGame
    {
        self.mainParser = XMLParser(contentsOf: targetURL)!
        self.mainParser.delegate = self
        let success:Bool = self.mainParser.parse()
        if success {
            print("success")
        } else {
            print("parse failure!")
        }
        let result = game
        game = BoardGame()
        return result
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "yearpublished" {
            for string in attributeDict {
                let strvalue = string.value as NSString
                switch string.key {
                case "value":
                    game.yearPublished = strvalue as String
                default:
                    break
                }
            }
        }
        if elementName == "minplayers" {
            for string in attributeDict {
                let strvalue = string.value as NSString
                switch string.key {
                case "value":
                    game.minPlayers = strvalue as String
                default:
                    break
                }
            }
        }
        if elementName == "maxplayers" {
            for string in attributeDict {
                let strvalue = string.value as NSString
                switch string.key {
                case "value":
                    game.maxPlayers = strvalue as String
                default:
                    break
                }
            }
        }
        if elementName == "playingtime" {
            for string in attributeDict {
                let strvalue = string.value as NSString
                switch string.key {
                case "value":
                    game.playingTime = strvalue as String
                default:
                    break
                }
            }
        }
        if elementName == "minage" {
            for string in attributeDict {
                let strvalue = string.value as NSString
                switch string.key {
                case "value":
                    game.minage = strvalue as String
                default:
                    break
                }
            }
        }
        if elementName == "name" && game.name == ""{
            for string in attributeDict {
                let strvalue = string.value as NSString
                if string.key == "value" {
                    game.name = strvalue as String
                }
            }
        }
        if elementName == "link" {
            var type = ""
            var value = ""
            for string in attributeDict {
                let strvalue = string.value as NSString
                if string.key == "type" {
                    type = strvalue as String
                }
                if string.key == "value" {
                    value = strvalue as String
                }
            }
            if type == "boardgamepublisher" {
                game.publisher.append(value)
            }
            if type == "boardgamedesigner" {
                game.designer = value
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "thumbnail" {
            game.thumbnail = foundCharacters
        }
        if elementName == "image" {
            game.image = foundCharacters
        }
        if elementName == "description"{
            game.gameDescription = foundCharacters
        }
        if elementName == "designer"{
            game.designer = foundCharacters
        }
        self.foundCharacters = ""
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string;
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
    
}
