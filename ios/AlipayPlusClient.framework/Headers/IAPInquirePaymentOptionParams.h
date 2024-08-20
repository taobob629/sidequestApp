//
//  IAPInquirePaymentOptionParams.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPInquirePaymentOptionParams : NSObject
@property (nonatomic, copy) NSString *paymentCurrency;
@property (nonatomic, copy, nullable) NSString *userRegion;
@property (nonatomic, copy, nullable) NSString *logoPattern;
@end

NS_ASSUME_NONNULL_END
