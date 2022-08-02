//
//  PPOTransaction.h
//  Pay360

#import <Foundation/Foundation.h>
#import "PPOUtils.h"
#import "PPOContinuousAuthorityAgreement.h"
NS_ASSUME_NONNULL_BEGIN
/**
 Transaction model
 */
@interface PPOTransaction : NSObject
{
    
}
/**  */
@property (nonatomic, strong) NSString* transactionId;
/** The currency of your Customer’s transaction. Use the 3 character ISO-4217 code. */
@property (nonatomic, strong) NSString* currency;
/** The amount of your Customer’s transaction. */
@property (nonatomic, strong) NSDecimalNumber* amount;
/** The description of the transaction. */
@property (nonatomic, strong) NSString* transactionDescription;
/** Your reference for the transaction. Max length: 255. It’s recommended that you keep this unique. */
@property (nonatomic, strong) NSString* merchantRef;
/** Payment id recurring */
@property (nonatomic, strong) NSString* isRecurring;
/** Payment is deferred */
@property (nonatomic, strong) NSString* isDeferred;
/** ContinuousAuthorityAgreement  */
@property(nonatomic, strong) PPOContinuousAuthorityAgreement *continuousAuthority;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation:(PPOPaymentType)paymentType;

@end

NS_ASSUME_NONNULL_END
