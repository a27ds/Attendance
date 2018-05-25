//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectHTTP
import PerfectHTTPServer
import PerfectLib

let students = Students()
let courses = Courses()


// MARK: - Routes
func addRoutes(students: Students, courses: Courses) -> Routes{
    var routes = Routes()
    
    //display all courses
    routes.add(method: .get, uri: "/course/all", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        response.appendBody(string: courses.listAll())
        response.completed()
    })
    
    //Display all students
    routes.add(method: .get, uri: "/student", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        response.appendBody(string: students.listAllStudents())
        response.completed()
    })
    
    //add new student
    routes.add(method: .post, uri: "/student", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        students.newStudent(request.postBodyString!)
        response.appendBody(string: students.listAllStudents())
        response.completed()
    })

    //searches student by student id
    routes.add(method: .get, uri: "/student/{student_id}", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        guard let studentIdString = request.urlVariables["student_id"],
            let studentIdInt = Int(studentIdString) else {
                response.completed(status: .badRequest)
                return
        }
        response.appendBody(string: students.searchStudentById(studentId: studentIdInt))
        response.completed()
    })

    //delete student by student id
    routes.add(method: .delete, uri: "/student/{student_id}", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")
        guard let studentIdString = request.urlVariables["student_id"],
            let studentIdInt = Int(studentIdString) else {
                response.completed(status: .badRequest)
                return
        }
        students.deleteStudent(studentId: studentIdInt)
        response.appendBody(string: students.listAllStudents())
        response.completed()
    })

    //change student attendance by studentId
    routes.add(method: .put, uri: "/{course_name}/attendance/{date}/{student_id}/{update}", handler: {
        request, response in
        response.setHeader(.contentType, value: "application/json")

        guard let courseNameString = request.urlVariables["course_name"] else {
            response.completed(status: .badRequest)
            return
        }

        guard let dateString = request.urlVariables["date"] else {
            response.completed(status: .badRequest)
            return
        }

        guard let studentIdString = request.urlVariables["student_id"],
            let studentIdInt = Int(studentIdString) else {
                response.completed(status: .badRequest)
                return
        }

        guard let updateString = request.urlVariables["update"],
            let updateBool = Bool(updateString) else {
                response.completed(status: .badRequest)
                return
        }

        response.appendBody(string: courses.updateAttendance(courseSearch: courseNameString, dateSearch: dateString, idSearch: studentIdInt, update: updateBool))
        response.completed()
    })
    return routes
}

// MARK: - Server config
func configServer(routes: Routes) -> HTTPServer {
    let server = HTTPServer()
    server.serverPort = 8080
    server.addRoutes(routes)
    return server
}

let endRoutes = addRoutes(students: students, courses: courses)
let server = configServer(routes: endRoutes)

// MARK: - Start server
do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
