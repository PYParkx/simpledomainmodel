//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
    
  public func convert(_ to: String) -> Money {
    switch currency {
    case "USD":
        switch to {
        case "GBP":
            return Money(amount: amount / 2, currency: to)
        case "EUR":
            return Money(amount: Int(Double(amount) * 1.5), currency: to)
        case "CAN":
            return Money(amount: Int(Double(amount) * 1.25), currency: to)
        default:
            print("Unknown Currency Conversion")
        }
    case "GBP":
        switch to {
        case "USD":
            return Money(amount: amount * 2, currency: to)
        case "EUR":
            return Money(amount: Int(Double(amount) * 3), currency: to)
        case "CAN":
            return Money(amount: Int(Double(amount) * 5 / 2), currency: to)
        default:
            print("Unknown Currency Conversion")
        }
    case "EUR":
        switch to {
        case "USD":
            return Money(amount: amount * 2 / 3, currency: to)
        case "GBP":
            return Money(amount: Int(Double(amount) / 3), currency: to)
        case "CAN":
            return Money(amount: Int(Double(amount) * 4 / 5), currency: to)
        default:
            print("Unknown Currency Conversion")
        }
    case "CAN":
        switch to {
        case "USD":
            return Money(amount: amount * 4 / 5, currency: to)
        case "EUR":
            return Money(amount: Int(Double(amount) * 5 / 4), currency: to)
        case "GBP":
            return Money(amount: Int(Double(amount) * 2 / 5), currency: to)
        default:
            print("Unknown Currency Conversion")
        }
    default:
        print("Unknown Currency!")
  }
    return Money(amount: amount, currency: to)
}
  
  public func add(_ to: Money) -> Money {
    let converted = self.convert(to.currency)
    return Money(amount: converted.amount + to.amount, currency: to.currency)
  }
  public func subtract(_ from: Money) -> Money {
    let converted = self.convert(from.currency)
    return Money(amount: from.amount - converted.amount , currency: from.currency)
  }
}


////////////////////////////////////
// Job
////
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }

  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }

  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let hour):
        return Int(Double(hours) * hour)
    case .Salary(let sal):
        return sal
    }
}

  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let hour):
        self.type = JobType.Hourly(hour + amt)
    case .Salary(let sal):
       self.type = JobType.Salary(sal + Int(amt))
    }
  }
}


//////////////////////////////////////
//// Person
////
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        return _job
    }
    set(value) {
        if self.age >= 16 {
            self._job = value
        }
    }
  }

  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if self.age >= 18 {
            self._spouse = value
        }
    }
  }

  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }

  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job?.type)) spouse:\(String(describing: _spouse?.firstName))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []

  public init(spouse1: Person, spouse2: Person) {
    if spouse1._spouse == nil && spouse2._spouse == nil {
        spouse1._spouse = spouse2
        spouse2._spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }

  open func haveChild(_ child: Person) -> Bool {
    if members[0].age < 21 || members[1].age < 21 {
        return false
    }
    members.append(child)
    return true
  }

  open func householdIncome() -> Int {
    var income = 0
    for i in members {
        if let haveJob = i._job {
            income += haveJob.calculateIncome(2000)
        }
    }
    return income
  }
}








