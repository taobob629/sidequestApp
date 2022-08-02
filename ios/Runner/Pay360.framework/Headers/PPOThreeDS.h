//
//  PPOThreeDS.h
//  Pay360

#import <Foundation/Foundation.h>
#import "PPOHttpRequestManager.h"
#import "PPOUrlManager.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPOThreeDS : NSObject<WKNavigationDelegate>
{
    
}

/** The delegate client id */
@property (nonatomic, strong) id client;
/** The URL to the ACS server */
@property (nonatomic, strong) NSString* acsUrl;
/** The URL to be posted back to after the cardholder completes 3DS authentication */
@property (nonatomic, strong) NSString* termUrl;
/** Base64 encoded data required for authentication processing. This should be submitted as-is to the ACS */
@property (nonatomic, strong) NSString* pareq;
/** Merchant-defined data which will be returned with the cardholder when they are redirected by the ACS. */
@property (nonatomic, strong) NSString* md;
/** The timeout of the payment session */
@property (nonatomic, strong) NSNumber* sessionTimeout;
/**  */
@property (nonatomic, strong) NSNumber* passiveTimeout;
/** WebView object to be brought to front */
@property (nonatomic) WKWebView* wkWebView;
/**  */
@property (nonatomic, strong) NSString* redirectContent;
/** ThreeDS V2 TransactionID*/
@property (nonatomic, strong) NSString* threeDSServerTransId;
/** ThreeDS V2 Notification URL*/
@property (nonatomic, strong) NSString* notificationUrl;
/**   */
@property (nonatomic, strong) void (^completion)(NSDictionary* result);

@property (nonatomic) BOOL isThreeDSv1;

/** Constructor to initialise class */
-(id)init:(id)client;
/**
 * Setter to set all class properties
 * @param params A dictionary of parameters required to display the 3DS WebView
 */
-(void)set3DSParams:(NSDictionary*)params;
/**
 * Starts the 3DS process, displaying a WebView.
 * @param completion A callback to trigger on completion of the process.
 */
-(void)run3DSProcess:(void(^)(NSDictionary* result))completion;
@end

NS_ASSUME_NONNULL_END
