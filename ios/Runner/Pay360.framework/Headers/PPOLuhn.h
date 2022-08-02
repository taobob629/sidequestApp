//
//  PPOLuhn.m
//  Pay360
//  https://github.com/maxkramer/ObjectiveLuhn

#import <Foundation/Foundation.h>
#import "PPOLuhn.h"

/**
 Enum of Card Types
 */
typedef NS_ENUM(NSInteger, OLCreditCardType) {
    OLCreditCardTypeAmex,
    OLCreditCardTypeVisa,
    OLCreditCardTypeMastercard,
    OLCreditCardTypeDiscover,
    OLCreditCardTypeDinersClub,
    OLCreditCardTypeJCB,
    OLCreditCardTypeUnsupported,
    OLCreditCardTypeInvalid
};

/**
 Luhn class to allow Luhn checks on card numbers
 */
@interface PPOLuhn : NSObject

/**
 * Get the card type from card number.
 *
 * @param string Card Number
 * @return Card Type
 */
+ (OLCreditCardType) typeFromString:(NSString *) string;
/**
 * Validate the card number against card
 *
 * @param string Card Number
 * @param type Expected Card Type
 * @return YES if card type matches.
 */
+ (BOOL) validateString:(NSString *) string forType:(OLCreditCardType) type;
/**
 * Validate the card number
 *
 * @param string Card Number
 * @return YES if card type is valid.
 */
+ (BOOL) validateString:(NSString *) string;

@end

@interface NSString (PPOLuhn)

- (BOOL) isValidCreditCardNumber;
- (OLCreditCardType) creditCardType;

@end
