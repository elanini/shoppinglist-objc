//
//  SLShoppingListItem.h
//  shoppinglist
//
//  Created by Eric Lanini on 3/3/16.
//  Copyright © 2016 Eric Lanini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLShoppingListItem : NSObject
@property NSString *itemText;
@property BOOL completed;
@property NSNumber *itemId;
+(SLShoppingListItem*)initWithItemText:(NSString*)itemText completed:(BOOL)isComplete;
@end