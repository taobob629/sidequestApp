//
//  PPOPaymentResponseStoredMethod.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponseStoredMethod : NSObject
{
    
}
/** The token for the card */
@property (nonatomic, copy) NSString *token;

@end

NS_ASSUME_NONNULL_END
