//
//  OnTheMapAPI.swift
//  On The Map
//
//  Created by Anna Solovyeva on 11/08/2020.
//  Copyright © 2020 Anna Solovyeva. All rights reserved.
//

import Foundation

class OnTheMapAPI {
    
    struct Auth {
        static var accountId = 0
        static var id = ""
        static var objectId = ""
    }
    
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case studentLocation
        case addStudent
        case putStudentLocation
        case sessionId
        case getPulicData
        
        var stringValue: String {
            switch self {
            case .studentLocation:
                return Endpoints.base + "/StudentLocation" + "?order=-updatedAt"
            case .addStudent:
                return Endpoints.base + "/StudentLocation"
            case .putStudentLocation:
                return Endpoints.base + "/StudentLocation" + "/\(Auth.objectId)"
            case .sessionId:
                return Endpoints.base + "/session"
            case .getPulicData:
                return Endpoints.base + "/users/\(Auth.id)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue.self)!
            }
    }
    
    
    // TASK FOR "GET" REQUEST
    class func taskForGETRequest<ResponseType: Decodable> (url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // RESPONSE
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    
    // GETTING STUDENTS' LOCATION
    class func getStudentLocation(completion: @escaping ([Results], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocation.url, responseType: StudentResults.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
                print(response.results)
            } else {
                completion([], error)
            }
        }
    }
    
    
    // ADDING NEW STUDENT'S LOCATION
    class func postStudentLocation(location: String, mediaUrl: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.addStudent.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Anna\", \"lastName\": \"Solovyeva\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(NewStudentResponse.self, from: data)
                DispatchQueue.main.async {
                    Auth.objectId = responseObject.objectId
                    completion(true, nil)
                }
                print(Auth.objectId)
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    
    class func putStudentLocation(location: String, mediaUrl: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let url = Endpoints.putStudentLocation.url
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Anna\", \"lastName\": \"Solovyeva\",\"mapString\": \"\(location)\", \"mediaURL\": \"\(mediaUrl)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                completion(false, error)
            }
              return
          } else {
            DispatchQueue.main.async {
                completion(true, nil)
            }
            }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    class func postSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.sessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                completion(false, error)
            }
              return
          } else {
            DispatchQueue.main.async {
                completion(true, nil)
            }
            }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(NewSessionResponse.self, from: newData!)
                DispatchQueue.main.async {
                    Auth.id = responseObject.session.id
                }
                print(Auth.id)
                
            } catch {
                    print(error)
            }
        }
        task.resume()
    }
    
    
    class func deleteSessionId(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.sessionId.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                completion(false, error)
            }
            return
          } else {
            DispatchQueue.main.async {
                completion(true, nil)
            }
            }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    class func getPublicUserData(completion: @escaping (Bool, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getPulicData.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil {
            DispatchQueue.main.async {
                completion(false, error)
            }
              return
          } else {
            DispatchQueue.main.async {
                completion(true, nil)
            }
            }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range)
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
