#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import <libgscommon/libgscommon.h>
#import <libgscommon/libgsutils.h>

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface PSListController (Private)
- (void)_returnKeyPressed:(id)arg1;
@end

@interface PSSpecifier (Private)
-(void)performSetterWithValue:(id)value;
-(id)performGetter;
@end

@interface PSTableCell (Private)
+ (CGFloat)defaultCellHeight;
@end

@interface DodoThemeCell : UITableViewCell
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subtitle;
@end

@interface DodoThemePickerController : PSViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *prefsPlist;
@property (nonatomic, strong) NSString *themeDir;
@property (nonatomic, strong) NSMutableArray *themes;
@end

