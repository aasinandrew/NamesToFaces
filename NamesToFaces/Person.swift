//
//  Person.swift
//  NamesToFaces
//
//  Created by Andrew  Nguyen on 10/2/15.
//  Copyright © 2015 Andrew Nguyen. All rights reserved.
//

import Foundation

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}