#  ThumbSignIn OAuth Identity Provider - iOS Integration Demo

This is a simple iOS client app to demonstrate the integration with sample Identity Provider developed based on OAuth 2.0 protocol using ThumbSignIn iOS SDK. 

This project shows how ThumbSignIn can be used as an Identity Provider's authentication mechanism which enables convenient login experience through  passwordless mechanism using TouchID / FaceID. For this ThumbSignIn should be integrated in the identity provider used for OAuth authentication. Refer [ThumbSignIn OAuth Identity Provider Sample](https://github.com/Thumbsignin/ThumbSignIn-OAuth-2.0-Server) for further info.


We are using [AuthenticationViewController](https://github.com/raulriera/AuthenticationViewController) library for OAuth Authentication in this demo project. Integration using any other library will also be more or less similar.



### Steps to integrate ThumbSignIn OAuth Identity Provider

 #### 1. Integrate ThumbSignIn iOS SDK. 
 Refer [ThumbSignIn documentation](https://thumbsignin.com/documentation#mobile) for more details.

 Invoke ThumbSignInManager.shared.start() in the didFinishLaunchingWithOptions lifecycle method to set the initial configuration up and running.

#### 2. Integrate OAuth Client Library
Integrate OAuth client library of your choice by configuring the required OAuth server credentials and url scheme of the application to handle callback. 

#### 3. Handle ThumbSignIn Registration / Authentication Callback

After Login using OAuth credentials, Server should be providing option to register for ThumbSignIn Authentication as an additional authentication mechanism. Server will also be providing option to Authenticate with ThumbSignin along with traditional login UI. Authentication flow will also be similar to registration as described below.

On Registration / Authentication a callback will be invoked with ThumbSignIn transaction info.

When using the  iOS 9+ Safari view controller, you will need to intercept the callback in your app delegate and let the ThumbSignIn API handle the full URL. Before Handling the URL, we have to make sure the URL is our Redirect-URI.

Invoke the ```handleDeepLink(...)``` by setting the viaWebView bool variable to true.
```swift
ThumbSignInManager.shared().handleDeepLink(viaURLSchema: url, viaWebview:true
            , withSuccessCallback: { (transaction) in
            // ... Handle Success
          }) { (tsError) in
            // ... Handle Failure
          }
````

During this flow ThumbSignInSDK will prompt the user to authenticate using TouchID / FaceID.

#### 4. Continue OAuth Authentication Handling

On Successful ThumbSignIn Registration / Authentication, OAuth flow will continue as usual by fetching the OAuth Auth code to retreive auth token. 
