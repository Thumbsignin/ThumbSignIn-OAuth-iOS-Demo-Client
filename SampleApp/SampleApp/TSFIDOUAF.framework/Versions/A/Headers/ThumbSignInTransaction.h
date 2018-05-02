//
//  ThumbSignInModel.h
//  TSFIDOUAF
//
//  Created by Suresh Thiruppathi on 8/4/17.
//  Copyright © 2017 Pramati Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThumbSignInTransaction : NSObject

@property (nonatomic, strong) NSString *status;/*Transaction status of the operation*/
@property (nonatomic, strong) NSString *userId;/*User identity*/
@property (nonatomic, strong) NSString *transactionId;/*The Transaction ID*/
@property (nonatomic, strong) NSString *operation;/*The Transaction ID*/

@end
