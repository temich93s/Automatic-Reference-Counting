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


//MARK: Циклы сильных ссылок между экземплярами классов
print("\n//Циклы сильных ссылок между экземплярами классов")

class Person1 {
    let name: String
    init(name: String) { self.name = name; print("\(name) is being initialized")}
    var apartment: Apartment1?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment1 {
    let unit: String
    init(unit: String) { self.unit = unit; print("\(unit) is being initialized")}
    var tenant: Person1?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person1?
var unit4A: Apartment1?

john = Person1(name: "John Appleseed")
unit4A = Apartment1(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john

john = nil
unit4A = nil


//MARK: Замена циклов сильных ссылок между экземплярами классов
print("\n//Замена циклов сильных ссылок между экземплярами классов")


class Person2 {
    let name: String
    init(name: String) { self.name = name; print("\(name) is being initialized") }
    var apartment: Apartment2?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment2 {
    let unit: String
    init(unit: String) { self.unit = unit; print("\(unit) is being initialized") }
    weak var tenant: Person2?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john2: Person2?
var unit4A2: Apartment2?

john2 = Person2(name: "John Appleseed")
unit4A2 = Apartment2(unit: "4A")

john2!.apartment = unit4A2
unit4A2!.tenant = john2
print(john2?.apartment as Any)

john2 = nil
// Prints "John Appleseed is being deinitialized"
print(john2?.apartment as Any)

unit4A = nil
// Prints "Apartment 4A is being deinitialized"
print(john2?.apartment as Any)
