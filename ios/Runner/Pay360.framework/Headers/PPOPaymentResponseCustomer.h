//
//  PPOPaymentResponse.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponseCustomer : NSObject
{
    
}
/** Reference of the Merchant */
@property (nonatomic, copy) NSString *merchantRef;

@end

NS_ASSUME_NONNULL_END
