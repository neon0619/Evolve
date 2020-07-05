//
//  BaseService.swift
//  OrderAte
//
//  Created by iOS Developer on 17/02/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseService {
    //MARK:- Shared data
    private var dataRequest:DataRequest?
    
    init() {}
    
    fileprivate var sessionManager:Session {
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        return manager
    }
    
    func getHeaders() -> HTTPHeaders {
//        let headers:HTTPHeaders = [DictKeys.authoraization:Global.shared.user?.token ?? kBlankString]
        let headers:HTTPHeaders = [:]
        return headers
    }
    
    //MARK:- POST API Call
    func makePostAPICall(with completeURL:String, params:Parameters?,headers:HTTPHeaders? = nil, completion: @escaping (_ error: String, _ success: Bool, _ jsonData:JSON?)->Void){
        
        dataRequest = sessionManager.request(completeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
        
        dataRequest?
            .validate(statusCode: 200...500)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let parsedResponse = ResponseHandler.handleResponse(json)
                    
                    if parsedResponse.serviceResponseType == .Success {
                        completion(parsedResponse.message,true, parsedResponse.swiftyJsonData)
                    }else {
                        completion(parsedResponse.message,false,nil)
                    }
                    
                case .failure(let error):
                    let errorMessage:String = error.localizedDescription
                    print(errorMessage)
                    completion(PopupMessages.SomethingWentWrong, false,nil)
                }
            })
    }
    
    //MARK:- Get API Call
    func makeGetAPICall(with completeURL:String, params:Parameters?,headers:HTTPHeaders? = nil,completion: @escaping (_ error: String, _ success: Bool, _ resultList:JSON?)->Void){
        
        dataRequest = sessionManager.request(completeURL, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
        
        dataRequest?
            .validate(statusCode: 200...500)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let parsedResponse = ResponseHandler.handleResponse(json)
                    
                    if parsedResponse.serviceResponseType == .Success {
                        completion(parsedResponse.message,true, parsedResponse.swiftyJsonData)
                    }else {
                        completion(parsedResponse.message,false,nil)
                    }
                    
                case .failure(let error):
                    let errorMessage:String = error.localizedDescription
                    print(errorMessage)
                    completion(PopupMessages.SomethingWentWrong, false, nil)
                }
            })
        
    }
    
    //MARK:- Multipart Post API Call
    func makePostAPICallWithMultipart(with completeURL:String, dict:[String:Data]?, params:[String:String], headers:HTTPHeaders? = nil, completion: @escaping (_ error: String, _ success: Bool, _ jsonData:JSON?)->Void) {
        
        AF.upload(multipartFormData: { multipartFormData in


            for (key, value) in params {
                multipartFormData.append(value.data(using: .utf8)!, withName: key)
            }

            // import image to request
            for (key, value) in dict ?? [:] {
                multipartFormData.append(value, withName: key,fileName: "image.jpg", mimeType: "image/jpg")
            }

        }, to: completeURL, headers:headers)
            .responseJSON { (response) in
                switch response.result {

                case .success(let value):
                    let json = JSON(value)
                    let parsedResponse = ResponseHandler.handleResponse(json)

                    if parsedResponse.serviceResponseType == .Success {
                        completion(parsedResponse.message,true, parsedResponse.swiftyJsonData)
                    }else {
                        completion(parsedResponse.message,false,nil)
                    }

                case .failure(let error):
                    let errorMessage:String = error.localizedDescription
                    print(errorMessage)
                    completion(PopupMessages.SomethingWentWrong, false, nil)
                }
        }
        
    }
    
}
