//
//  PPOPaymentResponse.h
//  Pay360

#import <Foundation/Foundation.h>
#import "PPOPaymentResponseProcessing.h"
#import "PPOPaymentResponseTransaction.h"
#import "PPOPaymentResponseMethod.h"
#import "PPOPaymentResponseCustomer.h"

NS_ASSUME_NONNULL_BEGIN

/**
Payment Response from Pay360 Process  API
 */
@interface PPOPaymentResponse : NSObject
{
    
}

@property (nonatomic, strong) PPOPaymentResponseProcessing *processing;

@property (nonatomic, strong) PPOPaymentResponseTransaction *transaction;

@property (nonatomic, strong) PPOPaymentResponseMethod *paymentMethod;

@property (nonatomic, strong) PPOPaymentResponseCustomer *customer;

@end

NS_ASSUME_NONNULL_END
