//
//  APIHelper.swift
//  Weather
//
//  Created by E02383 on 19/10/22.
//

import Foundation

class APIHelper: NSObject {
    
    static let shared = APIHelper()
    
    private override init() {}
    
    func getResponse(fromAPI urlString: String, method: String, completionHandler: @escaping (Data) -> Void) -> Void {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        //        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        request.httpMethod = method
        //        request.httpBody = bodyData
        
        //        request.setValue("authToken", forHTTPHeaderField: "Authorization")
        //        request.setValue("application/json", forHTTPHeaderField: "Accept")
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Handle HTTP request error")
            } else if let data = data {
                print("Handle HTTP request response")
                
                completionHandler(data)
            } else {
                print("Handle unexpected error")
            }
        }
        
        task.resume()
    }
    
}
