//
//  PPOPaymentResponse.h
//  Pay360

#import <Foundation/Foundation.h>
#import "PPOPaymentResponseCard.h"
#import "PPOPaymentResponseStoredMethod.h"

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponseMethod : NSObject
{
    
}
/** Method of the processing */
@property (nonatomic, copy) NSString *methodId;

/** Status of the processing */
@property (assign,getter=registered) BOOL registered;

/** Result of the processing */
@property (nonatomic, strong) PPOPaymentResponseCard *card;

/** Result of the processing */
@property (nonatomic, strong) PPOPaymentResponseStoredMethod *storedMethod;

@end

NS_ASSUME_NONNULL_END
