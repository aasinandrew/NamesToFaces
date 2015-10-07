//
//  Person.swift
//  NamesToFaces
//
//  Created by Andrew  Nguyen on 10/2/15.
//  Copyright © 2015 Andrew Nguyen. All rights reserved.
//

import Foundation

class Person: NSObject, NSCoding {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        image = aDecoder.decodeObjectForKey("image") as! String
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(image, forKey: "image")
    }
}