//
//  APIHandler.swift
//  Asteroid - Neo Stats
//
//  Created by Shailendra Kushwaha on 05/02/23.
//
import UIKit

class APIHandler: NSObject {
        
    static let sharedInstance = APIHandler()

    func RequestManager(url: String!, method: String!) -> URLRequest  {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData

        return request
    }

    func getAPI(params: Dictionary <String, String>, endPoint: APIConstant.EndPoint, onSuccess: @escaping(Data,Dictionary<String, Any>) -> Void, onFailure: @escaping(Error) -> Void) {
        
        guard let url  = URL(string:endPoint.path) else {
            print("Error: URL not valid")
            return
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
      
        let queryItems = params.map{
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        
        urlComponents?.queryItems = queryItems
        
        let request = self.RequestManager(url: urlComponents?.url?.description, method: "GET")
 
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async {
                do {
                    if let data {
                        let result = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                        onSuccess(data, result)
                    }
                    else if let error {
                        onFailure(error)
                    }
                    
                } catch {
                    onFailure(error)
                }
            }
            
        })
        
        task.resume()
    }
         
}


