//
//  String+Extension.swift
//  LFW
//
//  Created by Jassie on 28/05/2018.
//  Copyright © 2018 CodingPixel. All rights reserved.
//

import Foundation
import UIKit

protocol StringType { var get: String { get } }
extension String: StringType { var get: String { return self } }
extension Optional where Wrapped: StringType {
    func unwrap() -> String {
        return self?.get ?? ""
    }
}


extension String{
    
    
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
    
    func decodeUFT8() -> String {
        let data = self.data(using: .utf8)!
        let str = String(data: data, encoding: .nonLossyASCII)
        return str!
    }
    
    func encodeUFT8() -> String {
        let  cmt  = self.data(using: .nonLossyASCII)
        let text = String(data: cmt!, encoding: .utf8)
        return text!
    }
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passwordRegEx = "^([?=.*?a-z0-9A-Z]).{8,20}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    func getAlphabatic(i : Int) -> Character {
        let startingValue = Int(("A" as UnicodeScalar).value) // 65
        return Character(UnicodeScalar(i + startingValue)!)
    }
   
    func deleteHTMLTag(tag:String) -> String {
            return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
                mutableString = mutableString.deleteHTMLTag(tag: tag)
            }
            return mutableString
        }
  
        var parseJSONString: AnyObject? {
            
            let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

            if let jsonData = data {
                // Will return an object or nil if JSON decoding fails
                do{
                    if let json = try (JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary){
                            return json
                    }else{
                    let json = try (JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray)
                            return json
                    }
                    
                }catch{
                    print("Error")
                }
                
            } else {
                // Lossless conversion of the string was not possible
                return nil
            }
            
            return nil
    }
}

extension StringProtocol {
    
    var string: String { return String(self) }
    
    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }
    
    subscript(_ range: CountableRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: CountableClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    
    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}

extension Substring {
    var string: String { return String(self) }
} 

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func capitalizingFirstLetterRestLowercase() -> String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }
    
    mutating func capitalizeFirstLetterRestLowercase() {
        self = self.capitalizingFirstLetterRestLowercase()
    }

}
extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
}


/**
     Formats a phone-number to correct format
     - Parameter pattern: The pattern to format the phone-number.
     - Example:
        - x: Says that this should be a digit.
        - y: Says that this digit cannot be a "0".
        - The length of the pattern restricts also the length of allowed phone-number digits.
            - phone-number: "+4306641234567"
            - pattern: "+xx (yxx) xxxxxxxxxxx"
            - result: "+43 (664) 1234567"

     - Throws:
        - PhoneNumberFormattingError
            - wrongCharactersInPhoneNumber: if phone-number contains other characters than digits.
            - phoneNumberLongerThanPatternAllowes: if phone-number is longer than pattern allows.
     - Returns:
        - The formatted phone-number due to the pattern.
     */

enum PhoneNumberFormattingError: Error {
    case wrongCharactersInPhoneNumber
    case phoneNumberLongerThanPatternAllowes
}

enum PhoneNumberFormattingPatterns: String {
    case mobile = "+xx (yxx) xxxxxxxxxxx"
    case home = "+xx (yxxx) xxxx-xxx"
}

extension String {
    
    
    
    func convertToFormattedPhoneNumber(withPattern pattern: PhoneNumberFormattingPatterns) throws -> String {
        let phoneNumber = self.replacingOccurrences(of: "+", with: "")
        var retVal: String = ""
        var index = 0
        for char in pattern.rawValue.lowercased() {
            guard index < phoneNumber.count else {
                return retVal
            }

            if char == "x" {
                let charIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: index)
                let phoneChar = phoneNumber[charIndex]
                guard "0"..."9" ~= phoneChar else {
                    throw PhoneNumberFormattingError.wrongCharactersInPhoneNumber
                }
                retVal.append(phoneChar)
                index += 1
            } else if char == "y" {
                var charIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: index)
                var indexTemp = 1
                while phoneNumber[charIndex] == "0" {
                    charIndex = phoneNumber.index(phoneNumber.startIndex, offsetBy: index + indexTemp)
                    indexTemp += 1
                }

                let phoneChar = phoneNumber[charIndex]
                guard "0"..."9" ~= phoneChar else {
                    throw PhoneNumberFormattingError.wrongCharactersInPhoneNumber
                }
                retVal.append(phoneChar)
                index += indexTemp
            } else {
                retVal.append(char)
            }
        }

        if phoneNumber.endIndex > phoneNumber.index(phoneNumber.startIndex, offsetBy: index) {
            throw PhoneNumberFormattingError.phoneNumberLongerThanPatternAllowes
        }

        return retVal
    }
}
