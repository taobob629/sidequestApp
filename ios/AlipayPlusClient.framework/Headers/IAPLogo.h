//
//  IAPLogo.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IAPLogo : NSObject <NSCoding>
@property (nonatomic, strong, readonly) NSString *logoName;
@property (nonatomic, strong, readonly) NSString *logoUrl;
@property (nonatomic, strong, readonly) NSString *logoPattern;
@property (nonatomic, strong, readonly) NSString *logoWidth;
@property (nonatomic, strong, readonly) NSString *logoHeight;
@end

NS_ASSUME_NONNULL_END
