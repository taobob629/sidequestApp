//
//  PPOCard.h
//  Pay360


#import <Foundation/Foundation.h>
#import "PPOUtils.h"

NS_ASSUME_NONNULL_BEGIN
/**
 Card model
 */
@interface PPOCard : NSObject
{
    
}
/** The card number. */
@property (nonatomic, strong) NSString *pan;
/** The Card Security Code (CSC, CV2, CVV). */
@property (nonatomic, strong) NSString *cvv;
/** The expiry date for the card if the expiry date of originally stored card has expired. Provide as MMYY. */
@property (nonatomic, strong) NSString *expiry;
/** The name printed on the card. */
@property (nonatomic, strong) NSString *cardHolderName;
/** The card token */
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *lastFour;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation:(PPOPaymentType)paymentType;

@end

NS_ASSUME_NONNULL_END
