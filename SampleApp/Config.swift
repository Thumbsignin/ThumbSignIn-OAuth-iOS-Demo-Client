//
//  Config.swift
//  SampleApp
//
//  Created by Suresh Thiruppathi on 4/24/18.
//  Copyright © 2018 Pramati Technologies. All rights reserved.
//

import Foundation

let urlEnv = AuthURL.stage

enum AuthURL: String {
  case dev = "http://172.17.1.9:8080/"
  case stage = "https://idp-stage.thumbsignin.com/"
  case ngrok = "http://517508a4.ngrok.io/"
  
  func authorizationURL(clientID: String, scopes: [String], redirectURI: String) -> URL {
    let authorizationEndPoint = "oauth/authorize/"
    let URLString = self.rawValue + authorizationEndPoint + "?client_id=\(clientID)&scope=\(scopes.joined(separator: "+"))&redirect_uri=\(redirectURI)&response_type=code"
    print("URLString\(URLString)")
    return URL(string: URLString)!
    
    
  }
  
  func accessTokenURL() -> URL {
    let tokenEndPoint = "oauth/token"
    return URL(string: self.rawValue + tokenEndPoint)!
  }
  
  func resourceEndPoint() -> URL {
    let resourceEndPoint = "me"
    return URL(string: self.rawValue + resourceEndPoint)!
  }
  func logout() -> URL? {
//    guard let bearerToken = UserDefaults.standard.string(forKey: "Bearer")
//      else {
//      return nil
//    }
    let logoutEndPoint = "logout.html"
    return URL(string: self.rawValue + logoutEndPoint)
  }
  
}
