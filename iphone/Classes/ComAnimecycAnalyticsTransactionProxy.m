#import "ComAnimecycAnalyticsModule.h"
#import "ComAnimecycAnalyticsTransactionProxy.h"
#import "TiUtils.h"

@implementation ComAnimecycAnalyticsTransactionProxy

#pragma mark Cleanup

- (void)dealloc
{
    RELEASE_TO_NIL(_transaction);

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithTransactionId:(NSString*)transactionId transactionOptions:(NSDictionary*)options
{
    if (self = [super init])
    {
       if (![NSThread isMainThread]) {
           TiThreadPerformOnMainThread(^{
               NSString* affiliation;

               ENSURE_ARG_OR_NIL_FOR_KEY(affiliation, options, @"affiliation", NSString);

               _transaction = [[GAITransaction transactionWithId:transactionId
                                                     withAffiliation:affiliation] retain];

               NSNumber* tax;
               NSNumber* shipping;
               NSNumber* revenue;

               ENSURE_ARG_OR_NIL_FOR_KEY(tax, options, @"tax", NSNumber);
               ENSURE_ARG_OR_NIL_FOR_KEY(shipping, options, @"shipping", NSNumber);
               ENSURE_ARG_OR_NIL_FOR_KEY(revenue, options, @"revenue", NSNumber);

               [self setTax:tax];
               [self setShipping:shipping];
               [self setRevenue:revenue];
           }, NO);
       }
    }

    return self;
}

#pragma mark Utility

- (int64_t)toMicros:(double)value
{
    return (int64_t) (value * 1000000);
}

#pragma mark Public APIs

- (void)setTax:(id)tax
{
    ENSURE_SINGLE_ARG(tax, NSNumber);

    self.transaction.taxMicros = [self toMicros:[tax doubleValue]];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting transaction tax to: %@", tax]];
}

- (void)setShipping:(id)shipping
{
    ENSURE_SINGLE_ARG(shipping, NSNumber);

    self.transaction.shippingMicros = [self toMicros:[shipping doubleValue]];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting transaction shipping to: %@", shipping]];
}

- (void)setRevenue:(id)revenue
{
    ENSURE_SINGLE_ARG(revenue, NSNumber);

    self.transaction.revenueMicros = [self toMicros:[revenue doubleValue]];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Setting transaction revenue to: %@", revenue]];
}

- (void)addItem:(id)itemArgs
{
    ENSURE_SINGLE_ARG(itemArgs, NSDictionary);

    NSString* sku;
    NSString* name;
    NSString* category;
    NSNumber* price;
    NSNumber* quantity;

    ENSURE_ARG_OR_NIL_FOR_KEY(sku, itemArgs, @"sku", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(name, itemArgs, @"name", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(category, itemArgs, @"category", NSString);
    ENSURE_ARG_OR_NIL_FOR_KEY(price, itemArgs, @"price", NSNumber);
    ENSURE_ARG_OR_NIL_FOR_KEY(quantity, itemArgs, @"quantity", NSNumber);

    [self.transaction addItemWithCode:sku
                                 name:name
                             category:category
                          priceMicros:[self toMicros:[price doubleValue]]
                             quantity:quantity];

    [ComAnimecycAnalyticsModule debugWithMessage:[NSString stringWithFormat:@"Adding item to transaction with arguments:\n%@", itemArgs]];
}

@end