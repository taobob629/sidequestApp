//
//  PPOPaymentResponse.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponseCard : NSObject
{
    
}
/** Scheme of card used */
@property (nonatomic, copy) NSString *cardScheme;

/** Type of card used */
@property (nonatomic, copy) NSString *cardType;

/** Expiry Date */
@property (nonatomic, copy) NSString *expiryDate;

/** The lastFour value associated to a token. Only returned by some gateways */
@property (nonatomic, copy) NSString *lastFour;

@end

NS_ASSUME_NONNULL_END
