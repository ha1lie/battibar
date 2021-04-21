#include "Tweak.h"

//Universal variables reset by respring
UIColor *lightLowColor;
UIColor *lightFullColor;
UIColor *darkLowColor;
UIColor *darkFullColor;
HBPreferences *preferences;
double myAlpha;
int weakColored;
bool onlyBattery;

%group universal

%hook UIUserInterfaceStyleArbiter
-(void)toggleCurrentStyle {
	%orig;
	//SEND NOTIF FOR THE REST OF THE STATUS BAR TO UPDATE ITS COLORS
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BattiBarStatusBarColorUpdate" object:nil];
}
%end

%hook BCBatteryDeviceController

%new
-(UIColor *)colorFromCharge { //Use this framework to get the color as it has a shared instance and can find charge percentages
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

%end

%group batteryHooks

%hook _UIBatteryView

-(void)setFillColor:(UIColor *)color {
	if ([color isEqual:[UIColor clearColor]]) { //Checks if the original color was clear... if it is, Snowboard is likely trying to hide the indicator
		%orig(color);
	} else {
		UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
		%orig(maybe);
	}
}

-(void)setBodyColor:(UIColor *)color {
	if ([color isEqual:[UIColor clearColor]]) { //Checks if the original color was clear... if it is, Snowboard is likely trying to hide the indicator
		%orig(color);
	} else {
		UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
		%orig(maybe);
	}
}

-(void)setPinColor:(UIColor *)color {
	if ([color isEqual:[UIColor clearColor]]) { //Checks if the original color was clear... if it is, Snowboard is likely trying to hide the indicator
		%orig(color);
	} else {
		UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
		%orig(maybe);
	}
}

-(void)setBoltColor:(UIColor *)color {
	if ([color isEqual:[UIColor clearColor]]) { //Checks if the original color was clear... if it is, Snowboard is likely trying to hide the indicator
		%orig(color);
	} else {
		UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
		%orig(maybe);
	}
}

//Handle the alpha controllers
-(void)setBodyColorAlpha:(double)arg1 {
	%orig(myAlpha);
}

-(void)setPinColorAlpha:(double)arg1 {
	%orig(myAlpha);
}

%end

%end

%group barHooks

%hook _UIStatusBarImageView

-(void)tintColorDidChange {
	%orig;
	UIColor *neededColor = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];

	if (self.tintColor != neededColor) {
		self.tintColor = neededColor;
	}
}

%end

%hook _UIStatusBarSignalView

-(void)setActiveColor:(UIColor *)color {
	if ([color isEqual:[UIColor clearColor]]) { //Checks if the original color was clear... if it is, Snowboard is likely trying to hide the indicator
		%orig(color);
	} else {
		UIColor *maybe = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
		%orig(maybe);
	}
}

-(void)setInactiveColor:(UIColor *)color {
	if ([color isEqual:[UIColor clearColor]]) { //Checks if the original color was clear... if it is, Snowboard is likely trying to hide the indicator
		%orig(color);
	} else {
		if (weakColored == 1) {
			UIColor *tmpColor = [[%c(BCBatteryDeviceController) sharedInstance] colorFromCharge];
			%orig([tmpColor colorWithAlphaComponent:0.3]);
		} else {
			%orig([UIColor clearColor]);
		}
	}
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
		weakColored = (int)[preferences integerForKey:@"clearOrLightColor" default:1];
		onlyBattery = [preferences boolForKey:@"onlyBattery" default:NO];

		%init(universal);
		%init(batteryHooks);
		if (!onlyBattery) {
			%init(barHooks);
		}
	}
}