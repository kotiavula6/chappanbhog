//
//  NsObject+Foundation.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 29/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    static func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func priceUSAFormat() -> String {
        
        if let myInteger = Float(self) {
            let myNumber = NSNumber(value: myInteger)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            return formatter.string(from: myNumber)!
        }
        
        return "$0.00"
    }
    
    static func checkNullValue(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        return (valueString as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    static func checkNullValue_Dash(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = "-"
        }
        return (valueString as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func checkNullValue_NA(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = "NA"
        }
        return (valueString as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    
    static func checkRatingValue(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = "New"
        }
        else {
            if (valueString as! CGFloat) == 0.0 {
                valueString = "New"
            }
            else {
                valueString = String(format: "%.1f", valueString as! CGFloat)
            }
        }
        return valueString as! String
    }
    
    static func checkNumberNull(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            valueString = String(format: "%d", valueString as! Int)
        }
        
        return valueString as! String
    }
    
    static func checkNSNumberNull(_ inputValue: Any) -> String {
        
//        print(inputValue)
        
        var valueString = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            valueString = String(valueString as! Int)
            
        }
        
        return valueString as! String
    }
    
    static func checkNumberNullWithID(_ inputValue: Any) -> Int {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = 0
        }
        else {
            
        }
        
        return valueString as! Int
    }
    
    
    static func checkFloatNull(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            
            if let someObj = valueString as? NSNumber {
                valueString = String(format: "%.2f", someObj.floatValue)
            }
            
        }
        
        return valueString as! String
    }
    
    static func checkDoubleNull(_ inputValue: Any) -> Double {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = 0.0
        }
        else {
//            valueString =  //String(format: "%.2f", valueString as! CGFloat)
        }
        
        return valueString as! Double
    }
    
    static func checkFloatLatLngNull(_ inputValue: Any) -> Float {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = 0.00000
        }
        
        return valueString as! Float
    }
    
    
    static func checkDateNull(_ dateValue: Any) -> String {
        var newDateValue: Any = dateValue
        if  (newDateValue as AnyObject).isEqual(NSNull()) {
            newDateValue = ""
        }
        else {
            
//            print(dateValue)
            
            let actualDateString = (newDateValue as! String).replacingOccurrences(of: "+00:00", with: "")
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
            var date = dateFormatter.date(from: actualDateString)
            
            // if .zzz format not coming from date format // then give only upto seconds format
            if date == nil {
                dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
                date = dateFormatter.date(from: actualDateString)
            }
            
            // if .ss format not coming from date format // then give only upto milli seconds format
            if date == nil {
                dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
                date = dateFormatter.date(from: actualDateString)
            }
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            let timeStamp = dateFormatter.string(from: date!)
//            print(timeStamp)
            
            return timeStamp
            
        }
        return newDateValue as! String
    }
    
    static func checkDateWithTimeNull(_ dateValue: Any) -> String {
        var newDateValue: Any = dateValue
        if  (newDateValue as AnyObject).isEqual(NSNull()) {
            newDateValue = ""
        }
        else {
            
            let actualDateString = (newDateValue as! String).replacingOccurrences(of: "+00:00", with: "")
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
            var date = dateFormatter.date(from: actualDateString)
            
            if date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                date = dateFormatter.date(from: actualDateString)
            }
            
            if date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                date = dateFormatter.date(from: actualDateString)
            }
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            dateFormatter.timeZone = NSTimeZone.local
            let timeStamp = dateFormatter.string(from: date!)
//            print(timeStamp)
            
            return timeStamp
            
        }
        return newDateValue as! String
    }
    
    
    static func checkBoolNull(_ value : Any) -> Bool {
        
        var newBoolValue : Any = value
        
        if (newBoolValue as AnyObject).isEqual(NSNull()) {
            newBoolValue = false
        }
        else
        {
//            print(newBoolValue)
        }
        return newBoolValue as! Bool
    }
    
    static func checkArray(_ value : Any) -> NSArray {
        
        var newValue : Any = value
        
        if (newValue as AnyObject).isEqual(NSNull()) {
            newValue = NSArray()
        }
        else
        {
//            print(newValue)
        }
        return newValue as! NSArray
    }
    
    static func checkDictionary(_ value : Any) -> NSDictionary {
        
        var newValue : Any = value
        
        if (newValue as AnyObject).isEqual(NSNull()) {
            newValue = NSDictionary()
        }
        else
        {
//            print(newValue)
        }
        return newValue as! NSDictionary
    }
    
    static func checkNumberNullWithVotesText(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            valueString = String(format: "%d", valueString as! Int)
        }
        
        var actualValue = valueString as! String
        
        if Int(actualValue) == 0 || Int(actualValue) == 1 {
            
            actualValue = String(format: "%@ Vote", actualValue)
        }
        else {
            actualValue = String(format: "%@ Votes", actualValue)
        }
        
        return actualValue
    }
    
}
