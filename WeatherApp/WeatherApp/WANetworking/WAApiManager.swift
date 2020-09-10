//
//  WAApiManager.swift
//  WeatherApp
//
//  Created by qiaoliwen on 2020/9/10.
//  Copyright © 2020 qiaoliwen. All rights reserved.
//

import UIKit

// MARK: - /*--------- http source ---------*/
protocol WAApiManager: class{
    func doActionAfterHttp(httpResult: Any, httpTag: String)
}

extension WAApiManager{
    
    private func generateURLRequest(httpSubUrl: String,
                                    httpMethod: String,
                                    bodyParams: [String: Any]? = nil,
                                    urlParams: [String: String]? = nil) -> URLRequest?{
        var theSubUrl = httpSubUrl
        if let theUrlParams = urlParams {
            var theUrlParamsString = ""
            for (key,value) in theUrlParams {
                theUrlParamsString = theUrlParamsString + key + "=" + value + "&" ;
            }
            //remove the last "&"
            if theUrlParamsString.count > 0 {
                theUrlParamsString = String(theUrlParamsString.prefix(theUrlParamsString.count - 1 ))
                theSubUrl = theSubUrl + "?" + theUrlParamsString
            }
        }
        guard let url = URL(string: WAConstant.BASE_URL + theSubUrl) else {return nil}
        print("url\(url)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        if let theBodayParams = bodyParams{
            urlRequest.httpBody = theBodayParams.percentEncoded()
        }
        return urlRequest
    }
   
    private func generateURLRequest(httpDic: [String: String], bodyParams: [String: Any]? = nil, urlParams: [String: String]? = nil) -> URLRequest?{
        
        let httpSubUrl = httpDic["httpSubUrl"] ?? ""
        let method = httpDic["httpMethod"] ?? "get"

        let urlRequest = generateURLRequest(httpSubUrl: httpSubUrl, httpMethod: method, bodyParams: bodyParams, urlParams: urlParams)
        return urlRequest
    }
    
    func httpRequestAction(httpRequest: [String: String]? = nil, bodyParams: [String: Any]? = nil, urlParams: [String: String]? = nil, httpTag: String)  {
        var urlSessionDataTask: URLSessionDataTask?
        
        urlSessionDataTask?.cancel()
        
        guard let urlRequest = generateURLRequest(httpDic: httpRequest ?? [:], bodyParams: bodyParams, urlParams: urlParams)
            else{  return  }
        let urlSession = URLSession.shared
        urlSessionDataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                print(error)
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    if let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) {
                        //let httpResult = jsonData as? [String: Any] ?? [:]
                        //print("GMUploadToServer httpResult\(httpResult)")
                        //                        let httpResultData = httpResult["data"] as? [[String: Any]] ?? []
                        //                        print("httpResultData\(httpResultData)")
                       
                        DispatchQueue.main.async {
                            self.doActionAfterHttp(httpResult: jsonData, httpTag: httpTag)
                        }
                    }
                    return //不需要显示错误消息。
                }
            } else {
                print("Failure! \(String(describing: response) )")
            }
        })
        urlSessionDataTask?.resume()
    }
    
    
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

