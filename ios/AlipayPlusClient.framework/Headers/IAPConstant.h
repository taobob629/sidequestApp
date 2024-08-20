//
//  IAPConstant.h
//  AlipayPlusClient
//
//  Created by assuner on 2022/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define IAPAlipayPlusClientVersionString @"2.1.4"

#pragma mark - env
typedef NSString *IAPEnv;
extern IAPEnv const kIAPEnvPROD;
extern IAPEnv const kIAPEnvSANDBOX;

#pragma mark - error
extern NSString * const IAPErrorDomain;
extern NSInteger const IAPErrorParamIllegal;
extern NSInteger const IAPErrorInvalidNetwork;
extern NSInteger const IAPErrorSystemError;


#pragma mark - SheetEvent
typedef NSString *IAPPaymentSheetEventName;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventDidSelectWalletAndPay;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventThrowException;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventUserDidCancel;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventDidShow;

extern IAPPaymentSheetEventName const IAPPaymentSheetEventPaymentSuccess;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventPaymentFailed;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventPaymentCanceled;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventPaymentException;
extern IAPPaymentSheetEventName const IAPPaymentSheetEventPaymentProcessing;

#pragma mark - Notification
extern NSString * const IAPPosterDidCloseSheetViewNotification;
NS_ASSUME_NONNULL_END
