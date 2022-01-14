//
//  Item.swift
//  Todoey
//
//  Created by Raeein Bagheri on 2022-01-13.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class Item: Encodable {
    init(title: String) {
        self.title = title
        
    }
    var title: String
    var done: Bool = false
}
