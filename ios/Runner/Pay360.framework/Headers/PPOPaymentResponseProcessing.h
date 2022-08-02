//
//  PPOPaymentResponse.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponseProcessing : NSObject
{
    
}
/** Status of the processing */
@property (nonatomic, copy) NSString *status;

/** Result of the processing */
@property (nonatomic, copy) NSString *result;

@end

NS_ASSUME_NONNULL_END
