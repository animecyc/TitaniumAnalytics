#import "TiModule.h"
#import "GAI.h"

@interface ComAnimecycAnalyticsModule : TiModule
{
}

- (void)ensureDispatch;
+ (void)debugWithMessage:(NSString*)message;
- (id)getTracker:(id)accountId;
- (id)createTransaction:(id)transactionArgs;
- (id)getDefaultTracker:(id)args;
- (void)setDebug:(id)debug;
- (void)setDispatchInterval:(id)dispatchInterval;
- (void)setTrackUncaughtExceptions:(id)trackUncaughtExceptions;
- (void)setOptOut:(id)optOut;

@end