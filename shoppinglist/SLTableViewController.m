//
//  SLTableViewController.m
//  shoppinglist
//
//  Created by Eric Lanini on 3/3/16.
//  Copyright © 2016 Eric Lanini. All rights reserved.
//

#import "SLTableViewController.h"
#import "SLTableViewCell.h"
#import "SLShoppingListItem.h"
#import <LoopBack/LoopBack.h>
#import "MBProgressHUD.h"

@interface SLTableViewController ()
@property NSArray *shoppingList;
@property (strong, nonatomic) LBRESTAdapter *adapter;
@property (nonatomic) NSNumber *latestDataTime;
@end

@implementation SLTableViewController

-(NSNumber *)latestDataTime
{
    if (!_latestDataTime)
        _latestDataTime = [[NSNumber alloc] initWithInt:0];
    return _latestDataTime;
}

- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000/api/"]];
    return _adapter;
}


-(void)refreshData
{
    LBModelRepository *objectB = [self.adapter repositoryWithModelName:@"ShoppingListItems"];

    void (^staticMethodSuccessBlock)(NSArray *) = ^(NSArray *useless) {
        if (useless.count == 0)
            return;
        self.latestDataTime = [NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]*1000];
        NSLog(@"running success block, time = %@", self.latestDataTime);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [objectB allWithSuccess:^(NSArray *models) {
                NSMutableArray *shoppingList = [[NSMutableArray alloc] initWithCapacity:models.count];
                for (LBModel *model in models) {
                    if ([model[@"listType"] isEqualToString:self.title])
                    {
                        SLShoppingListItem *item = [[SLShoppingListItem alloc] init];
                        item.itemText = model[@"itemText"];
                        item.completed = [model[@"isComplete"]  isEqual: @1] ? YES : NO;
                        item.itemId = model[@"id"];
                        [shoppingList addObject:item];
    
                    }
                }
                self.shoppingList = [shoppingList copy];
                [self.tableView reloadData];
    
            } failure:^(NSError *error) {
                NSLog(@"error %@", error);
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        });
    };
    
    [objectB invokeStaticMethod:@"filter" parameters:@{@"filter[where][timestamp][gt]":self.latestDataTime} success:staticMethodSuccessBlock failure:^(NSError *error) {
        NSLog(@"fail");
    }];
    
}

-(void)addItemWithText:(NSString*)itemText
{
    LBModelRepository *objectB = [self.adapter repositoryWithModelName:@"ShoppingListItems"];
    LBModel *model = [objectB modelWithDictionary:@{
                                                    @"itemText" : itemText,
                                                    @"isComplete": @(NO),
                                                    @"listType": self.title
                                                    }];
    [model saveWithSuccess:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];
    [self refreshData];
}

-(void)viewDidLoad
{
    NSLog(@"view controller title = %@", self.title);
    [super viewDidLoad];
    [[ [self adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/ShoppingListItems" verb:@"GET"] forMethod:@"ShoppingListItems.filter"];

    [self refreshData];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(refreshData)
                                   userInfo:nil
                                    repeats:YES];

    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(myRightButton)];

    
    NSMutableArray *shoppingList = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i=0; i<100; i++) {
        [shoppingList addObject:[SLShoppingListItem initWithItemText:[NSString stringWithFormat:@"Item %d", i] completed:NO]];
    }
    self.shoppingList = [shoppingList copy];
}

-(void)myRightButton
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"This is an alert."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {}];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self addItemWithText:alert.textFields[0].text];
                                                          }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    SLShoppingListItem *item = (SLShoppingListItem*)[self.shoppingList objectAtIndex:indexPath.row];
    item.completed = !item.completed;
    if (item.completed == YES) {
        cell.textLabel.alpha = 0.439216f;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.alpha = 1.0f;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self pushChangeForItem:item];
}

-(void)pushChangeForItem:(SLShoppingListItem*)item
{
    LBModelRepository *objectB = [self.adapter repositoryWithModelName:@"ShoppingListItems"];
    [objectB findById:item.itemId success:^(LBModel *model) {
        NSLog(@"model isComplete class = %@", [model[@"isComplete"] class]);
        model[@"isComplete"] = item.completed ? @(YES) : @(NO);
        
        [model saveWithSuccess:^{
            NSLog(@"success");
        } failure:^(NSError *error) {
            NSLog(@"fail");
        }];
    } failure:^(NSError *error) {
        NSLog(@"didnt find item");
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    SLShoppingListItem *item = (SLShoppingListItem*)[self.shoppingList objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = item.itemText;
    if (item.completed) {
        cell.textLabel.alpha = 0.439216f;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.alpha = 1.0f;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoppingList.count;
}

@end