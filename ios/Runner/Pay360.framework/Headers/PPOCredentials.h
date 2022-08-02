//
//  PPOAuthorization.h
//  Pay360


#import <Foundation/Foundation.h>
#import "PPOUtils.h"
NS_ASSUME_NONNULL_BEGIN

/**
 Credentials model
 */
@interface PPOCredentials : NSObject
{
    
}
/** The API environment to use. */
@property (nonatomic, readwrite) PPOEnvironment environment;
/** The uniquie install identifier. */
@property (nonatomic, strong) NSString *installationId;
/** The Bearer token recieved from the Pay360 authentication */
@property (nonatomic, strong) NSString *clientToken;

/**
 * Constructor
 * @param clientToken Bearer JWT provided by Pay360 authentication.
 * @param installationId The uniquie install identifier.
 */
-(id)init:(NSString*)clientToken
    installationId: (NSString*)installationId;

/**
 * Constructor with environment
 * @param clientToken Bearer JWT provided by Pay360 authentication.
 * @param installationId The uniquie install identifier.
 * @param environment The API environment to use.
 */
-(id)initWithEnvironment:(NSString*)clientToken
    installationId: (NSString*)installationId
    environment: (PPOEnvironment)environment;
@end

NS_ASSUME_NONNULL_END
