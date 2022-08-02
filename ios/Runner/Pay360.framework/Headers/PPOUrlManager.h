//
//  PPOUrlManager.h
//  Pay360


#import <Foundation/Foundation.h>
#import "PPOUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPOUrlManager : NSObject
{
    
}

+(NSURL*)getPaymentProcessUrl:(PPOEnvironment)environment installationId: (NSString*)installationId;
+(NSURL*)getStoreCardVerifyUrl:(PPOEnvironment)environment installationId: (NSString*)installationId;
+(NSURL*)getResumePaymentUrl:(PPOEnvironment)environment installationId: (NSString*)installationId transactionId: (NSString*)transactionId;
@end

NS_ASSUME_NONNULL_END
