//
//  main.swift
//  Automatic Reference Counting
//
//  Created by 2lup on 13.10.2021.
//

import Foundation

print("Hello, World!")


//MARK: ARC в действии
print("\n//ARC в действии")

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "John Appleseed")
// Prints "John Appleseed is being initialized"

reference2 = reference1
reference3 = reference1

reference1 = nil
reference2 = nil

reference3 = nil
// Prints "John Appleseed is being deinitialized"
