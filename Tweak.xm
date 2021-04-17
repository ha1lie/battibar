#include "Tweak.h"

UIColor *lightLowColor;
UIColor *lightFullColor;
UIColor *darkLowColor;
UIColor *darkFullColor;
HBPreferences *preferences;
double myAlpha;

%group enableMe

%hook UIUserInterfaceStyleArbiter
-(void)toggleCurrentStyle {
	%orig;
	//SEND NOTIF FOR THE REST OF THE STATUS BAR TO UPDATE ITS COLORS
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BattiBarStatusBarColorUpdate" object:nil];
}
%end

%hook _UIStatusBarImageView

-(void)tintColorDidChange {
	%orig;
	UIColor *neededColor = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];

	if (self.tintColor != neededColor) {
		self.tintColor = neededColor;
	}
}

%end

%hook BCBatteryDeviceController

%new
-(UIColor *)colorFromCharge {
	UIColor *color = [UIColor greenColor];
	for (BCBatteryDevice *device in self.connectedDevices) {
		if ([device isInternal]) {
			long long styleLong = [[%c(UIUserInterfaceStyleArbiter) sharedInstance] currentStyle];
			//DARK MODE == 2
			bool isDarkMode = styleLong == 2;
			const CGFloat* lowComponents = isDarkMode ? CGColorGetComponents(darkLowColor.CGColor) : CGColorGetComponents(lightLowColor.CGColor);
			const CGFloat* highComponents = isDarkMode ? CGColorGetComponents(darkFullColor.CGColor) : CGColorGetComponents(lightFullColor.CGColor);
			double percent = 1.00 - ((double)device.percentCharge / 100.00);
			color = [UIColor colorWithRed: (highComponents[0] + percent * lowComponents[0]) green: (highComponents[1] - percent * lowComponents[1]) blue: (highComponents[2] + percent * lowComponents[2]) alpha: myAlpha];
		}
	}
	return color;
}

%end



%hook _UIBatteryView

-(void)setFillColor:(UIColor *)color {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

-(void)setBodyColor:(UIColor *)color {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

-(void)setPinColor:(UIColor *)color {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

-(void)setSaverModeActive:(BOOL)arg1 {
	%orig;
	[self setFillColor:[UIColor blueColor]]; //Just change it to some garbage color
}

-(void)setBodyColorAlpha:(double)arg1 {
	%orig(myAlpha);
}

-(void)setPinColorAlpha:(double)arg1 {
	%orig(myAlpha);
}

-(void)setBodyLayer:(CALayer *)arg1 {
	CALayer *layer = arg1;
	layer.opacity = myAlpha;
	%orig(layer);
}

-(void)setBoltMaskLayer:(CALayer *)arg1 {
	CALayer *layer = arg1;
	layer.opacity = myAlpha;
	%orig(layer);
}

-(void)setBoltColor:(UIColor *)arg1 {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

-(void)setPinLayer:(CALayer *)arg1 {
	CALayer *layer = arg1;
	layer.opacity = myAlpha;
	%orig(layer);
}

-(void)setFillLayer:(CALayer *)arg1 {
	CALayer *layer = arg1;
	layer.opacity = myAlpha;
	%orig(layer);
}
-(void)setBoltLayer:(CALayer *)arg1 {
	CALayer *layer = arg1;
	layer.opacity = myAlpha;
	%orig(layer);
}

%end



%hook _UIStatusBarSignalView

-(void)setActiveColor:(UIColor *)color {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

-(void)setInactiveColor:(UIColor *)color {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

%end

%hook _UIStatusBarStringView

-(void)setTextColor:(UIColor *)color {
	UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(maybe);
}

%end

%hook _UIStatusBar 

%new 
-(void)updateColorForMe {
	[self setForegroundColor:[UIColor purpleColor]];
}

-(id)initWithStyle:(long long)arg1 {
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateColorForMe) name:@"BattiBarStatusBarColorUpdate"  object:nil];
	return %orig(arg1);
}

-(void)setForegroundColor:(UIColor *)arg1 {
	UIColor *myColor = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
	%orig(myColor);
}

%end

%end


%ctor {
	if (!preferences) { //Initiate preferences instead of making it a compile-time constant
		preferences = [[HBPreferences alloc] initWithIdentifier:@"com.halliehax.battibar.prefs"];
	}
	if ([preferences boolForKey:@"isEnabled" default:YES]) { //If is enabled, set the global gradient colors
		lightLowColor = [UIColor colorWithHexString:[preferences objectForKey:@"lightLowColor" default:@"#EF3B36"]];
		lightFullColor = [UIColor colorWithHexString:[preferences objectForKey:@"lightFullColor" default:@"#000000"]];
		darkLowColor = [UIColor colorWithHexString:[preferences objectForKey:@"darkLowColor" default:@"#EF3B36"]];
		darkFullColor = [UIColor colorWithHexString:[preferences objectForKey:@"darkFullColor" default:@"#FFFFFF"]];
		myAlpha = (double)[preferences integerForKey:@"alphaInt" default:100] / (double)100.0;
		%init(enableMe); //Initialize the hooks once the colors are set to prevent them from being nil
	}
}