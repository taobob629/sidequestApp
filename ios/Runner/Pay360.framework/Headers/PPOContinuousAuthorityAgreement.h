//
//  POContinuousAuthorityAgreement.h
//  Pay360
//
//  Created by Vaibhav Agrawal on 22/09/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPOContinuousAuthorityAgreement : NSObject
{
    
}

/** The Frequency. */
@property (nonatomic, strong) NSString *minFrequency;

/** The Expiry. */
@property (nonatomic, strong) NSString *expiry;

/** The No Of Instalments. */
@property (nonatomic, strong) NSString *numberOfInstalments;

/**
 * Convenience method to build dictionary.
 * @return A simple dictionary containing all classes properties.
 */
-(NSDictionary*)jsonObjectRepresentation;

@end

NS_ASSUME_NONNULL_END
