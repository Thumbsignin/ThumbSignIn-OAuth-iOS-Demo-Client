//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Suresh Thiruppathi on 4/13/18.
//  Copyright © 2018 Pramati Technologies. All rights reserved.
//

import UIKit
import AuthenticationViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    /*Set up ThumbSignIn Manager */
    
    let thumbSignInManger = ThumbSignInManager.shared()
    thumbSignInManger?.start()
    BITHockeyManager.shared().configure(withIdentifier: "85e5ee49db0b42e7b9e23e1e6887a27b")
    // Do some additional configuration if needed here
    BITHockeyManager.shared().start()
    BITHockeyManager.shared().authenticator.authenticateInstallation()

    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
 
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    
    
    if let sourceApp = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String {
      
      /*Check for sourceapplication in options array to identify whether it's a mobile browser or Webview (in-app browser) */
      
      if let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
, (sourceApp.caseInsensitiveCompare("com.apple.SafariViewService") == ComparisonResult.orderedSame) {
            // Before doing this, you should check the url is your redirect-uri before doing anything. Be safe
        if let queryItems = components.queryItems
          , let queryName = queryItems.first?.name
          , queryName == "code"
          , let code = queryItems.first?.value {
          
          /* Once user registers or authenticates via ThumbSignIn, IDP hands over the Auth code to the client App as query Parameter*/
          print("Auth Token :\(code)")
          
          // Let's find the instance of our authentication controller,
          // it would be the presentedViewController. This is another
          // reason to check before that we are actually coming from the SFSafariViewController
  
          if let rootViewController = window?.rootViewController, let authenticationViewController = rootViewController.presentedViewController as? AuthenticationViewController {
            //Step 3
            /*)Invoking the IDP's Token endpoint using Auth code */
            authenticationViewController.authenticateWithCode(code)
          }
        }
      else if components.host == "loggedOut"{
          print("Success")
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "IDPLoggedOut"), object: 0, userInfo:nil )
        }else {
          //Step 2
          /*  callbackURL will contain the transaction data required to  initiate Registration or Authentication process
           a) Invoke the HandleDeepLink via URL schema when user opts   to authenticate using ThumbSignIn
           b) set the viaWebview bool variable to true */
          
          JustHUD.setLoaderColor(color: UIColor(red: 43/255, green: 216/255, blue: 153/255, alpha: 1))
          self.window?.windowLevel = UIWindowLevelNormal;
          JustHUD.shared.showInWindow(window: self.window!)
          
          let when = DispatchTime.now() + 3 // change 2 to desired number of seconds
          DispatchQueue.main.asyncAfter(deadline: when) {
            JustHUD.shared.hide()
          }
          ThumbSignInManager.shared().handleDeepLink(viaURLSchema: url, viaWebview:true
            , withSuccessCallback: { (transaction) in
            
            print("transaction\(String(describing: transaction))")
          }) { (tsError) in
            
            print("tsError\(String(describing: tsError))")
          }
        }
      }
      return true
    }
    return false
  }
}

