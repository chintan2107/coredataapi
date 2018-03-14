

import UIKit
import Alamofire

class ViewController: UIViewController {

    var params = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        params = ["": ""]
        
    
//        let urlString = URL(string: "http://jsonplaceholder.typicode.com/users/1")
//
//        if let url = urlString {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    print(error)
//                } else {
//                    if let usableData = data {
//                        print(usableData) //JSONSerialization
//
//                        do {
//
//                            let parsedData = try JSONSerialization.jsonObject(with: usableData) as! NSDictionary
//                             print(parsedData.value(forKey: "address"))
//
//                        } catch let error as NSError {
//                            print(error)
//                        }
//
//                    }
//                }
//            }
//            task.resume()
//        }
        
            
//        Alamofire.request(baseUrl, method: .get, parameters: nil ,encoding: JSONEncoding.default, headers: nil).responseJSON {
//            response in
//            switch response.result {
//            case .success:
//                let res : NSDictionary = response.value! as! NSDictionary
//                print(res)
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
        
        
//        params = [
//            "email":"test@test.com",
//            "password":"123456",
//            "device_id":UIDevice.current.identifierForVendor!.uuidString
//        ]
//
//
//        AppData.sharedInstance.ShowProgress()
//        Alamofire.request(BASE_URL, method: .post, parameters: params ,encoding: JSONEncoding.default, headers: nil).responseJSON {
//            response in
//            switch response.result {
//            case .success:
//                AppData.sharedInstance.DismissProgress()
//                let res : NSDictionary = response.value! as! NSDictionary
//                print(res)
//                break
//            case .failure(let error):
//                AppData.sharedInstance.DismissProgress()
//                print(error)
//            }
//        }
        

        
//        DTAPIClient.sharedInstance.getApiCalling(baseUrl: BASE_URL) { (responce, data, error) in
//           print(responce)
//        }
        
        
        
        //        let image = UIImage(named : "ic_feedback")
        //        let data = UIImageJPEGRepresentation(image!, 0.5)
        //        self.requestWith(imageData: data, parameters: params)
    }
    
    func requestWith(imageData: Data?, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){


        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }

            if let data = imageData{
                multipartFormData.append(data, withName: "filedata", fileName: "photo.png", mimeType: "image/png")
            }

        }, usingThreshold: UInt64.init(), to: BASE_URL, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.value)
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

