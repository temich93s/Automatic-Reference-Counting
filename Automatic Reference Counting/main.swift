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


//MARK: Бесхозные ссылки
print("\n//Бесхозные ссылки")

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var john3: Customer?

john3 = Customer(name: "John Appleseed")
john3!.card = CreditCard(number: 1234_5678_9012_3456, customer: john3!)

john3 = nil
// Prints "John Appleseed is being deinitialized"
// Prints "Card #1234567890123456 is being deinitialized"


//MARK: Бесхозные опциональные ссылки
print("\n//Бесхозные опциональные ссылки")

class Department {
    var name: String
    var courses: [Course?]
    init(name: String) {
        self.name = name
        self.courses = []
    }
}

class Course {
    var name: String
    unowned var department: Department
    unowned var nextCourse: Course?
    init(name: String, in department: Department) {
        self.name = name
        self.department = department
        self.nextCourse = nil
    }
    deinit {
        print("DEINIT: \(name)")
    }
}

let department = Department(name: "Horticulture")

var intro = Course(name: "Survey of Plants", in: department)
var intermediate = Course(name: "Growing Common Herbs", in: department)
var advanced: Course? = Course(name: "Caring for Tropical Plants", in: department)
var test = Course(name: "111", in: department)

intro.nextCourse = intermediate
intermediate.nextCourse = advanced
department.courses = [intro, intermediate, advanced]

for i in department.courses {
    print(i!.name)
}
print()

print(intro.department.name, intro.name, intro.nextCourse?.name, separator: "\n")
print()
print(intermediate.department.name, intermediate.name, intermediate.nextCourse?.name, separator: "\n")
print()
print(advanced!.department.name, advanced!.name, advanced!.nextCourse?.name, separator: "\n")
print()

department.courses.removeLast()

print(intro.department.name, intro.name, intro.nextCourse?.name, separator: "\n")
print()
print(intermediate.department.name, intermediate.name, intermediate.nextCourse?.name, separator: "\n")
print()
print(advanced!.department.name, advanced!.name, advanced!.nextCourse?.name, separator: "\n")
print()

for i in department.courses {
    print(i!.name)
}
print()

department.courses[1] = test

for i in department.courses {
    print(i!.name)
}
print()

print(intro.department.name, intro.name, intro.nextCourse?.name, separator: "\n")
print()
print(intermediate.department.name, intermediate.name, intermediate.nextCourse?.name, separator: "\n")
print()
print(advanced!.department.name, advanced!.name, advanced!.nextCourse?.name, separator: "\n")
print()

department.courses[1] = nil

print(intro.department.name, intro.name, intro.nextCourse?.name, separator: "\n")
print()
print(intermediate.department.name, intermediate.name, intermediate.nextCourse?.name, separator: "\n")
print()
print(advanced!.department.name, advanced!.name, advanced!.nextCourse?.name, separator: "\n")
print()

advanced = nil

// ERORR в intermediate.nextCours, так как unowned не ставит по умолчанию nil
//print(intermediate.department.name, intermediate.name, intermediate.nextCourse, separator: "\n")


//MARK: Бесхозные ссылки и неявно извлеченные опциональные свойства
print("\n//Бесхозные ссылки и неявно извлеченные опциональные свойства")

class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        print("1:", self.name, self.capitalCity)
        self.capitalCity = City(name: capitalName, country: self)
        print("2:", self.name, self.capitalCity.name, self.capitalCity.country)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        print("3:", self.name)
        self.country = country
        print("4:", self.name, self.country.name, self.country.capitalCity)
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// Prints "Canada's capital city is called Ottawa"
