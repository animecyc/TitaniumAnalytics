#import "ComAnimecycAnalyticsModule.h"
#import "ComAnimecycAnalyticsTrackerProxy.h"
#import "ComAnimecycAnalyticsTransactionProxy.h"
#import "TiBase.h"
#import "TiHost.h"

static BOOL debugging = NO;

@implementation ComAnimecycAnalyticsModule

#pragma mark Internal

- (id)moduleGUID
{
	return @"16C71364-6048-4C8C-A7B6-5B89322F1FF9";
}

- (NSString*)moduleId
{
	return @"com.animecyc.analytics";
}

#pragma mark Lifecycle

- (void)startup
{
	[super startup];
    [self ensureDispatch];
}

- (void)shutdown:(id)sender
{
    [self ensureDispatch];
	[super shutdown:sender];
}

#pragma mark Cleanup

- (void)dealloc
{
	[super dealloc];
}

- (void)ensureDispatch
{
    if (![NSThread isMainThread])
    {
        TiThreadPerformOnMainThread(^{
            [[GAI sharedInstance] dispatch];
        }, NO);
    }
}

#pragma mark Debug

+ (void)debugWithMessage:(NSString*)message
{
    if (debugging)
    {
        NSLog(@"[Google Analytics] ~ %@", message);
    }
}

#pragma mark Internal Memory Management

- (void)didReceiveMemoryWarning:(NSNotification*)notification
{
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Public APIs

- (id)getTracker:(id)accountId
{
    ENSURE_SINGLE_ARG(accountId, NSString);

    NSString* debugMessage = @"Getting tracker with ID: ";

    [ComAnimecycAnalyticsModule debugWithMessage:[debugMessage stringByAppendingString:accountId]];

    return [[[ComAnimecycAnalyticsTrackerProxy alloc] initWithAccountId:accountId] autorelease];
}

- (id)createTransaction:(id)transactionArgs
{
    NSString* transactionId;
    NSDictionary* transactionOptions;

    ENSURE_ARG_OR_NIL_AT_INDEX(transactionId, transactionArgs, 0, NSString);
    ENSURE_ARG_OR_NIL_AT_INDEX(transactionOptions, transactionArgs, 1, NSDictionary);

    return [[[ComAnimecycAnalyticsTransactionProxy alloc] initWithTransactionId:transactionId
                                                    transactionOptions:transactionOptions] autorelease];
}

- (id)getDefaultTracker:(id)args
{
    [ComAnimecycAnalyticsModule debugWithMessage:@"Getting default tracker."];

    return [[[ComAnimecycAnalyticsTrackerProxy alloc] initWithDefault] autorelease];
}

- (void)setDebug:(id)debug
{
    ENSURE_UI_THREAD_1_ARG(debug);
    ENSURE_SINGLE_ARG(debug, NSNumber);

	[GAI sharedInstance].debug = debugging = [debug boolValue];

    NSString* debugMessage = @"Debugging has been ";

    [ComAnimecycAnalyticsModule debugWithMessage:[debugMessage stringByAppendingString:debugging ? @"enabled" : @"disabled"]];
}

- (void)setDispatchInterval:(id)dispatchInterval
{
    ENSURE_UI_THREAD_1_ARG(dispatchInterval);
    ENSURE_SINGLE_ARG(dispatchInterval, NSNumber);

	[GAI sharedInstance].dispatchInterval = [dispatchInterval doubleValue];

    NSString* debugMessage = @"Dispatch interval has been set to: ";

    [ComAnimecycAnalyticsModule debugWithMessage:[debugMessage stringByAppendingString:[dispatchInterval stringValue]]];
}

- (void)setTrackUncaughtExceptions:(id)trackUncaughtExceptions
{
    ENSURE_UI_THREAD_1_ARG(trackUncaughtExceptions);
    ENSURE_SINGLE_ARG(trackUncaughtExceptions, NSNumber);

    [GAI sharedInstance].trackUncaughtExceptions = [trackUncaughtExceptions boolValue];

    NSString* debugMessage = @"Tracking uncaught exceptions has been ";

    [ComAnimecycAnalyticsModule debugWithMessage:[debugMessage stringByAppendingString:debugging ? @"enabled" : @"disabled"]];
}

- (void)setOptOut:(id)optOut
{
    ENSURE_UI_THREAD_1_ARG(optOut);
    ENSURE_SINGLE_ARG(optOut, NSNumber);

    [GAI sharedInstance].optOut = [optOut boolValue];

    NSString* debugMessage = @"Global opt-out has been ";

    [ComAnimecycAnalyticsModule debugWithMessage:[debugMessage stringByAppendingString:debugging ? @"enabled" : @"disabled"]];
}

@end
