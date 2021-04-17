#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSSpecifier.h>

//CREDITS FOR THIS CELL TO LACERTOSUS: 
//DISCORD: Bezerk#4824
//GITHUB: LacertosusRepo
//TWITTER: @LacertosusDeus

@interface PSSpecifier (Private)
-(id)performGetter;
-(void)performSetterWithValue:(id)value;
@end

@interface UIView (Private)
-(UIViewController *)_viewControllerForAncestor;
@end

@interface BABLabeledSliderCell : PSSliderTableCell
@end
