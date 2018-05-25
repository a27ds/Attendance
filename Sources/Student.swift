//
//  Student.swift
//  PerfectTemplate
//
//  Created by a27 on 2018-05-24.
//

import Foundation

class Student: Codable {
    var firstName: String
    var lastName: String
    var id: Int
    
    private enum CodingKeys : String, CodingKey {
        case firstName
        case lastName
        case id
    }
    
    init(firstName: String, lastName: String, id: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }
    
    func toJson(student: Student) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(student)
        return (String(data: data!, encoding: .utf8)!)
    }
    
    func fromJson(_ jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            _ = try? JSONDecoder().decode(Student.self, from: jsonData)
        }
    }
}
