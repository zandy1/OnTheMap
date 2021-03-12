//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Alexander Brown on 3/3/21.
//

import Foundation
import UIKit

class OnTheMapClient {
    
    static let base = "https://onthemap-api.udacity.com/v1"
    static let limit = "?limit=100"
    
    struct Auth {
           static var key = ""
           static var sessionId = ""
           static var objectId = ""
       }

    
    enum Endpoints {
        
        case createSessionId
        case createStudentLocation
        case getPublicUserData
        case getStudentLocation
        case logout
        case updateStudentLocation(String)
        case signup
    
    var stringValue: String {
        switch self {
        case .createSessionId: return base + "/session"
        case .createStudentLocation: return base + "/StudentLocation"
        case .getPublicUserData: return base + "/users/" + Auth.key
        case .getStudentLocation: return base + "/StudentLocation" +  "?order=-updatedAt"
        case .logout: return base + "/session"
        case .updateStudentLocation(let objectId): return base + "/StudentLocation/" + objectId
        case .signup: return "https://auth.udacity.com/sign-up"
        }
      }
    
      var url: URL {
        return URL(string: stringValue)!
      }
    }
    
    @discardableResult class func taskForGETRequest<ResponseType:Decodable>(url: URL, response: ResponseType.Type, start: Int, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionTask {
           let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let newData = data?[start..<data!.count]
            //print(String(data: newData!, encoding: .utf8))
               guard let data = data else {
                   DispatchQueue.main.async {
                    completion(nil, error)
                   }
                   return
               }
               let decoder = JSONDecoder()
               do {
                let responseObject = try decoder.decode(ResponseType.self, from: data[start..<data.count])
                   DispatchQueue.main.async {
                     completion(responseObject, nil)
                   }
               } catch {
                   do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data)
                       DispatchQueue.main.async() {
                        completion(nil, errorResponse)
                       }
                   }
                   catch {
                     DispatchQueue.main.async {
                       completion(nil, error)
                     }
                   }
               }
           }
           task.resume()
           return task
       }

    class func taskForPostRequest<ResponseType:Decodable>(url: URL, body: String, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                let newData = data?[5..<data!.count]
                //print(String(data: newData!, encoding: .utf8))
                guard let data = data else {
                    DispatchQueue.main.async {
                      completion(nil, error)
                    }
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let responseObject = try decoder.decode(ResponseType.self, from: data[5..<data.count])
                    DispatchQueue.main.async {
                      completion(responseObject, nil)
                    }
                } catch {
                    do {
                        let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data[5..<data.count])
                        DispatchQueue.main.async() {
                          completion(nil, errorResponse)
                        }
                    }
                    catch {
                      DispatchQueue.main.async {
                        completion(nil, error)
                      }
                    }
                }
            }
            task.resume()
        }


    class func getStudentLocation(completion: @escaping (Bool,Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, response: GetLocationResponse.self, start: 0) { (response, error) in
                   if let response = response {
                    OnTheMapModel.studentInformation = response.results
                    completion(true,nil)
                   }
                   else {
                    completion(false,error)
                   }
               }

    }
 
    class func getPublicUserInformation(completion: @escaping (User?,Error?) -> Void) {
        print("Getting Public Information")
        taskForGETRequest(url: Endpoints.getPublicUserData.url, response: User.self, start: 5) { (response, error) in
                   if let response = response {
                    print(response.firstName)
                    print(response.lastName)
                    completion(response,nil)
                   }
                   else {
                    completion(nil,error)
                   }
               }

    }
     
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
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
        if error != nil { // Handle error…
              return
          }
          //let range = Range(5..<data!.count)
          //let newData = data?.subdata(in: range) /* subset response data! */
          let newData = data?[5..<data!.count]
            Auth.sessionId = ""
            print(String(data: newData!, encoding: .utf8))
            completion()
        }
        task.resume()
    }
    
    class func createSessionId(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
            let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPostRequest(url: Endpoints.createSessionId.url, body: body, response: SessionResponse.self) { (response, error) in
                if let response = response {
                   Auth.key = response.account.key
                    print(Auth.key)
                   Auth.sessionId = response.session.id
                    print(Auth.sessionId)
                   completion(true,nil)
                }
                else {
                    completion(false,error)
                }
            }
        }
    
    
    class func createStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
            let body = "{\"uniqueKey\": \"\(Auth.key)\",\"firstName\": \"\(firstName)\",\"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\",\"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
            //let body = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}"
            print("Create Body")
            print(body)
            taskForPostRequest(url: Endpoints.createSessionId.url, body: body, response: CreateStudentResponse.self) { (response, error) in
                  if let response = response {
                    Auth.objectId = response.objectId
                    completion(true,nil)
                  }
                  else {
                      completion(false,error)
                  }
              }
          }
    
    class func updateStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = "{\"uniqueKey\": \"\(Auth.key)\",\"firstName\": \"\(firstName)\",\"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\",\"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}"
        print("Update Body")
        print(body)
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/c14rkasloqil40hibqu0"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        //request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              completion(false,error)
          }
          else {
            print(String(data: data!, encoding: .utf8)!)
            DispatchQueue.main.async {
              completion(true, nil)
            }
          }
        }
        task.resume()
    }

}
