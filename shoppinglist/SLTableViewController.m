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
@property NSArray *shoppingList;
@property (weak, nonatomic) LBRESTAdapter *adapter;
@end

@implementation SLTableViewController

- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://localhost:3000"]];
    return _adapter;
}


-(void)refreshData
{
    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/api/ShoppingListItems"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSArray *entries = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             //NSLog(@"%@", [entries objectAtIndex:0]);
             NSMutableArray *shoppingList = [[NSMutableArray alloc] initWithCapacity:entries.count];

             
             for (NSDictionary *entry in entries) {
                 for( NSString *aKey in [entry allKeys] )
                 {
                     // do something like a log:
                     NSLog(@"%@ = %@; class = %@", aKey, entry[aKey], [entry[aKey] class]);
                 }

                 if ([entry[@"listType"] isEqualToString:@"Necessary"]) {
                     SLShoppingListItem *item = [[SLShoppingListItem alloc] init];
                     item.itemText = entry[@"itemText"];
                     item.completed = [entry[@"isComplete"]  isEqual: @1] ? YES : NO;
                     item.itemId = entry[@"id"];
                     [shoppingList addObject:item];
                 }
             }
             self.shoppingList = [shoppingList copy];
             [self.tableView reloadData];
         }
     }];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];
    
    
    NSMutableArray *shoppingList = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i=0; i<100; i++) {
        [shoppingList addObject:[SLShoppingListItem initWithItemText:[NSString stringWithFormat:@"Item %d", i] completed:NO]];
    }
    self.shoppingList = [shoppingList copy];
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
    NSDictionary *itemDict = @{
                               @"isComplete" : item.completed ? @YES : @NO,
                               @"id" : item.itemId,
                               @"itemText" : item.itemText,
                               @"listType" : @"Necessary"
                               };
    NSLog(@"class = %@; class = %@", [itemDict[@"isComplete"] class], [itemDict[@"id"] class]);
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:itemDict
                                                       options:0
                                                         error:&error];

    NSURL *url = [NSURL URLWithString:@"http://localhost:3000/api/ShoppingListItems"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    request.HTTPBody = postdata;
    NSLog(@"postdata = %@", itemDict);
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             [self.tableView reloadData];
             NSLog(@"completed?");
         }
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