//
//  PPOApplePay.h
//  Pay360

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import "PPOUtils.h"
#import "PPOApplePayPaymentMethod.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Apple Pay Model
 */
@interface PPOApplePay : NSObject
{
    
}
/** Payment Data from Apple as Base64 String */
@property (nonatomic, strong) NSString *paymentData;
/** Payment Method details */
@property (nonatomic, strong) PPOApplePayPaymentMethod *applePayPaymentMethod;
/** Apple Pay Token Transaction Identifier from Apple */
@property (nonatomic, strong) NSString *transactionIdentifier;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation:(PPOPaymentType)paymentType;

@end

NS_ASSUME_NONNULL_END
