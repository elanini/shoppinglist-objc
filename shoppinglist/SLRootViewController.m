//
//  SLRootViewController.m
//  shoppinglist
//
//  Created by Eric Lanini on 3/5/16.
//  Copyright © 2016 Eric Lanini. All rights reserved.
//

#import "SLRootViewController.h"
#import "SLTableViewController.h"

@interface SLRootViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property NSArray *vcs;
@property SLTableViewController *vc1;
@property SLTableViewController *vc2;
@end

@implementation SLRootViewController
- (IBAction)addButton:(UIBarButtonItem *)sender {
    NSLog(@"active vc = %ld", (long)self.segControl.selectedSegmentIndex);
    [self.vcs[self.segControl.selectedSegmentIndex] performSelector:@selector(myRightButton)];
}

-(void)showSettings
{
    NSLog(@"show settings");
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.vc1 = [[SLTableViewController alloc] init];
    self.vc1.title = @"Necessary";
    
    self.vc2 = [[SLTableViewController alloc] init];
    self.vc2.title = @"Optional";

    self.vcs = @[self.vc1, self.vc2];
    
    [self.segControl addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    
    UIFont *customFont = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsButton setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = settingsButton;
    
    [self setViewControllers:@[self.vcs[self.segControl.selectedSegmentIndex]] animated:NO];
}

-(void)changeViewController:(UIEvent*)event
{
    NSInteger index =((UISegmentedControl*)event).selectedSegmentIndex;
    [self setViewControllers:@[self.vcs[index]] animated:NO];
}
@end
