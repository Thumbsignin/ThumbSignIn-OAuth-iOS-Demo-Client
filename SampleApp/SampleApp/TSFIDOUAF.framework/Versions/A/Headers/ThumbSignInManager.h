//
//  ThumbSignInManager.h
//  TSFIDOUAF
//
//
//  Copyright © 2017 Thumbsignin, a Business unit of Pramati Technologies. All rights reserved.


#import <Foundation/Foundation.h>
#import "ThumbSignInTransaction.h"

typedef NS_ENUM(NSInteger, TSErrorsEnum)
{
  /*UAF protocol failure*/
  TS_TECHNICAL_ERROR=8001,
  /* User cancelled the transaction when touchID is prompted*/
  TS_USER_CANCELLED=8002,
  /*TouchID is not available or setup*/
  TS_NO_SUITABLE_AUTHENTICATOR=8003,
  /*If the APPID configured in  the plist failed during configuration check with the ThumbSignIn server*/
  TS_APPID_VALIDATION_FAILED=8004,
  /*If the device is jailbroken*/
  TS_DEVICE_JAILBROKEN=8005,
  /*If the operation failed due to untrusted bundle identifier. The bundle identfier configured in the ThumbSignIn Dashboard does not match with the one in the project*/
  TSERROR_UNTRUSTED_FACETID=8006,
  /*IF the SDK version is unsupported*/
  TSERROR_UNSUPPORTED_VERSION=8007,
  /*If the operation failed due to some unknown reason*/
  TSERROR_UNKNOWN=8008,
  /*Internet connectivity error*/
  TSERROR_NETWORK=8009,
  TSERROR_REGISTRATION_NOT_AVAILABLE=8010,
  TSERROR_SAME_USER_ALREADY_REGISTERED=8011,
  TSERROR_INVALID_ERROR_QRCODE=8012,
  TSERROR_TIMED_OUT=8013,
  /*Default Enum*/
  TSERROR_NULL=8999
};

typedef void (^TSSuccessCallBackBlock)(ThumbSignInTransaction *thumbSignInModel);
typedef void (^TSErrorCallBackBlock)(NSError *TSError);

@interface ThumbSignInManager : NSObject
{
}
/**
 Singleton method
 
 @return ThumbSignInManager Singleton Instance Object
 */
+(instancetype) sharedManager;

/**
 Invoke this method in the didFinishLaunchingWithOptions method.
 This function sets up the intial configuration setup.
 */
-(void)startManager;
/**
 Invoke this method in the didFinishLaunchingWithOptions method.
 This function stops the monitoring.
 */
-(void)stopManager;

/**
 Invoke this method to check whether a user is regsitered.
 */
-(BOOL)isUserRegistered;
/**
 Invoke this method to enable Alternative Login Mechanism  that will shown, if user cancels the Biometric authentication mechanism.
 */
-(void)enableAlternateLoginMechanism;
/**
 Invoke this method to disable Alternative Login Mechanism that is shown if user cancels the Biometric authentication mechanism.
 */
-(void)disableAlternateLoginMechanism;

/* Website Login Integration API */
/**
 This function is to initiate the QR code based Registration and Authentication in  ThumbSignIn  server using the QR code shown in the website after legacy login flow.
 
 
 @param QRContent QRContent which is scanned from the QR code shown in the website
 @param successCallback successCallback block to be performed after Successful Operation
 @param errorCallback errorCallback block to be performed after Successful Operation
 */
-(NSDictionary*)scanQRcode:(NSString *)QRContent withSuccessCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;

/* Mobile login integration API */
/**
 This function is to register the user in  ThumbSignIn server after legacy login flow.
 
 @param userIdentifier identifier of the user (Note: userIdentifier can be an internal mapping to the user provided to ThumbSignIn, not necessarily be the actual username or user id in your platform).
 @param successCallback successCallback block to be performed after Successful Operation
 @param errorCallback errorCallback block to be performed after Successful Operation
 */


-(void)registerUser:(NSString*)userIdentifier successCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;

/**
 This function is to authenticate the user in ThumbSignIn server using TouchID.
 
 @param successCallback successCallback block to be performed after Successful Operation
 @param errorCallback errorCallback block to be performed after Successful Operation
 */
-(void)authenticateWithSuccessCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;

/**
 This function is to authenticate the transaction for a user.
 
 @param description transactionDescription description of the transaction that needs to be displayed to user during TouchID prompt.
 Make sure its short
 @param successCallback successCallback block to be performed after Successful  Operation
 @param errorCallback errorCallback block to be performed after Successful  Operation
 */
-(void)authenticateTransactionWithDescription:(NSString*)description successCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;
/**
 This function is to deregister the user.
 
 @param successCallback successCallback block to be performed after Successful Operation
 @param errorCallback errorCallback block to be performed after Successful Operation
 */
-(void)deregisterUserWithSuccessCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;

/**
 This function is to handle the deeplink.
 
 @param deepLinkParameters parameters dictionary you receive from  Branch.io
 @param successCallback successCallback block to be performed after Successful Operation
 @param errorCallback errorCallback block to be performed after Successful Operation
 */
-(void)handleDeepLinkViaBranch:(NSDictionary *)deepLinkParameters withSuccessCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;
/**
 This function is to handle the deeplink.
 
 @param URL url you receive from  - (BOOL)application:(UIApplication *)app openURL delegate function
  @param viaWebview set the Bool value as true if deeplink is handled via webview.
 @param successCallback successCallback block to be performed after Successful Operation
 @param errorCallback errorCallback block to be performed after Successful Operation
 */
-(void)handleDeepLinkViaURLSchema:(NSURL *)url viaWebview:(BOOL)viaWebview withSuccessCallback:(TSSuccessCallBackBlock)successCallback errorCallback:(TSErrorCallBackBlock)errorCallback;

-(void)setUpRegistrationPrompt:(NSString *)registrationPrompt andAuthenticationPrompt:(NSString*)authenticationPrompt;
@end

