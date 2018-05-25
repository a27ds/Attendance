//
//  Courses.swift
//  PerfectTemplate
//
//  Created by a27 on 2018-05-24.
//

import Foundation

class Courses: Codable {
    var courses = [Course]()
    
    private enum CodingKeys : String, CodingKey {
        case courses
    }
    
    init(){
        if !readCoursesFromFile() {
            addMockupCourses()
            addMockupLessons()
            writeCoursesToFile()
        }
    }
    
    func listAll() -> String {
        var out = [String]()
        for c in courses {
            out.append(c.toJson(course: c))
        }
        return "{\"courses\": [\(out.joined(separator: ","))]}"
    }
    func addMockupCourses() {
        courses = [
            Course(name: "Api"),
            Course(name: "Mobile Development 1"),
            Course(name: "Mobile Development 2")
        ]
    }
    
    func addMockupLessons() {
        for course in courses {
            course.addLesson(date: "2018-01-01")
            course.addLesson(date: "2018-02-01")
            course.addLesson(date: "2018-03-01")
            course.addLesson(date: "2018-04-01")
            course.addLesson(date: "2018-05-01")
        }
    }
    
    func updateAttendance(courseSearch: String, dateSearch: String, idSearch: Int, update: Bool) -> String{
        for (index, course) in courses.enumerated() {
            if courseSearch == course.name{
                for (index,lesson) in course.lessons.enumerated() {
                    if dateSearch == lesson.date {
                        for (index, student) in lesson.attendance.enumerated() {
                            if idSearch == student.studentId {
                                student.attended = update
                                writeCoursesToFile()
                                return "Attendance for StudentId: \(idSearch), on course \(courseSearch) on date: \(dateSearch) is updated to \(update)"
                            } else if (index == lesson.attendance.count - 1 )  {
                                return "Course and lesson are found, but not the studentId: \(idSearch)"
                            }
                        }
                    } else if (index == course.lessons.count - 1) {
                        return "Course found but not lesson date"
                    }
                }
            } else if (index == courses.count - 1) {
                return "Course not found"
            }
        }
        return "Super-ERROR!"
    }
    
    func readCoursesFromFile() -> Bool{
        let fileName = "attendanceCoursesSave"
        let dir = try? FileManager.default.url(for: .libraryDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let allJSON = try JSONDecoder().decode([Course].self, from: data)
                for a in allJSON {
                    courses.append(Course(name: a.name, lesson: a.lessons))
                }
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                return false
            }
        }
        return true
    }
    
    func writeCoursesToFile() {
        // MARK: - Test to write to a file
        let fileName = "attendanceCoursesSave"
        let dir = try? FileManager.default.url(for: .libraryDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("json") {
            print(fileURL)
            // Write to the file named Test
            let outString = try? JSONEncoder().encode(courses)
            do {
                try outString?.write(to: fileURL)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
    }
    
    func toJson(courses: Courses) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(courses)
        return (String(data: data!, encoding: .utf8)!)
    }
    
    func fromJson(_ jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            _ = try? JSONDecoder().decode(Courses.self, from: jsonData)
        }
    }
}

