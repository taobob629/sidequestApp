//
//  IAPPaymentOption.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/15.
//

#import <Foundation/Foundation.h>
#import <AlipayPlusClient/IAPLogo.h>

NS_ASSUME_NONNULL_BEGIN
@interface IAPPaymentOption : NSObject <NSCoding>
@property (nonatomic, assign, readonly) BOOL enabled;
@property (nonatomic, strong, readonly, nullable) NSArray<IAPLogo *> *logos;
@property (nonatomic, strong, readonly, nullable) NSString *brandName;
@property (nonatomic, strong, readonly, nullable) NSString *disableReason;
@property (nonatomic, strong, readonly) NSString *paymentMethodType;
@property (nonatomic, strong, readonly, nullable) NSArray<NSString *> *promoNames;

// currency is a unused var when sdk version >= 2.1.0
- (nullable instancetype)initWithJSONDictionary:(NSDictionary *)json currency:(NSString *)currency;
- (nullable instancetype)initWithJSONDictionary:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
