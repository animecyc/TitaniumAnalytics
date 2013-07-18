#import "ComAnimecycAnalyticsModule.h"
#import "TiProxy.h"
#import "GAI.h"

@interface ComAnimecycAnalyticsTrackerProxy : TiProxy
{
}

@property (nonatomic, readonly) id<GAITracker> tracker;

- (id)initWithAccountId:(NSString*)accountId;
- (id)initWithDefault;
- (void)trackScreen:(id)screen;
- (void)trackEvent:(id)eventArgs;
- (void)trackException:(id)exceptionArgs;
- (void)trackSocial:(id)socialArgs;
- (void)trackTime:(id)timeArgs;
- (void)setAnonymize:(id)anonymize;
- (void)setUseHttps:(id)useHttps;
- (void)setSampleRate:(id)sampleRate;
- (void)setSessionTimeout:(id)sessionTimeout;
- (void)setCampaignUrl:(id)campaignUrl;
- (void)setReferrerUrl:(id)referrerUrl;

@end