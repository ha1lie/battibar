#include "BABRootListController.h"

@implementation BABRootListController

static HBPreferences *preferences;

- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
        appearanceSettings.tintColor = [UIColor colorWithRed:(85.0/255.0) green:(159.0/255.0) blue:(0.0/255.0) alpha:1.0];
		appearanceSettings.tableViewCellSeparatorColor = [UIColor clearColor];
        // appearanceSettings.tableViewBackgroundColor = [UIColor colorWithWhite:242.f / 255.f alpha:1];
        self.hb_appearanceSettings = appearanceSettings;

		preferences = [[HBPreferences alloc] initWithIdentifier:@"com.halliehax.battibar.prefs"];
    }

    return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {
	dlopen("/usr/lib/libcolorpicker.dylib", RTLD_LAZY);
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStyleDone target:self action:@selector(respring)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:(85.0/255.0) green:(159.0/255.0) blue:(0.0/255.0) alpha:1.0];

	if (!self.navigationItem.titleView) {
		BABAnimatedTitleView *titleView = [[BABAnimatedTitleView alloc] initWithTitle:@"BattiBar" minimumScrollOffsetRequired:-150];
		self.navigationItem.titleView = titleView;
	}
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	//Send scroll offset updates to view
	if([self.navigationItem.titleView respondsToSelector:@selector(adjustLabelPositionToScrollOffset:)]) {
		[(BABAnimatedTitleView *)self.navigationItem.titleView adjustLabelPositionToScrollOffset:scrollView.contentOffset.y];
	}
}

-(void)respring {
  [HBRespringController respring];
}

@end
