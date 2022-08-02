//
//  PPOHttpRequestmanager.h
//  Pay360

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PPONSData+Base64.h"
#import "PPOUtils.h"
NS_ASSUME_NONNULL_BEGIN

@interface PPOHttpRequestmanager : NSObject
{
    
}

+(NSURLRequest*)requestWithURL:(NSURL*)url
                    withMethod:(NSString*)method
                   withTimeout:(CGFloat)timeout
                      authType:(PPOAuthType)authType
                          auth: (NSDictionary*)authObject
                      withBody:(NSDictionary*)body;

+(NSURLRequest*)requestFormDataWithURL:(NSURL*)url
                    withMethod:(NSString*)method
                   withTimeout:(CGFloat)timeout
                      authType:(PPOAuthType)authType
                          auth: (NSDictionary*)authObject
                      withBody:(NSData*)body;

@end

NS_ASSUME_NONNULL_END
