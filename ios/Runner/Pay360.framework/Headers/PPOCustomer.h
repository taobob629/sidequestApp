//
//  PPOCustomer.h
//  Pay360


#import <Foundation/Foundation.h>
#import "PPOUtils.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Customer model to store all customer related properties to a payment.
 */
@interface PPOCustomer : NSObject
{
    
}
/** Email address for the Customer. */
@property (nonatomic, copy) NSString *email;
/** Date of birth for the Customer.  */
@property (nonatomic, copy) NSString *dateOfBirth;
/** Telephone number for the Customer.  */
@property (nonatomic, copy) NSString *telephone;
/** The merchant's references for the Customer. Required to process a payment using a stored card  */
@property (nonatomic, copy) NSString *merchantRef;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation:(PPOPaymentType)paymentType;

@end

NS_ASSUME_NONNULL_END
