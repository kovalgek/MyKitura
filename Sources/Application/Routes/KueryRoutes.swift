//
//  KueryRoutes.swift
//  Application
//
//  Created by Anton Kovalchuk on 30/12/2019.
//

import KituraContracts
import LoggerAPI
import Foundation
import SwiftKuery
import SwiftKueryPostgreSQL

func initializeKueryRoutes(app: App)
{
    App.pool.getConnection() { connection, error in
        
        guard let connection = connection else {
            Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
            return
        }
        
        App.bookTable.create(connection: connection) { result in
            guard result.success else {
                Log.debug("Failed to create table");
                return
            }
            Log.debug("success");
        }
    }
    
    app.router.post("/kuery", handler: app.insertHandler)
    app.router.get("/kuery", handler: app.selectHandler)
}

extension App
{
    static let poolOptions = ConnectionPoolOptions(initialCapacity: 1, maxCapacity: 5)
    // The createPool() will be different if you used a plugin other than PostgreSQL
    static let pool = PostgreSQLConnection.createPool(host: "localhost", port: 5432, options: [.databaseName("bookdb")], poolOptions: poolOptions)
    static let bookTable = BookTable()

    // Create connection pool and initialize BookTable here
    
    func insertHandler(book: Book, completion: @escaping (Book?, RequestError?) -> Void) {
        
        let rows = [[book.id, book.title, book.price, book.genre]]
        
        App.pool.getConnection() { connection, error in
            
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            
            let insertQuery = Insert(into: App.bookTable, rows: rows)
            
            connection.execute(query: insertQuery) { insertResult in
                guard insertResult.success else {
                    Log.error("Error executing query: \(insertResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                completion(book, nil)
            }
        }
    }
    
    func selectHandler(completion: @escaping ([Book]?, RequestError?) -> Void)
    {
        App.pool.getConnection() { connection, error in
            
            guard let connection = connection else {
                Log.error("Error connecting: \(error?.localizedDescription ?? "Unknown Error")")
                return completion(nil, .internalServerError)
            }
            
            let selectQuery = Select(from: App.bookTable)
            
            connection.execute(query: selectQuery) { selectResult in
                
                guard let resultSet = selectResult.asResultSet else {
                    Log.error("Error connecting: \(selectResult.asError?.localizedDescription ?? "Unknown Error")")
                    return completion(nil, .internalServerError)
                }
                
                var books = [Book]()
                
                resultSet.forEach() { row, error in
                    
                    guard let row = row else {
                        if let error = error {
                            Log.error("Error getting row: \(error)")
                            return completion(nil, .internalServerError)
                        } else {
                            // All rows have been processed
                            return completion(books, nil)
                        }
                    }
                    
                    // optional(Int32) -> Int
                    guard let id = row[0] as? Int32,
                        let title = row[1] as? String,
                        let price = row[2] as? Double,
                        let genre = row[3] as? String
                    else {
                        Log.error("Unable to decode book")
                        return completion(nil, .internalServerError)
                    }
                    
          
                    
                    books.append(Book(id: Int(id), title: title, price: price, genre: genre))
                }
            }
        }
    }
    
}
