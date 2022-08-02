//
//  PPOFinancialService.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Financial Service model
 */
@interface PPOFinancialService : NSObject
{
    
}

/** The Customer’s date of birth. */
@property (nonatomic, copy) NSString *dateOfBirth;
/** The Customer’s surname. */
@property (nonatomic, copy) NSString *surname;
/** The loan account number provided by the merchant, to the Customer. */
@property (nonatomic, copy) NSString *accountNumber;
/** The postal code of the Customer’s billing address  */
@property (nonatomic, copy) NSString *postCode;

/**
 * Convenience method to build dictionary.
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation;

@end

NS_ASSUME_NONNULL_END
