//
//  PPOError.h
//  Pay360


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
NSString *const PPOPaymentErrorDomain = @"com.pay360.sdk.payment.public.error.domain";
NSString *const PPOLocalValidationErrorDomain = @"com.pay360.sdk.local.validation.public.error.domain";
NSString *const PPOPrivateErrorDomain = @"com.pay360.sdk.payment.private.error.domain";

typedef enum {
    PPOPaymentErrorNotInitialised,
    
    ///Represents an unexpected error.
    PPOPaymentErrorUnexpected,
    
    ///An invalid parameter was supplied in your payment.
    PPOPaymentValidationError,
    
    ///The supplied bearer token has expired.
    PPOPaymentErrorClientTokenExpired,
    
    ///The supplied bearer token is invalid.
    PPOPaymentErrorClientTokenInvalid,
    
    ///The supplied token does not have sufficient permissions to access the specified feature.
    PPOPaymentErrorUnauthorisedRequest,
    
    ///The transaction was successfully submitted but did not complete three D secure validation.
    PPOPaymentErrorThreeDSecureTransactionProcessingFailed,
    
    ///An internal server error occurred at Pay360.
    PPOPaymentErrorServerFailure,
    
    ///The payment session timed out. This is the timeout that is passed into the payment manager.
    PPOPaymentErrorMasterSessionTimedOut,
    
    ///User cancelled 3D Secure.
    PPOPaymentErrorUserCancelledThreeDSecure,
    
    ///The payment is currently in flight.
    PPOPaymentErrorPaymentProcessing,
    
    ///The transaction was declined.
    PPOPaymentErrorTransactionDeclined,
    
    ///The presented API token was not valid the wrong type of authentication was used.
    PPOPaymentErrorAuthenticationFailed,
    
    ///The transaction or operation was not found.
    PPOPaymentErrorPaymentNotFound,
    
    ///A payment currently occupies the payment manager. Only one payment allowed per unit time.
    PPOPaymentErrorPaymentManagerOccupied
    
} PPOPaymentError;

typedef enum {
    
    ///Error not initialised yet.
    PPOLocalValidationErrorNotInitialised,
    
    ///A client token has not been provided.
    PPOLocalValidationErrorClientTokenInvalid,
    
    ///Pan card invalid.
    PPOLocalValidationErrorCardPanInvalid,
    
    ///CVV card security code invalid.
    PPOLocalValidationErrorCVVInvalid,
    
    ///The date of the expirty for the current card has expired.
    PPOLocalValidationErrorCardExpiryDateExpired,
    
    ///Card expiry date is invalid.
    PPOLocalValidationErrorCardExpiryDateInvalid,
    
    ///Specified currency is invalid.
    PPOLocalValidationErrorCurrencyInvalid,
    
    ///The specified amount is invalid.
    PPOLocalValidationErrorPaymentAmountInvalid,
    
    ///The provided installation ID is invalid.
    PPOLocalValidationErrorInstallationIDInvalid,
    
    ///The base URL configured within the payment manager is invalid.
    PPOLocalValidationErrorSuppliedBaseURLInvalid,
    
    ///Credentials have not been set in the payment manager.
    PPOLocalValidationErrorCredentialsNotFound,
    
} PPOLocalValidationError;

typedef NS_ENUM(NSInteger, PPOPrivateError) {
    
    PPOPrivateErrorNotIntitialised = -1,
    
    PPOPrivateErrorBadRequest = 0,
        
    PPOPrivateErrorPaymentSuspendedForThreeDSecure,
    
    PPOPrivateErrorPaymentSuspendedForClientRedirect,
        
    PPOPrivateErrorProcessingThreeDSecure,
    
    PPOPrivateErrorThreeDSecureTimedOut,
    
};

@interface PPOError : NSObject

+(NSError*)parsePay360ReasonCode:(NSInteger)code withMessage:(NSString*)message;
+(NSError*)buildErrorForPrivateErrorCode:(PPOPrivateError)code withMessage:(NSString*)message;
+(NSError*)buildErrorForPaymentErrorCode:(PPOPaymentError)code withMessage:(NSString*)message;
+(NSError*)buildErrorForValidationErrorCode:(PPOLocalValidationError)code;
+(NSError*)buildCustomerFacingErrorFromError:(NSError*)error;
+(BOOL)isSafeToRetryPaymentWithError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
