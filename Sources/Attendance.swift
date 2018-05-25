//
//  Attendance.swift
//  PerfectTemplate
//
//  Created by a27 on 2018-05-24.
//

import Foundation

class Attendance: Codable {
    var studentId: Int
    var attended: Bool
    
    private enum CodingKeys : String, CodingKey {
        case studentId
        case attended
    }
    
    init(studentId: Int, attended: Bool) {
        self.studentId = studentId
        self.attended = attended
    }
    
    func toJson(attendance: Attendance) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(attendance)
        return (String(data: data!, encoding: .utf8)!)
    }
    
    func fromJson(jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            _ = try? JSONDecoder().decode(Attendance.self, from: jsonData)
        }
    }
}

