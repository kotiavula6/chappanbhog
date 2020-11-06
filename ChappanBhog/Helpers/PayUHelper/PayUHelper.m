//
//  PayUHelper.m
//  ChappanBhog
//
//  Created by Vakul Saini on 20/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

#import "PayUHelper.h"
#import <PlugNPlay/PlugNPlay.h>
#import <CommonCrypto/CommonDigest.h>


#define kPayUSuccessURL @"https://www.payumoney.com/mobileapp/payumoney/success.php"
#define kPayUFailureURL @"https://www.payumoney.com/mobileapp/payumoney/failure.php"

//#define IS_STAGE

#ifdef IS_STAGE
    // My Account
    #define kPayUMerchantKey  @"mdyCKV"
    #define kPayUMerchantID   @"4914106"
    #define kPayUMerchantSalt @"Je7q3652"
#else
    // Client Account
    #define kPayUMerchantKey  @"g497XxdV"
    #define kPayUMerchantID   @"7144230"
    #define kPayUMerchantSalt @"XiQUkxBYej"
#endif


@interface PayUHelper()
@property (nonatomic, strong) PayUHelperModel *currentPaymentModel;
@property (nonatomic, strong) PUMTxnParam *txnParams;
@end

@implementation PayUHelper

+ (instancetype)sharedInstance {
    static PayUHelper *pu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pu = [[PayUHelper alloc] init];
    });
    return pu;
}

- (PUMEnvironment)enviorenment {
    return PUMEnvironmentProduction;
}

- (void)presentPaymentScreenFromController:(UIViewController *)controller
                                  forModel:(PayUHelperModel *)paymentModel
                                completion:(PayUHelperCompletionBlock)completion {
    [PlugNPlay setMerchantDisplayName:paymentModel.merchantDisplayName];
    // [PlugNPlay setOrderDetails:@[@{@"From": @"Delhi"}, @{@"To": @"Pune"}]];
    
    [PlugNPlay setOrderDetails: paymentModel.details];
    PUMTxnParam *txnParam = [self txnParamsForModel:paymentModel];
    [PlugNPlay presentPaymentViewControllerWithTxnParams:txnParam
          onViewController:controller
       withCompletionBlock:^(NSDictionary *paymentResponse, NSError *error, id extraParam) {
        completion(paymentResponse, error, extraParam);
        
        
        /*if (error) {
            [UIUtility toastMessageOnScreen:[error localizedDescription] fromViewController:weakSelf];
        } else {
            NSString *message;
            if ([paymentResponse objectForKey:@"result"] && [[paymentResponse objectForKey:@"result"] isKindOfClass:[NSDictionary class]] ) {
                message = [[paymentResponse objectForKey:@"result"] valueForKey:@"error_Message"];
                if ([message isEqual:[NSNull null]] || [message length] == 0 || [message isEqualToString:@"No Error"]) {
                    message = [[paymentResponse objectForKey:@"result"] valueForKey:@"status"];
                }
            }
            else {
                message = [paymentResponse valueForKey:@"status"];
            }
            [UIUtility toastMessageOnScreen:message fromViewController:weakSelf];
        }*/
    }];
}


- (PUMTxnParam *)txnParamsForModel:(PayUHelperModel *)paymentModel  {
    PUMTxnParam *txnParam = [[PUMTxnParam alloc] init];
    txnParam.amount      = paymentModel.amount;
    txnParam.email       = paymentModel.email;
    txnParam.phone       = paymentModel.phone;
    txnParam.environment = [self enviorenment];
    txnParam.firstname   = paymentModel.customerName;
    txnParam.key         = kPayUMerchantKey;
    txnParam.merchantid  = kPayUMerchantID;
    txnParam.txnID       = paymentModel.txnId;
    txnParam.surl        = kPayUSuccessURL;
    txnParam.furl        = kPayUFailureURL;
    txnParam.productInfo = @"App";
    txnParam.udf1        = @"";
    txnParam.udf2        = @"";
    txnParam.udf3        = @"";
    txnParam.udf4        = @"";
    txnParam.udf5        = @"";
    txnParam.udf6        = @"";
    txnParam.udf7        = @"";
    txnParam.udf8        = @"";
    txnParam.udf9        = @"";
    txnParam.udf10       = @"";
    // txnParam.hashValue = [self getRequestHashForPaymentParams:txnParam];
    
    txnParam.hashValue = paymentModel.requestHash;

    self.txnParams = txnParam;
    
    return txnParam;
}

#pragma mark - Helper Methods
//TODO: get rid of this function for test environemnt
-(NSString*)getRequestHashForPaymentParams:(PUMTxnParam*)txnParam {
    NSString *salt = kPayUMerchantSalt;
    NSString *hashSequence = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",txnParam.key,txnParam.txnID,txnParam.amount,txnParam.productInfo,txnParam.firstname,txnParam.email,txnParam.udf1,txnParam.udf2,txnParam.udf3,txnParam.udf4,txnParam.udf5,txnParam.udf6,txnParam.udf7,txnParam.udf8,txnParam.udf9,txnParam.udf10, salt];
    
    NSString *hash = [[[[[self createSHA512:hashSequence] description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return hash;
}

-(NSString*)getResponseHashForPaymentParams {
    NSString *salt = kPayUMerchantSalt;
    // salt|status||||||udf5|udf4|udf3|udf2|udf1|email|firstname|productinfo|amount|txnid|key
    NSString *hashSequence = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@|%@",salt,@"success",self.txnParams.udf10,self.txnParams.udf9,self.txnParams.udf8,self.txnParams.udf7,self.txnParams.udf6,self.txnParams.udf5,self.txnParams.udf4,self.txnParams.udf3,self.txnParams.udf2,self.txnParams.udf1,self.txnParams.email,self.txnParams.firstname,self.txnParams.productInfo,self.txnParams.amount,self.txnParams.txnID,self.txnParams.key];
    
    NSLog(@"%@", hashSequence);
    NSString *hash = [[[[[self createSHA512:hashSequence] description]stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", hash);
    
    return hash;
}

- (NSString *)createSHA512:(NSString *)source {
    
    const char *cstr = [source cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:source.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    NSString *hash =  [[[output stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];

    return hash;
}

@end


@implementation PayUHelperModel

@end
