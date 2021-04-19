#line 1 "Tweak.xm"
#include "Tweak.h"

UIColor *lightLowColor;
UIColor *lightFullColor;
UIColor *darkLowColor;
UIColor *darkFullColor;
HBPreferences *preferences;
double myAlpha;
int weakColored;
bool onlyBattery;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class _UIStatusBarImageView; @class BCBatteryDeviceController; @class _UIBatteryView; @class _UIStatusBarStringView; @class _UIStatusBarSignalView; @class _UIStatusBar; @class UIUserInterfaceStyleArbiter; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$BCBatteryDeviceController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("BCBatteryDeviceController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$UIUserInterfaceStyleArbiter(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("UIUserInterfaceStyleArbiter"); } return _klass; }
#line 12 "Tweak.xm"
static void (*_logos_orig$universal$UIUserInterfaceStyleArbiter$toggleCurrentStyle)(_LOGOS_SELF_TYPE_NORMAL UIUserInterfaceStyleArbiter* _LOGOS_SELF_CONST, SEL); static void _logos_method$universal$UIUserInterfaceStyleArbiter$toggleCurrentStyle(_LOGOS_SELF_TYPE_NORMAL UIUserInterfaceStyleArbiter* _LOGOS_SELF_CONST, SEL); static UIColor * _logos_method$universal$BCBatteryDeviceController$colorFromCharge(_LOGOS_SELF_TYPE_NORMAL BCBatteryDeviceController* _LOGOS_SELF_CONST, SEL); 


static void _logos_method$universal$UIUserInterfaceStyleArbiter$toggleCurrentStyle(_LOGOS_SELF_TYPE_NORMAL UIUserInterfaceStyleArbiter* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$universal$UIUserInterfaceStyleArbiter$toggleCurrentStyle(self, _cmd);
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"BattiBarStatusBarColorUpdate" object:nil];
}





static UIColor * _logos_method$universal$BCBatteryDeviceController$colorFromCharge(_LOGOS_SELF_TYPE_NORMAL BCBatteryDeviceController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	UIColor *color = [UIColor greenColor];
	for (BCBatteryDevice *device in self.connectedDevices) {
		if ([device isInternal]) {
			long long styleLong = [[_logos_static_class_lookup$UIUserInterfaceStyleArbiter() sharedInstance] currentStyle];
			
			bool isDarkMode = styleLong == 2;
			const CGFloat* lowComponents = isDarkMode ? CGColorGetComponents(darkLowColor.CGColor) : CGColorGetComponents(lightLowColor.CGColor);
			const CGFloat* highComponents = isDarkMode ? CGColorGetComponents(darkFullColor.CGColor) : CGColorGetComponents(lightFullColor.CGColor);
			double percent = 1.00 - ((double)device.percentCharge / 100.00);
			color = [UIColor colorWithRed: (highComponents[0] + percent * lowComponents[0]) green: (highComponents[1] - percent * lowComponents[1]) blue: (highComponents[2] + percent * lowComponents[2]) alpha: myAlpha];
		}
	}
	return color;
}





static void (*_logos_orig$batteryHooks$_UIBatteryView$setFillColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$batteryHooks$_UIBatteryView$setFillColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$batteryHooks$_UIBatteryView$setBodyColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$batteryHooks$_UIBatteryView$setBodyColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$batteryHooks$_UIBatteryView$setPinColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$batteryHooks$_UIBatteryView$setPinColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$batteryHooks$_UIBatteryView$setBoltColor$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$batteryHooks$_UIBatteryView$setBoltColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$batteryHooks$_UIBatteryView$setBodyColorAlpha$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$batteryHooks$_UIBatteryView$setBodyColorAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, double); static void (*_logos_orig$batteryHooks$_UIBatteryView$setPinColorAlpha$)(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, double); static void _logos_method$batteryHooks$_UIBatteryView$setPinColorAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST, SEL, double); 



static void _logos_method$batteryHooks$_UIBatteryView$setFillColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	if ([color isEqual:[UIColor clearColor]]) { 
		_logos_orig$batteryHooks$_UIBatteryView$setFillColor$(self, _cmd, color);
	} else {
		UIColor *maybe = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
		_logos_orig$batteryHooks$_UIBatteryView$setFillColor$(self, _cmd, maybe);
	}
}

static void _logos_method$batteryHooks$_UIBatteryView$setBodyColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	if ([color isEqual:[UIColor clearColor]]) { 
		_logos_orig$batteryHooks$_UIBatteryView$setBodyColor$(self, _cmd, color);
	} else {
		UIColor *maybe = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
		_logos_orig$batteryHooks$_UIBatteryView$setBodyColor$(self, _cmd, maybe);
	}
}

static void _logos_method$batteryHooks$_UIBatteryView$setPinColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	if ([color isEqual:[UIColor clearColor]]) { 
		_logos_orig$batteryHooks$_UIBatteryView$setPinColor$(self, _cmd, color);
	} else {
		UIColor *maybe = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
		_logos_orig$batteryHooks$_UIBatteryView$setPinColor$(self, _cmd, maybe);
	}
}

static void _logos_method$batteryHooks$_UIBatteryView$setBoltColor$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	if ([color isEqual:[UIColor clearColor]]) { 
		_logos_orig$batteryHooks$_UIBatteryView$setBoltColor$(self, _cmd, color);
	} else {
		UIColor *maybe = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
		_logos_orig$batteryHooks$_UIBatteryView$setBoltColor$(self, _cmd, maybe);
	}
}


static void _logos_method$batteryHooks$_UIBatteryView$setBodyColorAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1) {
	_logos_orig$batteryHooks$_UIBatteryView$setBodyColorAlpha$(self, _cmd, myAlpha);
}

static void _logos_method$batteryHooks$_UIBatteryView$setPinColorAlpha$(_LOGOS_SELF_TYPE_NORMAL _UIBatteryView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, double arg1) {
	_logos_orig$batteryHooks$_UIBatteryView$setPinColorAlpha$(self, _cmd, myAlpha);
}





static void (*_logos_orig$barHooks$_UIStatusBarImageView$tintColorDidChange)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST, SEL); static void _logos_method$barHooks$_UIStatusBarImageView$tintColorDidChange(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$barHooks$_UIStatusBarSignalView$setActiveColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarSignalView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$barHooks$_UIStatusBarSignalView$setActiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarSignalView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$barHooks$_UIStatusBarSignalView$setInactiveColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarSignalView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$barHooks$_UIStatusBarSignalView$setInactiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarSignalView* _LOGOS_SELF_CONST, SEL, UIColor *); static void (*_logos_orig$barHooks$_UIStatusBarStringView$setTextColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$barHooks$_UIStatusBarStringView$setTextColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$barHooks$_UIStatusBar$updateColorForMe(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST, SEL); static _UIStatusBar* (*_logos_orig$barHooks$_UIStatusBar$initWithStyle$)(_LOGOS_SELF_TYPE_INIT _UIStatusBar*, SEL, long long) _LOGOS_RETURN_RETAINED; static _UIStatusBar* _logos_method$barHooks$_UIStatusBar$initWithStyle$(_LOGOS_SELF_TYPE_INIT _UIStatusBar*, SEL, long long) _LOGOS_RETURN_RETAINED; static void (*_logos_orig$barHooks$_UIStatusBar$setForegroundColor$)(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST, SEL, UIColor *); static void _logos_method$barHooks$_UIStatusBar$setForegroundColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST, SEL, UIColor *); 



static void _logos_method$barHooks$_UIStatusBarImageView$tintColorDidChange(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarImageView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	_logos_orig$barHooks$_UIStatusBarImageView$tintColorDidChange(self, _cmd);
	UIColor *neededColor = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];

	if (self.tintColor != neededColor) {
		self.tintColor = neededColor;
	}
}





static void _logos_method$barHooks$_UIStatusBarSignalView$setActiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarSignalView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	if ([color isEqual:[UIColor clearColor]]) { 
		_logos_orig$barHooks$_UIStatusBarSignalView$setActiveColor$(self, _cmd, color);
	} else {
		UIColor *maybe = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
		_logos_orig$barHooks$_UIStatusBarSignalView$setActiveColor$(self, _cmd, maybe);
	}
}

static void _logos_method$barHooks$_UIStatusBarSignalView$setInactiveColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarSignalView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	if ([color isEqual:[UIColor clearColor]]) { 
		_logos_orig$barHooks$_UIStatusBarSignalView$setInactiveColor$(self, _cmd, color);
	} else {
		if (weakColored == 1) {
			UIColor *tmpColor = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
			_logos_orig$barHooks$_UIStatusBarSignalView$setInactiveColor$(self, _cmd, [tmpColor colorWithAlphaComponent:0.3]);
		} else {
			_logos_orig$barHooks$_UIStatusBarSignalView$setInactiveColor$(self, _cmd, [UIColor clearColor]);
		}
	}
}





static void _logos_method$barHooks$_UIStatusBarStringView$setTextColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBarStringView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * color) {
	UIColor *maybe = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
	_logos_orig$barHooks$_UIStatusBarStringView$setTextColor$(self, _cmd, maybe);
}



 

 
static void _logos_method$barHooks$_UIStatusBar$updateColorForMe(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	[self setForegroundColor:[UIColor purpleColor]];
}

static _UIStatusBar* _logos_method$barHooks$_UIStatusBar$initWithStyle$(_LOGOS_SELF_TYPE_INIT _UIStatusBar* __unused self, SEL __unused _cmd, long long arg1) _LOGOS_RETURN_RETAINED {
	[[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(updateColorForMe) name:@"BattiBarStatusBarColorUpdate"  object:nil];
	return _logos_orig$barHooks$_UIStatusBar$initWithStyle$(self, _cmd, arg1);
}

static void _logos_method$barHooks$_UIStatusBar$setForegroundColor$(_LOGOS_SELF_TYPE_NORMAL _UIStatusBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIColor * arg1) {
	UIColor *myColor = [[_logos_static_class_lookup$BCBatteryDeviceController() sharedInstance] colorFromCharge];
	_logos_orig$barHooks$_UIStatusBar$setForegroundColor$(self, _cmd, myColor);
}







static __attribute__((constructor)) void _logosLocalCtor_7ee34f56(int __unused argc, char __unused **argv, char __unused **envp) {
	if (!preferences) { 
		preferences = [[HBPreferences alloc] initWithIdentifier:@"com.halliehax.battibar.prefs"];
	}
	if ([preferences boolForKey:@"isEnabled" default:YES]) { 
		lightLowColor = [UIColor colorWithHexString:[preferences objectForKey:@"lightLowColor" default:@"#EF3B36"]];
		lightFullColor = [UIColor colorWithHexString:[preferences objectForKey:@"lightFullColor" default:@"#000000"]];
		darkLowColor = [UIColor colorWithHexString:[preferences objectForKey:@"darkLowColor" default:@"#EF3B36"]];
		darkFullColor = [UIColor colorWithHexString:[preferences objectForKey:@"darkFullColor" default:@"#FFFFFF"]];
		myAlpha = (double)[preferences integerForKey:@"alphaInt" default:100] / (double)100.0;
		weakColored = (int)[preferences integerForKey:@"clearOrLightColor" default:1];
		onlyBattery = [preferences boolForKey:@"onlyBattery" default:NO];

		
		




		{Class _logos_class$universal$UIUserInterfaceStyleArbiter = objc_getClass("UIUserInterfaceStyleArbiter"); { MSHookMessageEx(_logos_class$universal$UIUserInterfaceStyleArbiter, @selector(toggleCurrentStyle), (IMP)&_logos_method$universal$UIUserInterfaceStyleArbiter$toggleCurrentStyle, (IMP*)&_logos_orig$universal$UIUserInterfaceStyleArbiter$toggleCurrentStyle);}Class _logos_class$universal$BCBatteryDeviceController = objc_getClass("BCBatteryDeviceController"); { char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIColor *), strlen(@encode(UIColor *))); i += strlen(@encode(UIColor *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$universal$BCBatteryDeviceController, @selector(colorFromCharge), (IMP)&_logos_method$universal$BCBatteryDeviceController$colorFromCharge, _typeEncoding); }}
		{Class _logos_class$batteryHooks$_UIBatteryView = objc_getClass("_UIBatteryView"); { MSHookMessageEx(_logos_class$batteryHooks$_UIBatteryView, @selector(setFillColor:), (IMP)&_logos_method$batteryHooks$_UIBatteryView$setFillColor$, (IMP*)&_logos_orig$batteryHooks$_UIBatteryView$setFillColor$);}{ MSHookMessageEx(_logos_class$batteryHooks$_UIBatteryView, @selector(setBodyColor:), (IMP)&_logos_method$batteryHooks$_UIBatteryView$setBodyColor$, (IMP*)&_logos_orig$batteryHooks$_UIBatteryView$setBodyColor$);}{ MSHookMessageEx(_logos_class$batteryHooks$_UIBatteryView, @selector(setPinColor:), (IMP)&_logos_method$batteryHooks$_UIBatteryView$setPinColor$, (IMP*)&_logos_orig$batteryHooks$_UIBatteryView$setPinColor$);}{ MSHookMessageEx(_logos_class$batteryHooks$_UIBatteryView, @selector(setBoltColor:), (IMP)&_logos_method$batteryHooks$_UIBatteryView$setBoltColor$, (IMP*)&_logos_orig$batteryHooks$_UIBatteryView$setBoltColor$);}{ MSHookMessageEx(_logos_class$batteryHooks$_UIBatteryView, @selector(setBodyColorAlpha:), (IMP)&_logos_method$batteryHooks$_UIBatteryView$setBodyColorAlpha$, (IMP*)&_logos_orig$batteryHooks$_UIBatteryView$setBodyColorAlpha$);}{ MSHookMessageEx(_logos_class$batteryHooks$_UIBatteryView, @selector(setPinColorAlpha:), (IMP)&_logos_method$batteryHooks$_UIBatteryView$setPinColorAlpha$, (IMP*)&_logos_orig$batteryHooks$_UIBatteryView$setPinColorAlpha$);}}
		if (!onlyBattery) {
			{Class _logos_class$barHooks$_UIStatusBarImageView = objc_getClass("_UIStatusBarImageView"); { MSHookMessageEx(_logos_class$barHooks$_UIStatusBarImageView, @selector(tintColorDidChange), (IMP)&_logos_method$barHooks$_UIStatusBarImageView$tintColorDidChange, (IMP*)&_logos_orig$barHooks$_UIStatusBarImageView$tintColorDidChange);}Class _logos_class$barHooks$_UIStatusBarSignalView = objc_getClass("_UIStatusBarSignalView"); { MSHookMessageEx(_logos_class$barHooks$_UIStatusBarSignalView, @selector(setActiveColor:), (IMP)&_logos_method$barHooks$_UIStatusBarSignalView$setActiveColor$, (IMP*)&_logos_orig$barHooks$_UIStatusBarSignalView$setActiveColor$);}{ MSHookMessageEx(_logos_class$barHooks$_UIStatusBarSignalView, @selector(setInactiveColor:), (IMP)&_logos_method$barHooks$_UIStatusBarSignalView$setInactiveColor$, (IMP*)&_logos_orig$barHooks$_UIStatusBarSignalView$setInactiveColor$);}Class _logos_class$barHooks$_UIStatusBarStringView = objc_getClass("_UIStatusBarStringView"); { MSHookMessageEx(_logos_class$barHooks$_UIStatusBarStringView, @selector(setTextColor:), (IMP)&_logos_method$barHooks$_UIStatusBarStringView$setTextColor$, (IMP*)&_logos_orig$barHooks$_UIStatusBarStringView$setTextColor$);}Class _logos_class$barHooks$_UIStatusBar = objc_getClass("_UIStatusBar"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$barHooks$_UIStatusBar, @selector(updateColorForMe), (IMP)&_logos_method$barHooks$_UIStatusBar$updateColorForMe, _typeEncoding); }{ MSHookMessageEx(_logos_class$barHooks$_UIStatusBar, @selector(initWithStyle:), (IMP)&_logos_method$barHooks$_UIStatusBar$initWithStyle$, (IMP*)&_logos_orig$barHooks$_UIStatusBar$initWithStyle$);}{ MSHookMessageEx(_logos_class$barHooks$_UIStatusBar, @selector(setForegroundColor:), (IMP)&_logos_method$barHooks$_UIStatusBar$setForegroundColor$, (IMP*)&_logos_orig$barHooks$_UIStatusBar$setForegroundColor$);}}
		}
	}
}
