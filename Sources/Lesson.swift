//
//  Lesson.swift
//  PerfectTemplate
//
//  Created by a27 on 2018-05-24.
//

import Foundation

class Lesson: Codable {
    var date: String
    var attendance: [Attendance]
    
    private enum CodingKeys : String, CodingKey {
        case date
        case attendance
    }
    
    init(date: String) {
        self.date = date
        self.attendance = [Attendance]()
    }
    
//    func listAllAttendance() -> String {
//        var out = [String]()
//
//        for a in attendance {
//            out.append(a.toJson(attendance: a))
//        }
//        return "[\(out.joined(separator: ","))]"
//    }
    
    func addAttendingStudent(studentId: Int) {
        let newAttendingStudent = Attendance(studentId: studentId, attended: false)
        attendance.append(newAttendingStudent)
    }
    
    func toJson(lesson: Lesson) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(lesson)
        return (String(data: data!, encoding: .utf8)!)
    }
    
    func fromJson(_ jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            _ = try? JSONDecoder().decode(Lesson.self, from: jsonData)
        }
    }
}
