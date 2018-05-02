//
//  ViewController.swift
//  SampleApp
//
//  Created by Suresh Thiruppathi on 4/13/18.
//  Copyright © 2018 Pramati Technologies. All rights reserved.
//

import UIKit
import AuthenticationViewController
import SafariServices


class ViewController: UIViewController {
  @IBOutlet weak var loginToIDPButton: UIButton!
  
  @IBOutlet weak var logOutButton: UIButton!
  @IBOutlet weak var welcomeLabel: UILabel!
  
  @IBOutlet weak var userLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    welcomeLabel.isHidden = true
    userLabel.isHidden = true
    logOutButton.isHidden = true
    
    loginToIDPButton.backgroundColor = .clear
    loginToIDPButton.layer.borderWidth = 2.0
    loginToIDPButton.layer.borderColor = UIColor.white.cgColor
    loginToIDPButton.layer.cornerRadius = 5.0
    loginToIDPButton.clipsToBounds = true
    
    logOutButton.backgroundColor = .clear
    logOutButton.layer.borderWidth = 2.0
    logOutButton.layer.borderColor = UIColor.white.cgColor
    logOutButton.layer.cornerRadius = 5.0
    logOutButton.clipsToBounds = true
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func didTapLogOutButton(_ sender: Any) {
    //TODO: Handle the session token invalidation here
 
        self.loginToIDPButton.isHidden = false
    self.welcomeLabel.isHidden = true
    self.userLabel.isHidden = true
    self.logOutButton.isHidden = true
//    NotificationCenter.default.addObserver(self, selector: #selector(logOut())
//    , name: NSNotification.Name(rawValue: "IDPLoggedOut"), object: nil)
    
    let safariVC = SFSafariViewController.init(url: urlEnv.logout()!)
    present(safariVC, animated: true, completion: nil)
    let when = DispatchTime.now() + 6 // change 2 to desired number of seconds
    DispatchQueue.main.asyncAfter(deadline: when) {
       safariVC.dismiss(animated: true, completion: nil)
    }
  
  }
  
  @IBAction func didTapButton(_ sender: Any) {
    //Step 1
    
    /*Invoking the Oauth Authorize endpoint by presenting client credentials.*/
    
    let provider = OAuthThumbSignIn(clientId: "oauthClient", clientSecret: "oauthClientSecret123", scopes: ["read", "write"])
    
    print("Authorization URL :\(provider.authorizationURL)")
    
    let authenticationViewController = AuthenticationViewController(provider: provider)
    
    authenticationViewController.failureHandler = {
      error in
      // TODO: Handle Failure as needed
      print(error)
    }
    
    
    authenticationViewController.authenticationHandler = {
      [weak self] token in
      print("Access Token :\(token)")
      if let accessToken = token["access_token"] as? String {
        //Step 4
        /*Invoking the Resource Endpoint using the Access Token */
        self?.authenticateWithAccessToken(accessToken)
      } else {
        // TODO: Handle invalid token error.
      }
      
      authenticationViewController.dismiss(animated: true, completion: nil)
    }
    
    present(authenticationViewController, animated: true, completion: nil)
  }
  
  
  private func authenticateWithAccessToken(_ token: String) {
    
    let request = NSMutableURLRequest(url: urlEnv.resourceEndPoint())
    // let request = NSMutableURLRequest(url: urlEnv.resourceEndPoint() as URL, cachePolicy:  NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5.0)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
     UserDefaults.standard.set(token, forKey: "Bearer")
    URLSession.shared.dataTask(with: request as URLRequest) {
      [unowned self] (data, response, error) in
      DispatchQueue.main.async {
        
        guard error == nil else {
          //TODO: Handle Error
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse , 200..<300 ~= httpResponse.statusCode else {
          //TODO: Handle http failure
          return
        }
        
        guard let data = data else {
          //TODO: Handle invalid data
          return
        }
        
        do {
          if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
            let userID = json["userid"] as? String
            self.loginToIDPButton.isHidden = true
            self.welcomeLabel.isHidden = false
            self.welcomeLabel.text = "Welcome"
            self.userLabel.isHidden = false
            self.userLabel.text = userID
            self.logOutButton.isHidden = false
          }
        } catch {
          print(httpResponse)
        }
      }
    }.resume()
  }
  func logOut() {
    //let request = NSMutableURLRequest(url: URL(string: "https://idp-stage.thumbsignin.com/logout")!)
    guard let logoutURL = urlEnv.logout() else {
      return
    }
    let request = NSMutableURLRequest(url: logoutURL)
    print("request URL\(request)")
    request.httpMethod = "POST"

//     request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
    URLSession.shared.dataTask(with: request as URLRequest) {
      [unowned self] (data, response, error) in
      DispatchQueue.main.async {
        
        guard error == nil else {
          //TODO: Handle Error
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse , 200..<300 ~= httpResponse.statusCode else {
          //TODO: Handle http failure
          return
        }
        
        guard let data = data else {
          //TODO: Handle invalid data
          return
        }
        
        do {
          if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
            print("log out json\(json)")
          }
        } catch {
          print(httpResponse)
        }
      }
      }.resume()
  }
}




