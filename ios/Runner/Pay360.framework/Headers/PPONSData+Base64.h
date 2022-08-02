//
//  PPONSData+Base64.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Base64)
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;
- (NSString *) base64EncodingWithLineLength:(unsigned int) lineLength;

@end

NS_ASSUME_NONNULL_END
