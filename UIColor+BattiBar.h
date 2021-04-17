#include <UIKit/UIKit.h>
@interface UIColor (BattiBar)

//THANKS TO THIS ANSWER FOR THIS CODE, I DID NOT HAVE THE MENTAL CAPACITY TO BUILD THIS FAMEWORK
//https://stackoverflow.com/a/7180905 

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

@end
