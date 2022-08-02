//
//  PPOThreeDSDelegate.h
//  Pay360

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PPOThreeDSDelegate<NSObject>

-(void)threeDSecureController:(id<PPOThreeDSDelegate>)controller acquiredPaRes:(NSString*)paRes;
-(void)threeDSecureControllerUserCancelled:(id<PPOThreeDSDelegate>)controller;
-(void)threeDSecureController:(id<PPOThreeDSDelegate>)controller failedWithError:(NSError*)error;
-(void)threeDSecureControllerSessionTimeoutExpired:(id<PPOThreeDSDelegate>)controller;
-(void)threeDSecureControllerDelayShowTimeoutExpired:(id<PPOThreeDSDelegate>)controller;

@end

NS_ASSUME_NONNULL_END
