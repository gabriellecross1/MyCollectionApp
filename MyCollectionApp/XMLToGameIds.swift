//
//  XMLToGameIds.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 12/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation
class XMLToGameids: NSObject,XMLParserDelegate
{
    var parser = XMLParser()
    var allGameIds:[String] = []
    
    func GetGameIds(targetURL:URL)->[String]
    {
        self.parser = XMLParser(contentsOf: targetURL)!
        self.parser.delegate = self
        let success:Bool = self.parser.parse()
        if success {
            print("success")
        } else {
            print("parse failure!")
        }
        return allGameIds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "item" {
            for string in attributeDict {
                let strvalue = string.value as NSString
                switch string.key {
                case "id":
                    allGameIds.append(strvalue as String)
                default:
                    break
                }
            }
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}
