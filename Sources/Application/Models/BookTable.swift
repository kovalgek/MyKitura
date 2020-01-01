//
//  BookTable.swift
//  Application
//
//  Created by Anton Kovalchuk on 30/12/2019.
//

import SwiftKuery

class BookTable: Table
{
    let tableName = "BookTable"
    let id = Column("id", Int32.self, primaryKey: true)
    let title = Column("title", String.self)
    let price = Column("price", Float.self)
    let genre = Column("genre", String.self)
}
