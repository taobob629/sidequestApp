//
//  IAPPaymentSheetEvent.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/19.
//

#import <Foundation/Foundation.h>
#import <AlipayPlusClient/IAPConstant.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPPaymentSheetEvent : NSObject
@property (nonatomic, strong, readonly) IAPPaymentSheetEventName name;
@property (nonatomic, strong, readonly, nullable) NSString *message;
@end

NS_ASSUME_NONNULL_END
