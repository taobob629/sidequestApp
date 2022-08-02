//
//  PPOCustomField.h
//  Pay360


#import <Foundation/Foundation.h>
#import "PPOConstants.h"

NS_ASSUME_NONNULL_BEGIN
/**
 Custom Field Model, custom data that can be added to a Payment
 */
@interface PPOCustomField : NSObject
{
    
}
/** The name of the property */
@property (nonatomic, copy) NSString *name;

/** The value to be stored */
@property (nonatomic, copy) NSString *value;

/**
 * Convenience method to build dictionary.
 * @param paymentType The type of payment
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation;

@end

NS_ASSUME_NONNULL_END
