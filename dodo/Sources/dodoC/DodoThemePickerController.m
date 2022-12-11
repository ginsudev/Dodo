//
//  DodoThemePickerController.m
//  
//
//  Created by Noah Little on 11/3/2022.
//

#import "include/dodo.h"

@implementation DodoThemePickerController

- (id)init {
    if (self = [super init]) {
        _prefsPlist = @"/User/Library/Preferences/com.ginsu.dodo.plist";
        _themeDir = [[GSUtilities sharedInstance] correctedFilePathFromPathWithRootPrefix:@":root:Library/Application Support/Dodo/Themes/"];
        _themes = [self themeListFromDir:_themeDir];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds
                                              style:UITableViewStyleInsetGrouped];
    [_tableView registerClass:[DodoThemeCell class] forCellReuseIdentifier:@"Cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = YES;
    _tableView.allowsMultipleSelection = NO;
    [self.view addSubview:_tableView];
}

- (NSMutableArray *)themeListFromDir:(NSString *)path {
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (NSString *theme in [fm contentsOfDirectoryAtPath:path error:nil]) {
        [arr addObject:theme];
    }
    
    return arr;
}

- (NSString *)title {
    return @"Select Theme";
}

- (void)setCellDataFromPath:(NSString *)path forCell:(DodoThemeCell *)cell {
    NSPropertyListFormat propertyListFormat = NSPropertyListXMLFormat_v1_0;
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/info.plist", path]];
    
    NSData *plistXML = [[NSData alloc] initWithContentsOfURL:fileURL];
    
    if (plistXML == nil) {
        NSLog(@"[Dodo]: unable to create data object from plist url");
        return;
    }
    
    NSError *error;
    
    NSMutableDictionary *dict = [NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&propertyListFormat error:&error];
    
    if (error != nil) {
        NSLog(@"[Dodo]: %@", error.description);
        return;
    }

    if ([dict objectForKey:@"subtitle"] != nil) {
        [cell.subtitle setText:[dict objectForKey:@"subtitle"]];
    }

    if ([dict objectForKey:@"identifier"] != nil) {
        [cell setIdentifier:[dict objectForKey:@"identifier"]];
    } else {
        NSString *themeName = [[path componentsSeparatedByString:@"/"] lastObject];
        [cell setIdentifier:themeName];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DodoThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *path = [NSString stringWithFormat:@"%@%@", _themeDir, [_themes objectAtIndex:indexPath.row]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.title setText:[NSString stringWithFormat:@"%@", [_themes objectAtIndex:indexPath.row]]];
    [self setCellDataFromPath:path forCell:cell];
    
    if ([cell.identifier isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"Dodo_ThemeID"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (DodoThemeCell *cell in tableView.visibleCells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    DodoThemeCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    [[NSUserDefaults standardUserDefaults] setValue:selectedCell.identifier forKey:@"Dodo_ThemeID"];
    
    [self save:selectedCell.title.text];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *highlightedCell = [tableView cellForRowAtIndexPath:indexPath];
    [highlightedCell setHighlighted:NO animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"\nCustom themes can be placed in the %@ directory.", _themeDir];
}

- (void)save:(NSString *)string {
    NSPropertyListFormat propertyListFormat = NSPropertyListXMLFormat_v1_0;
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:_prefsPlist];
    
    NSData *plistXML = [[NSData alloc] initWithContentsOfURL:fileURL];
    
    if (plistXML == nil) {
        NSLog(@"[Dodo]: unable to create data object from plist url");
        return;
    }
    
    NSError *error;
    
    NSMutableDictionary *prefs = [NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&propertyListFormat error:&error];
    
    if (error != nil) {
        prefs = [NSMutableDictionary dictionary];
    }
    
    [prefs setValue:string forKey:@"themeName"];
    [prefs writeToFile:_prefsPlist atomically:YES];
}

@end
