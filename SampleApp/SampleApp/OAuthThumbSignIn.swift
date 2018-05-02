//
//  OAuthThumbSignIn.swift
//  SampleApp
//
//  Created by Suresh Thiruppathi on 4/13/18.
//  Copyright © 2018 Pramati Technologies. All rights reserved.
//

import Foundation
import AuthenticationViewController


struct OAuthThumbSignIn: AuthenticationProvider {
  
  let title: String?
  let clientId: String
  let clientSecret: String
  let scopes: [String]
  /* App URL Schema
    Protocol(sampleApp) should be same as the URL schema */
  let redirectURI = "sampleApp://callback"
  
  
  var authorizationURL: URL {
    return urlEnv.authorizationURL(clientID: clientId, scopes: scopes, redirectURI: redirectURI)
    
  }
  
  var accessTokenURL: URL {
    return urlEnv.accessTokenURL()
  }
  
  var resourceEndPoint: URL {
    return urlEnv.resourceEndPoint()
  }
  
  var parameters: [String: String] {
    return ["grant_type": "authorization_code", "redirect_uri": redirectURI]
  }
  
  // MARK: Initialisers
  
  init(clientId: String, clientSecret: String, scopes: [String]) {
    self.clientId = clientId
    self.clientSecret = clientSecret
    self.scopes = scopes
    self.title = "ThumbSignIn"
  }
}

