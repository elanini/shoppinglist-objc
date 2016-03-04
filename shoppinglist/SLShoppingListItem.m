//
//  SLShoppingListItem.m
//  shoppinglist
//
//  Created by Eric Lanini on 3/3/16.
//  Copyright © 2016 Eric Lanini. All rights reserved.
//

#import "SLShoppingListItem.h"

@implementation SLShoppingListItem
+(SLShoppingListItem*)initWithItemText:(NSString*)itemText completed:(BOOL)isComplete
{
    SLShoppingListItem *item = [[SLShoppingListItem alloc] init];
    item.itemText = itemText;
    item.completed = isComplete;
    return item;
}
@end