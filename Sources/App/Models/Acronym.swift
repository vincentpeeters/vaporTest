//
//  Acronym.swift
//  App
//
//  Created by Vincent Peeters on 23/12/2019.
//

import Foundation
import Vapor
import FluentMySQL

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    init(short: String, long: String) { self.short = short
        self.long = long }
}

extension Acronym: MySQLModel {}

extension Acronym: Migration {}


extension Acronym: Content {}
