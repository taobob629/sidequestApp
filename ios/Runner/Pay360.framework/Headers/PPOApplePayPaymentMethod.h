//
//  PPOApplePayPaymentMethod.m
//  Pay360


#import <Foundation/Foundation.h>
#import "PPOUtils.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Apple Pay Payment Method Model
 */
@interface PPOApplePayPaymentMethod : NSObject
{
    
}

/** The display name. */
@property (nonatomic, strong) NSString *displayName;
/** The Payment Network used */
@property (nonatomic, strong) NSString *network;
/** Card Type */
@property (nonatomic, strong) NSString *type;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation:(PPOPaymentType)paymentType;

@end

NS_ASSUME_NONNULL_END
