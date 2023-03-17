//
//  main.swift
//  Project22
//
//  Created by Emir Arıkan on 28.02.2023.
//

import Foundation
let name = "Mehmet"

for letter in name{
  //  print(name[name.index(name.startIndex, offsetBy: 2)])
}
//print(name[2])
// print(name[2]) this code not working

let password = "12345"
print(password.hasPrefix("123"))
print(password.hasSuffix("345"))

print(password.deletingPrefix("12"))
//let string = "This is a test string"
//let attributes: [NSAttributedString.Key: Any] = [
//    .foregroundColor: UIColor.white,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)
//]
//let attributedString = NSMutableAttributedString(string: string)
//attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
var myMultiLineText = "this\nis\na\ntest"
print(myMultiLineText.takeLines())

extension String{
    subscript(i: Int) -> String{
        return String(self[index(startIndex, offsetBy: i)])
    }
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
        func takeLines() -> Array<String>{
            var array = [String]()
            for word in self.split(separator: "\n"){
                array.append(String(word))
            }
            return array
        
    }
    func isContainNumeric() -> Bool{
        for letter in self{
            if letter.isNumber{
                return true
            }
        }
        return false
    }
}


