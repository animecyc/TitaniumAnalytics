#import "TiProxy.h"
#import "GAI.h"

@interface ComAnimecycAnalyticsTransactionProxy : TiProxy
{
}

@property (nonatomic, readonly, retain) GAITransaction* transaction;

- (id)initWithTransactionId:(NSString*)transactionId transactionOptions:(NSDictionary*)options;
- (int64_t)toMicros:(double)value;
- (void)setTax:(id)tax;
- (void)setShipping:(id)shipping;
- (void)setRevenue:(id)revenue;
- (void)addItem:(id)itemArgs;

@end