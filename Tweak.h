#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// #import <RemoteLog.h>
#import <Cephei/HBPreferences.h>
#include "UIColor+BattiBar.h"

@interface UIUserInterfaceStyleArbiter: NSObject
+(id)sharedInstance;
-(long long)currentStyle;
-(void)toggleCurrentStyle;
@end

@interface _UIStatusBar: UIView
-(id)initWithStyle:(long long)arg1;
-(void)setForegroundColor:(UIColor *)arg1;
@end

@interface _UIStatusBarImageView: UIImageView
@end

@interface _UIBatteryView: UIView {
	UIColor *fillColor;
	UIColor *bodyColor;
	double chargePercent;
}
@property (nonatomic, copy) UIColor *bodyColor;
@property (nonatomic, copy) UIColor *fillColor;
-(void)setFillColor:(UIColor *)color;
-(void)setBodyColor:(UIColor *)color;
-(void)setPinColor:(UIColor *)color;
-(void)setSaverModeActive:(BOOL)arg1;
-(void)setBodyColorAlpha:(double)arg1;
-(void)setPinColorAlpha:(double)arg1;
-(void)setBodyLayer:(CALayer *)arg1;
-(void)setBoltMaskLayer:(CALayer *)arg1;
-(void)setBoltColor:(UIColor *)arg1;
-(void)setPinLayer:(CALayer *)arg1;
-(void)setFillLayer:(CALayer *)arg1;
-(void)setBoltLayer:(CALayer *)arg1;
@end

@interface _UIStatusBarSignalView : UIView {
	UIColor *activeColor;
	UIColor *inactiveColor;
}
@property (nonatomic, copy) UIColor *activeColor;
@property (nonatomic, copy) UIColor *inactiveColor;
-(void)setActiveColor:(UIColor *)arg1;
-(void)setInactiveColor:(UIColor *)arg1;
@end

@interface _UIStatusBarStringView : UILabel
-(void)setTextColor:(UIColor *)arg1;
@end

//Interfaces for battery controller!
@interface BCBatteryDeviceController {
	NSArray *connectedDevices;
}
@property (nonatomic, copy, readonly) NSArray *connectedDevices;
+(id)sharedInstance;
-(UIColor *)colorFromCharge;
@end

@interface BCBatteryDevice : NSObject {
	long long _percentCharge;
	BOOL _internal;
}
@property (assign, nonatomic) long long percentCharge;
@property (assign, getter=isInternal, nonatomic) BOOL internal;
-(BOOL)isInternal;
@end