//
//  HighScoresViewController.m
//  DoubleSnake
//
//  Created by Charles on 7/31/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import "HighScoresViewController.h"
#import "BlockAlertView.h"

@interface HighScoresViewController ()

@end

@implementation HighScoresViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.layer.cornerRadius = 5;
    self.table.backgroundColor = [UIColor clearColor];
    //self.table.layer.shouldRasterize = YES;
    //self.table.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSLog(@"Reading scores");
    if ([prefs objectForKey:@"Scores"] == nil ||
        //![[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] isKindOfClass:[NSDictionary class]] ||
        [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"] == nil ||
        //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Single Player"] isKindOfClass:[NSArray class]] ||
        [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"] == nil //||
        //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]] objectForKey:@"Two Player"] isKindOfClass:[NSArray class]]
        ) {
        
        NSLog(@"Initing new scores dictionary");
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] }];
        [prefs setObject:data forKey:@"Scores"];
        [prefs synchronize];
    }
    NSLog(@"Reading times won");
    if ([prefs objectForKey:@"Times Won"] == nil ||
        //![[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] isKindOfClass:[NSDictionary class]] ||
        [[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"] == nil //||
        //![[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"] isKindOfClass:[NSArray class]]
        ) {
        
        NSLog(@"Initing new times won dictionary");
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Times Won" : @[@(0)] }];
        [prefs setObject:data forKey:@"Times Won"];
        [prefs synchronize];
    }
    //NSLog(@"%@",[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]]);
    //NSLog(@"%@",[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"]);
    NSMutableArray *timesWon = [[[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Times Won"]] objectForKey:@"Times Won"] mutableCopy];
    self.timesWonLabel.text = [@"Times Won: " stringByAppendingFormat:@"%i",[timesWon[0] intValue]];
    self.scores = [NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:@"Scores"]];
    
    /*
    NSMutableArray *singlePlayerScores = [self.scores objectForKey:@"Single Player"];
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    if (singlePlayerScores.count >1) [singlePlayerScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    // Initialize a new, empty mutable array 
    NSMutableArray * uniqueSingle = [NSMutableArray array];
    
    for (NSNumber *obj in singlePlayerScores) {
        if (![uniqueSingle containsObject:obj]) {
            if ([obj intValue] > 0) [uniqueSingle addObject:obj];
            if ([obj intValue] ==0 && singlePlayerScores.count == 1) [uniqueSingle addObject:obj];
        }
    }
    
    if (uniqueSingle.count == 0) [uniqueSingle addObject:@0];
    
    NSMutableArray *twoPlayerScores = [self.scores objectForKey:@"Two Player"];
    if (twoPlayerScores.count >1) [twoPlayerScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    // Initialize a new, empty mutable array 
    NSMutableArray * uniqueTwo = [NSMutableArray array];
    
    for (id obj in twoPlayerScores) {
        if (![uniqueTwo containsObject:obj]) {
            if ([obj intValue] > 0) [uniqueTwo addObject:obj];
            if ([obj intValue] ==0 && twoPlayerScores.count == 1) [uniqueTwo addObject:obj];

        }
    }
    if (uniqueTwo.count == 0) [uniqueTwo addObject:@0];
    
    self.scores = [@{ @"Single Player" : uniqueSingle , @"Two Player" : uniqueTwo } mutableCopy];
     */
    
    NSMutableArray *singlePlayerScores = [[self.scores objectForKey:@"Single Player"] mutableCopy];
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    if (singlePlayerScores.count >1) [singlePlayerScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    while (1) {
        if (singlePlayerScores.lastObject && [singlePlayerScores.lastObject intValue]==0) {
            [singlePlayerScores removeLastObject];
            NSLog(@"Found zero");
            
        }
        else break;
    }
        
    if (singlePlayerScores.count == 0) [singlePlayerScores addObject:@0];
    
    NSMutableArray *twoPlayerScores = [[self.scores objectForKey:@"Two Player"] mutableCopy];
    if (twoPlayerScores.count >1) [twoPlayerScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    while (1) {
        if (twoPlayerScores.lastObject && [twoPlayerScores.lastObject intValue]==0) {
            [twoPlayerScores removeLastObject];
            NSLog(@"Found zero");
        }
        else break;
    }
    
    if (twoPlayerScores.count == 0) [twoPlayerScores addObject:@0];
    
    self.scores = [@{ @"Single Player" : singlePlayerScores , @"Two Player" : twoPlayerScores } mutableCopy];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : singlePlayerScores  , @"Two Player" : twoPlayerScores }];
    [prefs setObject:data forKey:@"Scores"];
    [prefs synchronize];

    
    self.backButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backButton.layer.shadowOpacity = 0.5;
    self.backButton.layer.shadowRadius = 5;
    self.backButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.backButton.layer.shouldRasterize = YES;
    self.backButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.tableBack.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tableBack.layer.shadowOpacity = 0.5;
    self.tableBack.layer.shadowRadius = 5;
    self.tableBack.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.tableBack.layer.shouldRasterize = YES;
    self.tableBack.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.titleLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.titleLabel.layer.shadowOpacity = 0.5;
    self.titleLabel.layer.shadowRadius = 5;
    self.titleLabel.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.titleLabel.layer.shouldRasterize = YES;
    self.titleLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    self.resetButton.layer.shadowOpacity = 0.5;
    self.resetButton.layer.shadowRadius = 5;
    self.resetButton.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.resetButton.layer.shouldRasterize = YES;
    self.resetButton.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    self.timesWonLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.timesWonLabel.layer.shadowOpacity = 0.5;
    self.timesWonLabel.layer.shadowRadius = 5;
    self.timesWonLabel.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.timesWonLabel.layer.shouldRasterize = YES;
    self.timesWonLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.scores count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.scores allKeys] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *singleOrDoublePlayer = [self tableView:tableView titleForHeaderInSection:section];
    return [[self.scores valueForKey:singleOrDoublePlayer] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString *singleOrDoublePlayer = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    NSString *score = [[[self.scores valueForKey:singleOrDoublePlayer] objectAtIndex:indexPath.row] stringValue];
    
    cell.textLabel.text = score;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] }];
        [prefs setObject:data forKey:@"Scores"];
        self.scores = [@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] } mutableCopy];
        [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:@{ @"Times Won" : @[@(0)] }] forKey:@"Times Won"];
        [prefs synchronize];
        self.timesWonLabel.text = @"Times Won: 0";
        [self.table reloadData];
        [self.table setNeedsLayout];
        [self.table setNeedsDisplay];
        [self.table layoutSubviews];
    }
}

- (IBAction)backPressed:(UIButton *)sender {
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setResetButton:nil];
    [self setTable:nil];
    [self setTableBack:nil];
    [self setTimesWonLabel:nil];
    [super viewDidUnload];
    [self setBackButton:nil];
    [self setTitleLabel:nil];
	self.scores = nil;
}

- (IBAction)resetPressed:(UIButton *)sender {
    //[DoubleSnakeAlertView setBackgroundColor:[UIColor colorWithRed:(71/255.0) green:(77/255.0) blue:(87/255.0) alpha:0.8] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.5]];
    /*[[[CustomAlertView alloc] initWithTitle:@"Reset All Scores"
                                message:@"Are you sure you wish to reset all high score rankings? This cannot be undone."
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Reset", nil] show];*/
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Reset All Scores?" message:@"Are you sure you wish to reset all high score rankings? This cannot be undone."];
    [alert setCancelButtonWithTitle:@"Cancel" block:nil];
    [alert setDestructiveButtonWithTitle:@"Reset" block:^{NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] }];
        [prefs setObject:data forKey:@"Scores"];
        self.scores = [@{ @"Single Player" : @[@(0)]  , @"Two Player" : @[@(0)] } mutableCopy];
        [prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:@{ @"Times Won" : @[@(0)] }] forKey:@"Times Won"];
        [prefs synchronize];
        self.timesWonLabel.text = @"Times Won: 0";
        [self.table reloadData];
        [self.table setNeedsLayout];
        [self.table setNeedsDisplay];
        [self.table layoutSubviews];}];
    [alert show];

}
@end
