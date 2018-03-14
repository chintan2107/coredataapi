

import UIKit
import Alamofire
//import AFNetworking

class DTAPIClient: NSObject { //Using URLSession
    
    class var sharedInstance : DTAPIClient {
        
        struct Static {
        
            static var instance : DTAPIClient = DTAPIClient()
        }
        return Static.instance
    }

    //MARK:- Get API Call
    
    func getApiCalling(baseUrl:String,completionHandler:@escaping (Any?, DataResponse<Any>, Error?)->()) ->(){
      
        Alamofire.request(baseUrl, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                
                let res : NSDictionary = response.value! as! NSDictionary
                 completionHandler(res, response, nil)
                break
            case .failure(let error):
                print(error)
                completionHandler(nil, response, error)
            }
        }
    }
    
    
    func getAPICall(urlString: String!, parameters: Any!, completionHandler:@escaping (Any?, URLResponse?, Error?)->()) ->() {
        
        print("Calling API: \(urlString!)")
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let newURLString : String = (urlString! as String).replacingOccurrences(of: " ", with: "%20")
        let callURL = URL.init(string: newURLString)
        var request = URLRequest.init(url: callURL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        
        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                
                completionHandler(nil, response, error)
            }
            else{
                
                do {
                    
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
                    completionHandler(resultJson, response, nil)
                }
                catch {
                    print("Error -> \(error)")
                    completionHandler(nil, response, error)
                }
            }
            
        }
        dataTask.resume()
    }
    
    func getAPICallWithReturnData(urlString: NSString!, parameters: Any!, completionHandler:@escaping (Any?, URLResponse?, Error?)->()) ->() {
        
        print("Calling API: \(urlString!)")
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let newURLString : String = (urlString! as String).replacingOccurrences(of: " ", with: "%20")
        let callURL = URL.init(string: newURLString)
        var request = URLRequest.init(url: callURL!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        
        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                
                completionHandler(nil, response, error)
            }
            else {
                
                completionHandler(data, response, nil)
            }
            
        }
        dataTask.resume()
    }
    
    
    //MARK:- POST API Call
    func postAPICall(urlString: String!, parameters: Any!, completionHandler:@escaping (Any?, URLResponse?, Error?)->()) ->() {
        
        print("Calling API: \(urlString!)")

        var postString = String()
        if parameters != nil {
            
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let newURLString : String = (urlString! as String).replacingOccurrences(of: " ", with: "%20")
        let callURL = URL.init(string: newURLString)
        var request = URLRequest.init(url: callURL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                
                completionHandler(nil, response, error)
            }
            else{
                do {
                    
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
                    completionHandler(resultJson, response, nil)
                }
                catch {
                    completionHandler(nil, response, error)
                }
            }
            
        }
        dataTask.resume()
    }
    
    func postAPIcallWithPostData(urlString: String, parameters: Any!, postData: Data, imageKey: String,mimeType: String, completionHandler:@escaping (Any?, URLResponse?, Error?)->()) ->() {
        
        print("Calling API: \(urlString)")
        
        //Create request
        let callURL = URL.init(string: urlString as String)
        var request = URLRequest.init(url: callURL!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 240.0)
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = false
        
        let boundary = "---------------------------14737809831466499882746641449"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        //Add imagedata
        let fileName : String = imageKey
        let randomstring = ""
        
        var postExtension = String()
        
        if (mimeType == "image/png") {
            postExtension = "jpeg"
        }
        else if (mimeType == "mp4") {
            postExtension = mimeType
        }
        else if (mimeType == "gif") {
            postExtension = mimeType
        }
        
        let photoName: String = "\(randomstring).\(postExtension)"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"\(fileName)\"; filename=\"\(photoName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(postData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        //Add parameter..
        for (key, value) in parameters as! NSDictionary {
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        request.httpBody = body as Data
        request.setValue("\(body.length)", forHTTPHeaderField: "Content-Length")
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        let dataTask = urlSession.dataTask(with: request) { (data,response,error) in
            
            if error != nil {
                
                completionHandler(nil, response, error)
            }
            do {
                
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:AnyObject]
                
                completionHandler(resultJson, response, nil)
            }
            catch {
                print("Error -> \(error)")
            }
        }
        dataTask.resume()
    }
}
