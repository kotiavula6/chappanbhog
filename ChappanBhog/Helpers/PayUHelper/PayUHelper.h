//
//  PayUHelper.h
//  ChappanBhog
//
//  Created by Vakul Saini on 20/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PayUHelperModel;

typedef void (^PayUHelperCompletionBlock)(NSDictionary *paymentResponse, NSError *error, id extraParam);

NS_ASSUME_NONNULL_BEGIN

@interface PayUHelper : NSObject

+ (instancetype)sharedInstance;
- (void)presentPaymentScreenFromController:(UIViewController *)controller
                                  forModel:(PayUHelperModel *)paymentModel
                                completion:(PayUHelperCompletionBlock)completion;
-(NSString*)getResponseHashForPaymentParams;

@end

@interface PayUHelperModel : NSObject

@property (nonatomic, strong) NSString *shipping;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *customerName;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *merchantDisplayName;

@property (nonatomic, strong) NSString *requestHash;
@property (nonatomic, strong) NSString *txnId;
@property (nonatomic, strong) NSArray *details;

@end

NS_ASSUME_NONNULL_END
