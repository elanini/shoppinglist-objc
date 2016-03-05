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

@interface SLTableViewController ()
@property NSMutableArray <SLShoppingListItem*>*shoppingList;
@property (strong, nonatomic) LBRESTAdapter *adapter;
@property (nonatomic) NSNumber *latestDataTime;
@property NSString *vcTitle;
@property UIActivityIndicatorView *activityIndicator;
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
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://45.55.14.192:3000/api/"]];
    return _adapter;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LBModelRepository *objectB = [self.adapter repositoryWithModelName:@"ShoppingListItems"];
        [objectB findById:[self.shoppingList objectAtIndex:indexPath.row].itemId success:^(LBModel *model) {
            NSLog(@"success in find for deletion");
            [model destroyWithSuccess:^{
                NSLog(@"success delete");
                [self.shoppingList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } failure:^(NSError *error) {
                NSLog(@"fail delete");
            }];
        } failure:^(NSError *error) {
            NSLog(@"failure in find for deletion");
        }];
        
    }
}


-(void)refreshData
{
    NSLog(@"vc title = %@", self.title);
    LBModelRepository *objectB = [self.adapter repositoryWithModelName:@"ShoppingListItems"];

    void (^staticMethodSuccessBlock)(NSArray *) = ^(NSArray *useless) {
        if (useless.count == 0)
            return;
        self.latestDataTime = [NSNumber numberWithUnsignedLongLong:[[NSDate date] timeIntervalSince1970]*1000];
        NSLog(@"running success block, time = %@", self.latestDataTime);
        [self.activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [objectB invokeStaticMethod:@"filter" parameters:@{@"filter[where][listType]":self.title} success:^(NSArray *models) {
                NSMutableArray *shoppingList = [[NSMutableArray alloc] initWithCapacity:models.count];
                for (LBModel *model in models) {
                    SLShoppingListItem *item = [[SLShoppingListItem alloc] init];
                    item.itemText = model[@"itemText"];
                    item.completed = [model[@"isComplete"]  isEqual: @1] ? YES : NO;
                    item.itemId = model[@"id"];
                    [shoppingList addObject:item];
                }
                self.shoppingList = shoppingList;
                [self.tableView reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"removing hud");
                    [self.activityIndicator stopAnimating];
                });
    
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"removing hud with fail");
                    [self.activityIndicator stopAnimating];
                });
            }];
            
            
        });
    };
    [objectB invokeStaticMethod:@"filter" parameters:@{@"filter[where][timestamp][gt]":self.latestDataTime} success:staticMethodSuccessBlock failure:^(NSError *error) {
        NSLog(@"fail");
    }];
    
}



-(void)addItemWithText:(NSString*)itemText
{
    LBModelRepository *objectB = [self.adapter repositoryWithModelName:@"ShoppingListItems"];
    NSLog(@"self title = %@ or %@", self.title, [self currentTitle]);
    LBModel *model = [objectB modelWithDictionary:@{
                                                    @"itemText" : itemText,
                                                    @"isComplete": @(NO),
                                                    @"listType": [self currentTitle]
                                                    }];
    [model saveWithSuccess:^{
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];

}

-(NSString*)currentTitle
{
    return self.title;
}

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    [[[self adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/ShoppingListItems" verb:@"GET"] forMethod:@"ShoppingListItems.filter"];

    UIActivityIndicatorView *actInd=[[UIActivityIndicatorView alloc]
                                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator = actInd;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:actInd];
    [self refreshData];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(refreshData)
                                   userInfo:nil
                                    repeats:YES];


}

-(void)myRightButton
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Add new item"
                                                                   message:@""
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