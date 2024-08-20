//
//  AlipayPlusClientAPI.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/12.
//

#import <Foundation/Foundation.h>
#import <AlipayPlusClient/IAPConfiguration.h>
#import <AlipayPlusClient/IAPInquirePaymentOptionParams.h>
#import <AlipayPlusClient/IAPPaymentOption.h>
#import <AlipayPlusClient/IAPPaymentSheetEvent.h>

NS_ASSUME_NONNULL_BEGIN

// In this header, you should import all the public headers of your framework using statements like #import <AlipayPlusClient/PublicHeader.h>
@protocol IAPLogServiceProtocol <NSObject>
@required
- (void)logWithName:(NSString *)name parameter:(nullable NSDictionary *)parameter;
@end

@protocol AlipaySDKServiceProtocol <NSObject>
- (void)payOrder:(NSString *)orderStr
      fromScheme:(NSString *)schemeStr
        callback:(void (^)(NSDictionary *resultDic))completionBlock;

- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(void (^)(NSDictionary *resultDic))completionBlock;
@end


@interface AlipayPlusClient : NSObject
@property (nonatomic, strong) IAPConfiguration *configuration;
@property (nonatomic, strong, nullable) id<IAPLogServiceProtocol> logService;
@property (nonatomic, strong, nullable) id<AlipaySDKServiceProtocol> alipaySDKSService;

+ (instancetype)shared;

- (void)inquirePaymentOptionWithParams:(IAPInquirePaymentOptionParams *)params
                     completionHandler:(void(^)(IAPPaymentOption * _Nullable paymentOption, NSError * _Nullable error))completionHandler;

- (void)showPaymentSheet:(NSString *)paymentData
                callback:(void(^)(IAPPaymentSheetEvent * _Nonnull sheetEvent))callback;


- (BOOL)canProcessOrderWithPaymentResult:(NSURL *)resultUrl;

- (void)processOrderWithPaymentResult:(NSURL *)resultUrl;

@end


NS_ASSUME_NONNULL_END
