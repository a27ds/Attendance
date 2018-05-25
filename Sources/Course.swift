//
//  Course.swift
//  PerfectTemplate
//
//  Created by a27 on 2018-05-24.
//

import Foundation

class Course: Codable {
    var name: String
    var lessons: [Lesson]
    var students: Students
    
    private enum CodingKeys : String, CodingKey {
        case name
        case lessons
        case students
    }
    init(name: String) {
        self.name = name
        self.lessons = [Lesson]()
        self.students = Students()
    }
    
    init(name: String, lesson: [Lesson]) {
        self.name = name
        self.lessons = lesson
        self.students = Students()
    }
    
    func addLesson(date: String) {
        let newLesson = Lesson(date: date)
        for student in students.studentList {
            newLesson.addAttendingStudent(studentId: student.id)
        }
        lessons.append(newLesson)
    }
    
    func toJson(course: Course) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(course)
        return (String(data: data!, encoding: .utf8)!)
    }
    
    func fromJson(_ jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            _ = try? JSONDecoder().decode(Course.self, from: jsonData)
        }
    }
}
