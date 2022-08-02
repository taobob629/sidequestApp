//
//  PPOBillingAddress.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPOBillingAddress : NSObject
{
    
}
/** Line 1 of the Customer’s billing address. */
@property (nonatomic, strong) NSString *line1;
/** Line 2 of the Customer’s billing address. */
@property (nonatomic, strong) NSString *line2;
/** Line 3 of the Customer’s billing address.  */
@property (nonatomic, strong) NSString *line3;
/** Line 4 of the Customer’s billing address. */
@property (nonatomic, strong) NSString *line4;
/** City of the Customer’s billing address. */
@property (nonatomic, strong) NSString *city;
/** Region of the Customer’s billing address. */
@property (nonatomic, strong) NSString *region;
/** Postcode of the Customer’s billing address. */
@property (nonatomic, strong) NSString *postcode;
/** The 3 character ISO-3166-1 code for the Customer’s billing address country. */
@property (nonatomic, strong) NSString *countryCode;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation;

@end

NS_ASSUME_NONNULL_END
