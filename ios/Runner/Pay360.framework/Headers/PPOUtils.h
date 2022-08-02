//
//  Header.h
//  Pay360


#ifndef Header_h
#define Header_h

typedef enum {
    PPOEnvironmentTesting,
    PPOEnvironmentProduction
} PPOEnvironment;

typedef enum {
    PPOAuthTypeNone,
    PPOAuthTypeBasic,
    PPOAuthTypeToken
} PPOAuthType;

typedef enum {
    PPOGuestPayment,
    PPOVerifyRequest,
    PPOTokenPayment,
    PPOApplePayRequest,
} PPOPaymentType;

typedef enum {
    ThreeDS,
    No3DS
} PaymentSecureType;

#endif /* Header_h */

