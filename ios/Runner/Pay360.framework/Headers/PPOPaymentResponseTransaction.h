//
//  PPOPaymentResponse.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponseTransaction : NSObject
{
    
}
/** Amount of transaction */
@property (nonatomic, copy) NSString *amount;

/** Id of transaction  */
@property (nonatomic, copy) NSString *transactionId;

/** Type of transaction  */
@property (nonatomic, copy) NSString *type;

/** Date and Time of transaction  */
@property (nonatomic, copy) NSString *transactionDateTime;

@end

NS_ASSUME_NONNULL_END
