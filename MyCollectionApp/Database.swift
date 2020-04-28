//
//  Database.swift
//  MyCollectionApp
//
//  Created by Gabrielle Cross on 18/02/2020.
//  Copyright © 2020 Gabrielle Cross. All rights reserved.
//

import Foundation
import SQLite3

struct Database {
    static func openDatabase() -> OpaquePointer? {
        let dbURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("AMC4.sqlite")
        
        var db: OpaquePointer? = nil
        if sqlite3_open(dbURL.path, &db) == SQLITE_OK {
            return db
        } else {
            print("Unable to open database.")
        }
        
        return db
    }
    
    static func initializeDataModel(connection: OpaquePointer) {
        let createBoardGameTableQuery =
        """
        CREATE TABLE IF NOT EXISTS BoardGameTable (
            ID INTEGER PRIMARY KEY,
            Name TEXT,
            YearPublished TEXT,
            PlayingTime TEXT,
            MinAge TEXT,
            MinPlayers TEXT,
            MaxPlayers TEXT,
            Thumbnail TEXT,
            Image TEXT,
            Description TEXT,
            Publisher TEXT,
            Designer TEXT,
            Wishlist INTEGER,
            Collection INTEGER
        );
        """
        
        var preparedQuery: OpaquePointer? = nil
        let result = sqlite3_prepare_v2(connection, createBoardGameTableQuery, -1, &preparedQuery, nil)
        if result == SQLITE_OK {
            sqlite3_step(preparedQuery)
        } else {
            print("CREATE TABLE SQL command could not be prepared.")
        }
        
        sqlite3_finalize(preparedQuery)
    }
    
    static func insertBoardGame(connection: OpaquePointer, boardGame: BoardGame) {
        let insertStatement =
        """
        INSERT INTO BoardGameTable (ID, Name, YearPublished, PlayingTime, MinAge, MinPlayers, MaxPlayers, Thumbnail, Image, Description, Publisher, Designer, Wishlist, Collection)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """
        
        var preparedInsertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, insertStatement, -1, &preparedInsertStatement, nil) == SQLITE_OK
        {
            let id = (boardGame.id as NSString).intValue as Int32
            let name = boardGame.name as NSString
            let yearPublisher = boardGame.yearPublished as NSString
            let playingTime = boardGame.playingTime as NSString
            let minAge = boardGame.minage as NSString
            let minPlayers = boardGame.minPlayers as NSString
            let maxPlayers = boardGame.maxPlayers as NSString
            let thumbnail = boardGame.thumbnail as NSString
            let image = boardGame.image as NSString
            let description = boardGame.gameDescription as NSString
            let publisher = boardGame.publisher[0] as NSString
            let designer = boardGame.designer as NSString
            let wishlist = boardGame.wishList == true ? 1 : 0
            let collection = boardGame.collection == true ? 1 : 0
            
            
            sqlite3_bind_int(preparedInsertStatement, 1,
                             Int32(id))
            sqlite3_bind_text(preparedInsertStatement, 2,
                              name.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 3,
                              yearPublisher.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 4,
                              playingTime.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 5,
                              minAge.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 6,
                              minPlayers.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 7,
                              maxPlayers.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 8,
                              thumbnail.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 9,
                              image.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 10,
                              description.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 11,
                              publisher.utf8String, -1, nil)
            sqlite3_bind_text(preparedInsertStatement, 12,
                              designer.utf8String, -1, nil)
            sqlite3_bind_int(preparedInsertStatement,  13,
                             Int32(wishlist))
            sqlite3_bind_int(preparedInsertStatement,  14,
                             Int32(collection))
            
            if sqlite3_step(preparedInsertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        
        sqlite3_finalize(preparedInsertStatement)
        
    }
    
    //MARK: Read
    static func getAllBoardGames(connection: OpaquePointer) -> [BoardGame] {
        var boardGames = [BoardGame]()
        
        let query = "SELECT * FROM BoardGameTable ORDER BY Name;"
        
        var preparedQuery: OpaquePointer? = nil
        if sqlite3_prepare_v2(connection, query, -1, &preparedQuery, nil) == SQLITE_OK {
            
            while (sqlite3_step(preparedQuery) == SQLITE_ROW) {
                
                let id = (sqlite3_column_int(preparedQuery, 0))
                
                let queryResultCol1 = sqlite3_column_text(preparedQuery, 1)
                let name = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(preparedQuery, 2)
                let yearPublished = String(cString: queryResultCol2!)
                
                let queryResultCol3 = sqlite3_column_text(preparedQuery, 3)
                let playingTime = String(cString: queryResultCol3!)
                
                let queryResultCol4 = sqlite3_column_text(preparedQuery, 4)
                let minAge = String(cString: queryResultCol4!)
                
                let queryResultCol5 = sqlite3_column_text(preparedQuery, 5)
                let minPlayers = String(cString: queryResultCol5!)
                
                let queryResultCol6 = sqlite3_column_text(preparedQuery, 6)
                let maxPlayers = String(cString: queryResultCol6!)
                
                let queryResultCol7 = sqlite3_column_text(preparedQuery, 7)
                let thumbnail = String(cString: queryResultCol7!)
                
                let queryResultCol8 = sqlite3_column_text(preparedQuery, 8)
                let image = String(cString: queryResultCol8!)
                
                let queryResultCol9 = sqlite3_column_text(preparedQuery, 9)
                let description = String(cString: queryResultCol9!)
                
                let queryResultCol10 = sqlite3_column_text(preparedQuery, 10)
                let publisher = String(cString: queryResultCol10!)
                
                let queryResultCol11 = sqlite3_column_text(preparedQuery, 11)
                let designer = String(cString: queryResultCol11!)
                
                let wishList = (sqlite3_column_int(preparedQuery, 12)) == 1 ? true : false
                let collection = (sqlite3_column_int(preparedQuery, 12)) == 1 ? true : false
                
                var publist:[String] = []
                publist.append(publisher)
                let boardGame = BoardGame(id: String(id), name: name, yearPublished: yearPublished, playingTime: playingTime, minage: minAge, minPlayers: minPlayers, maxPlayers: maxPlayers, thumbnail: thumbnail, image: image, gameDescription: description, publisher: publist, designer: designer, wishList: wishList, collection: collection)
                boardGames.append(boardGame)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(preparedQuery)
        
        return boardGames
    }
    static func getWishList(connection: OpaquePointer) -> [BoardGame] {
        var boardGames = [BoardGame]()
        
        let query = "SELECT * FROM BoardGameTable WHERE Wishlist = 1 ORDER BY Name;"
        
        var preparedQuery: OpaquePointer? = nil
        if sqlite3_prepare_v2(connection, query, -1, &preparedQuery, nil) == SQLITE_OK {
            
            while (sqlite3_step(preparedQuery) == SQLITE_ROW) {
                let id = (sqlite3_column_int(preparedQuery, 0))
                
                let queryResultCol1 = sqlite3_column_text(preparedQuery, 1)
                let name = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(preparedQuery, 2)
                let yearPublished = String(cString: queryResultCol2!)
                
                let queryResultCol3 = sqlite3_column_text(preparedQuery, 3)
                let playingTime = String(cString: queryResultCol3!)
                
                let queryResultCol4 = sqlite3_column_text(preparedQuery, 4)
                let minAge = String(cString: queryResultCol4!)
                
                let queryResultCol5 = sqlite3_column_text(preparedQuery, 5)
                let minPlayers = String(cString: queryResultCol5!)
                
                let queryResultCol6 = sqlite3_column_text(preparedQuery, 6)
                let maxPlayers = String(cString: queryResultCol6!)
                
                let queryResultCol7 = sqlite3_column_text(preparedQuery, 7)
                let thumbnail = String(cString: queryResultCol7!)
                
                let queryResultCol8 = sqlite3_column_text(preparedQuery, 8)
                let image = String(cString: queryResultCol8!)
                
                let queryResultCol9 = sqlite3_column_text(preparedQuery, 9)
                let description = String(cString: queryResultCol9!)
                
                let queryResultCol10 = sqlite3_column_text(preparedQuery, 10)
                let publisher = String(cString: queryResultCol10!)
                
                let queryResultCol11 = sqlite3_column_text(preparedQuery, 11)
                let designer = String(cString: queryResultCol11!)
                
                let wishList = (sqlite3_column_int(preparedQuery, 12)) == 1 ? true : false
                let collection = (sqlite3_column_int(preparedQuery, 12)) == 1 ? true : false
                
                var publist:[String] = []
                publist.append(publisher)
                let boardGame = BoardGame(id: String(id), name: name, yearPublished: yearPublished, playingTime: playingTime, minage: minAge, minPlayers: minPlayers, maxPlayers: maxPlayers, thumbnail: thumbnail, image: image, gameDescription: description, publisher: publist, designer: designer, wishList: wishList, collection: collection)
                boardGames.append(boardGame)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(preparedQuery)
        
        return boardGames
    }
    
    static func getCollectionList(connection: OpaquePointer) -> [BoardGame] {
        var boardGames = [BoardGame]()
        
        let query = "SELECT * FROM BoardGameTable WHERE Collection = 1 ORDER BY Name;"
        
        var preparedQuery: OpaquePointer? = nil
        if sqlite3_prepare_v2(connection, query, -1, &preparedQuery, nil) == SQLITE_OK {
            
            while (sqlite3_step(preparedQuery) == SQLITE_ROW) {
                
                let id = (sqlite3_column_int(preparedQuery, 0))
                
                let queryResultCol1 = sqlite3_column_text(preparedQuery, 1)
                let name = String(cString: queryResultCol1!)
                
                let queryResultCol2 = sqlite3_column_text(preparedQuery, 2)
                let yearPublished = String(cString: queryResultCol2!)
                
                let queryResultCol3 = sqlite3_column_text(preparedQuery, 3)
                let playingTime = String(cString: queryResultCol3!)
                
                let queryResultCol4 = sqlite3_column_text(preparedQuery, 4)
                let minAge = String(cString: queryResultCol4!)
                
                let queryResultCol5 = sqlite3_column_text(preparedQuery, 5)
                let minPlayers = String(cString: queryResultCol5!)
                
                let queryResultCol6 = sqlite3_column_text(preparedQuery, 6)
                let maxPlayers = String(cString: queryResultCol6!)
                
                let queryResultCol7 = sqlite3_column_text(preparedQuery, 7)
                let thumbnail = String(cString: queryResultCol7!)
                
                let queryResultCol8 = sqlite3_column_text(preparedQuery, 8)
                let image = String(cString: queryResultCol8!)
                
                let queryResultCol9 = sqlite3_column_text(preparedQuery, 9)
                let description = String(cString: queryResultCol9!)
                
                let queryResultCol10 = sqlite3_column_text(preparedQuery, 10)
                let publisher = String(cString: queryResultCol10!)
                
                let queryResultCol11 = sqlite3_column_text(preparedQuery, 11)
                let designer = String(cString: queryResultCol11!)
                
                let wishList = (sqlite3_column_int(preparedQuery, 12)) == 1 ? true : false
                let collection = (sqlite3_column_int(preparedQuery, 12)) == 1 ? true : false
                
                var publist:[String] = []
                publist.append(publisher)
                let boardGame = BoardGame(id: String(id), name: name, yearPublished: yearPublished, playingTime: playingTime, minage: minAge, minPlayers: minPlayers, maxPlayers: maxPlayers, thumbnail: thumbnail, image: image, gameDescription: description, publisher: publist, designer: designer, wishList: wishList, collection: collection)
                boardGames.append(boardGame)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(preparedQuery)
        
        return boardGames
    }
    
    //MARK: Update
    static func updateBoardGame(connection: OpaquePointer, boardGame: BoardGame) {
        
        
        let wishlist =  boardGame.wishList == true ? 1 : 0
        let collection = boardGame.collection == true ? 1 : 0
        
        let updateStatement =
        """
        UPDATE InnovationIdeas SET
        ID = '\(boardGame.id)',
        Name = '\(boardGame.name)',
        YearPublished = \(boardGame.yearPublished),
        PlayingTime = '\(boardGame.playingTime)',
        MinAge = '\(boardGame.minage)',
        MinPlayers = '\(boardGame.minPlayers)',
        MaxPlayers = '\(boardGame.maxPlayers)',
        Thumbnail = '\(boardGame.thumbnail)',
        Image = '\(boardGame.image)',
        Description = '\(boardGame.gameDescription)',
        Publisher = '\(boardGame.publisher)',
        Designer = '\(boardGame.designer)',
        WishList = '\(wishlist)',
        Collection = '\(collection)',
        WHERE
        ID = \(boardGame.id)
        """
        
        var preparedUpdateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, updateStatement, -1, &preparedUpdateStatement, nil) == SQLITE_OK {
            sqlite3_step(preparedUpdateStatement)
        } else {
            print("UPDATE statement could not be prepared.")
        }
        
        sqlite3_finalize(preparedUpdateStatement)
    }
    
    //MARK: Delete
    static func deleteBoardGame(connection: OpaquePointer, boardGame: BoardGame) {
        let deleteStatement = "DELETE FROM BoardGameTable WHERE ID = \(boardGame.id)"
        
        var preparedDeleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(connection, deleteStatement, -1, &preparedDeleteStatement, nil) == SQLITE_OK {
            sqlite3_step(preparedDeleteStatement)
        } else {
            print("DELETE statement could not be prepared.")
        }
        
        sqlite3_finalize(preparedDeleteStatement)
    }
    
}
