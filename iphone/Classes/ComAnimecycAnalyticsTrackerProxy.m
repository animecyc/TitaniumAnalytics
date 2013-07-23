#import "ComAnimecycAnalyticsModule.h"
#import "ComAnimecycAnalyticsTrackerProxy.h"
#import "ComAnimecycAnalyticsTransactionProxy.h"
#import "TiUtils.h"

@implementation ComAnimecycAnalyticsTrackerProxy

@synthesize tracker;

#pragma mark Cleanup

- (void)dealloc
{
    RELEASE_TO_NIL(tracker);

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithAccountId:(NSString*)accountId
{
    if (self = [super init]) {
        if (![NSThread isMainThread]) {
            TiThreadPerformOnMainThread(^{
                tracker = [[GAI sharedInstance] trackerWithTrackingId:accountId];
            }, NO);
        }
    }

    return self;
}

- (id)initWithDefault
{
    if (self = [super init]) {
        if (![NSThread isMainThread]) {
            TiThreadPerformOnMainThread(^{
                tracker = [[GAI sharedInstance] defaultTracker];
            }, NO);
        }
    }

    return self;
}

#pragma mark Public APIs

- (void)trackScreen:(id)screen
{
    ENSURE_UI_THREAD_1_ARG(screen);
    ENSURE_SINGLE_ARG_OR_NIL(screen, NSString);

    [tracker sendView:screen];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Queueing screen with name: %@", screen]];
}

- (void)trackEvent:(id)eventArgs
{
    ENSURE_UI_THREAD_1_ARG(eventArgs);
    ENSURE_SINGLE_ARG(eventArgs, NSDictionary);

    NSString* category;
    NSString* action;
    NSString* label;
    NSNumber* value;

    ENSURE_ARG_OR_NIL_FOR_KEY(category, eventArgs, @"category", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(action, eventArgs, @"action", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(label, eventArgs, @"label", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(value, eventArgs, @"value", NSNumber);

    [tracker sendEventWithCategory:category
                        withAction:action
                         withLabel:label
                         withValue:value];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Queueing event with arguments:\n%@", eventArgs]];
}

- (void)trackException:(id)exceptionArgs
{
    ENSURE_UI_THREAD_1_ARG(exceptionArgs);

    NSString* description = [TiUtils stringValue:[exceptionArgs objectAtIndex:0]];
    BOOL fatal = [TiUtils boolValue:[exceptionArgs objectAtIndex:1] def:NO];

    [tracker sendException:fatal
           withDescription:description];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Queueing exception with arguments:\n%@", exceptionArgs]];
}

- (void)trackSocial:(id)socialArgs
{
    ENSURE_UI_THREAD_1_ARG(socialArgs);
    ENSURE_SINGLE_ARG(socialArgs, NSDictionary);

    NSString* social;
    NSString* action;
    NSString* target;

    ENSURE_ARG_OR_NIL_FOR_KEY(social, socialArgs, @"social", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(action, socialArgs, @"action", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(target, socialArgs, @"target", NSString);

    [tracker sendSocial:social
             withAction:action
             withTarget:target];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Queueing social with arguments:\n%@", socialArgs]];
}

- (void)trackTime:(id)timeArgs
{
    ENSURE_UI_THREAD_1_ARG(timeArgs);
    ENSURE_SINGLE_ARG(timeArgs, NSDictionary);

    NSString* category;
    NSString* name;
    NSString* label;
    NSNumber* interval;

    ENSURE_ARG_OR_NIL_FOR_KEY(category, timeArgs, @"category", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(interval, timeArgs, @"interval", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(name, timeArgs, @"name", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(label, timeArgs, @"label", NSString);

    [tracker sendTimingWithCategory:category
                          withValue:[interval doubleValue]
                           withName:name
                          withLabel:label];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Queueing timing with arguments:\n%@", timeArgs]];
}

- (void)trackTransaction:(id)transaction
{
    ENSURE_UI_THREAD_1_ARG(transaction);
    ENSURE_SINGLE_ARG(transaction, ComAnimecycAnalyticsTransactionProxy);

    [tracker sendTransaction:[transaction transaction]];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Queueing transaction for item: %@", [[transaction transaction] transactionId]]];
}

- (void)setAnonymize:(id)anonymize
{
    ENSURE_UI_THREAD_1_ARG(anonymize);
    ENSURE_SINGLE_ARG(anonymize, NSNumber);

    [tracker setAnonymize:[anonymize boolValue]];
    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Anonymous sessions has been %@", [anonymize boolValue] ? @"enabled" : @"disabled"]];
}

- (void)setUseHttps:(id)useHttps
{
    ENSURE_UI_THREAD_1_ARG(useHttps);
    ENSURE_SINGLE_ARG(useHttps, NSNumber);

    [tracker setAnonymize:[useHttps boolValue]];
    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Use of HTTPS has been %@", [useHttps boolValue] ? @"enabled" : @"disabled"]];
}

- (void)setSampleRate:(id)sampleRate
{
    ENSURE_UI_THREAD_1_ARG(sampleRate);
    ENSURE_SINGLE_ARG(sampleRate, NSNumber);

    [tracker setSampleRate:[sampleRate doubleValue]];
    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting sample rate to: %@", sampleRate]];
}

- (void)setSessionTimeout:(id)sessionTimeout
{
    ENSURE_UI_THREAD_1_ARG(sessionTimeout);
    ENSURE_SINGLE_ARG(sessionTimeout, NSNumber);

    [tracker setSessionTimeout:[sessionTimeout doubleValue]];
    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting session timeout to: %@", sessionTimeout]];
}

- (void)setCampaignUrl:(id)campaignUrl
{
    ENSURE_UI_THREAD_1_ARG(campaignUrl);
    ENSURE_SINGLE_ARG(campaignUrl, NSString);

    [tracker setCampaignUrl:campaignUrl];
    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting campaign URL to: %@", campaignUrl]];
}

- (void)setReferrerUrl:(id)referrerUrl
{
    ENSURE_UI_THREAD_1_ARG(referrerUrl);
    ENSURE_SINGLE_ARG(referrerUrl, NSString);

    [tracker setReferrerUrl:referrerUrl];
    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting referrer url to: %@", referrerUrl]];
}

@end