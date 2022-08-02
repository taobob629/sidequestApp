//
//  PPOPayment.h
//  Pay360

#import <Foundation/Foundation.h>
#import "PPOTransaction.h"
#import "PPOBillingAddress.h"
#import "PPOCard.h"
#import "PPOCredentials.h"
#import "PPOFinancialService.h"
#import "PPOCustomer.h"
#import "PPODeviceInfo.h"
#import "PPOCustomField.h"
#import "PPOThreeDS.h"
#import "PPOApplePay.h"
#import "PassKit/PKPayment.h"
#import "PPOPaymentResponse.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const PPOErrorDomain = @"com.pay360.sdk.payment.public.error.domain";
/**
 Payment class to store payment properties and initiate the start of all flows.
 */
@interface PPOPayment : NSObject
{
}
/** Transaction details  */
@property(nonatomic, strong) PPOTransaction *transaction;
/** Card details */
@property(nonatomic, strong) PPOCard *card;
/** Address details */
@property(nonatomic, strong) PPOBillingAddress *address;
/** Financial Service details */
@property(nonatomic, strong) PPOFinancialService *financialServices;
/** Customer details */
@property(nonatomic, strong) PPOCustomer *customer;
/** Credentials required to make payment */
@property(nonatomic, strong) PPOCredentials *credentials;
/** List of custom properties attached to order  */
@property(nonatomic, strong) NSSet *customFields;
/** Process 3DS secure payments */
@property(nonatomic, strong) PPOThreeDS *threeDSController;
/** The delegate client id */
@property(nonatomic, strong) id client;
/** Apple Pay details */
@property(nonatomic, strong) PPOApplePay *applepay;

@property(nonatomic, strong) NSString *providerId;

/** Constructor to initialise class */
- (id)init:(id)client;
/**
 * Start the guest payment flow
 * @param completion Callback called on success of the payment providing payment details
 * @param failure  Callback called on failure of the payment providing reason of failure
 */
- (BOOL)processGuestPayment:(void (^)(PPOPaymentResponse *result))completion failure:(void (^)(NSError *error))failure;
/**
 * Start the request to store a card flow.
 * @param completion Callback called on success of the payment providing payment details
 * @param failure  Callback called on failure of the payment providing reason of failure
 */
- (BOOL)requestVerify:(void (^)(PPOPaymentResponse *result))completion failure:(void (^)(NSError *error))failure;
/**
 * Start the request to process a payment with card token.
 * @param completion Callback called on success of the payment providing payment details
 * @param failure  Callback called on failure of the payment providing reason of failure
 */
- (BOOL)processTokenPayment:(void (^)(PPOPaymentResponse *result))completion failure:(void (^)(NSError *error))failure;
/**
 * Start the request to process an Apple Pay payment, to be called once recieved authorization from Apple Pay.
 * @param completion Callback called on success of the payment providing payment details
 * @param failure  Callback called on failure of the payment providing reason of failure
 */
- (BOOL)processApplePay:(void (^)(PPOPaymentResponse *result))completion failure:(void (^)(NSError *error))failure;

/**
 * Maps a PPOPayment to an ApplePay payment to be procesed by Apple. This should be used to provided PassKit the Payment details.
 * @param applePaymerchantId Merchant ID provided by Apple.
 * @param supportedNetworks  List of card networks to support.
 * @return A PassKit payment object to be used by Apple Pay
 */
- (PKPaymentRequest *)toPKPaymentRequest:(NSString *)applePaymerchantId supportedNetworks:(NSArray<PKPaymentNetwork> *)supportedNetworks;
/**
 * Setter to attach the Pass Kit Payment
 * @param passKitPayment Pass Kit Payment recieved from the Pass Kit after authorisation
 */
- (void)setNewPassKitPayment:(PKPayment *)passKitPayment;
/**
 * Setter to attach a card token to the payment when making a token payment.
 * @param token Card token of stored card
 */
- (void)setNewCardToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
