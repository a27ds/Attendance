//
//  Students.swift
//  PerfectTemplate
//
//  Created by a27 on 2018-05-24.
//

import Foundation

class Students: Codable {
    var studentList = [Student]()
    
    private enum CodingKeys : String, CodingKey {
        case studentList
    }
    
    init() {
        if !readStudentsFromFile() {
            addMockupStudents()
            writeStudentsToFile()
        }
    }
    
    func addMockupStudents() {
        studentList = [
            Student(firstName: "andy", lastName: "eriksson", id: 1),
            Student(firstName: "david", lastName: "svensson", id: 2),
            Student(firstName: "jocke", lastName: "andersson", id: 3),
            Student(firstName: "micke", lastName: "svensson", id: 4),
            Student(firstName: "anders", lastName: "dager", id: 5),
            Student(firstName: "joel", lastName: "eriksson", id: 6),
            Student(firstName: "daniel", lastName: "gustafson", id: 7),
            Student(firstName: "sanna", lastName: "feldell", id: 8)
        ]
    }
    
    func listAllStudents() -> String {
        var out = [String]()
        for s in studentList {
            out.append(s.toJson(student: s))
        }
        return "{\"students\": [\(out.joined(separator: ","))]}"
    }
    
    func newStudent(_ jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            let newStudent = try? JSONDecoder().decode(Student.self, from: jsonData)
            studentList.append(newStudent!)
        }
        writeStudentsToFile()
    }
    
    func searchStudentById(studentId: Int) -> String {
        var searchedStudent: String
        for student in studentList {
            if (student.id) == studentId {
                    searchedStudent = student.toJson(student: student)
                return searchedStudent
            }
        }
        return  "studentId not found!"
    }
    
    func deleteStudent(studentId: Int) {
        for (index, student) in studentList.enumerated() {
            if (student.id) == studentId {
                studentList.remove(at: index)
            }
        }
        writeStudentsToFile()
    }
    func readStudentsFromFile() -> Bool{
        let fileName = "studentsCoursesSave"
        let dir = try? FileManager.default.url(for: .libraryDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("json") {
            do {
                let data = try Data(contentsOf: fileURL)
                let allJSON = try JSONDecoder().decode([Student].self, from: data)
                for a in allJSON {
                    studentList.append(Student(firstName: a.firstName, lastName: a.lastName, id: a.id))
                }
            } catch {
                print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
                return false
            }
        }
        return true
    }
    
    func writeStudentsToFile() {
        // MARK: - Test to write to a file
        let fileName = "studentsCoursesSave"
        let dir = try? FileManager.default.url(for: .libraryDirectory,
                                               in: .userDomainMask, appropriateFor: nil, create: true)
        
        // If the directory was found, we write a file to it and read it back
        if let fileURL = dir?.appendingPathComponent(fileName).appendingPathExtension("json") {
            print(fileURL)
            // Write to the file named Test
            let outString = try? JSONEncoder().encode(studentList)
            do {
                try outString?.write(to: fileURL)
            } catch {
                print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
            }
        }
    }
    
    func toJson(students: Students) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(students)
        return (String(data: data!, encoding: .utf8)!)
    }
    
    func fromJson(_ jsonString: String) {
        if let jsonData = jsonString.data(using: .utf8){
            _ = try? JSONDecoder().decode(Students.self, from: jsonData)
            
        }
    }
    
}
