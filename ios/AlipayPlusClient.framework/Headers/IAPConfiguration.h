//
//  IAPConfiguration.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/11.
//

#import <UIKit/UIKit.h>
#import <AlipayPlusClient/IAPConstant.h>


NS_ASSUME_NONNULL_BEGIN

@interface IAPConfiguration : NSObject
//The unique ID that is assigned by the ACQP to identify a merchant.
//Note: The value of this parameter must be the same as the one that is specified when calling the pay API.
@property (nonatomic, copy) NSString *merchantId;

//The unique ID that is assigned by Alipay+ to identify an ACQP.
@property (nonatomic, copy) NSString *acquirerId;

//The language that is preferred by the user. The value of the parameter consists of a language code following
//the ISO-639 standard and a country code following the ISO-3166 standard. The codes are connected by an underscore. For example,
//en_US.The default value is "en_US";
@property (nonatomic, copy, nullable) NSString *language;

//The type of environment where the SDK is installed. The value of this parameter affects the gateway address of the requests that are initiated from the SDK.
//Valid values:
//PROD: indicates the production environment.
//SANDBOX: indicates the sandbox environment.
//Default value: PROD
@property (nonatomic, copy, nullable) IAPEnv envType;

//The fromScheme is used by the callback your APP after the payment is completed using Alipay.
//Note: The value of this parameter must be set to your app scheme when your app is likely to pay using Alipay.
@property (nonatomic, copy, nullable) NSString *fromScheme;

@end

NS_ASSUME_NONNULL_END
