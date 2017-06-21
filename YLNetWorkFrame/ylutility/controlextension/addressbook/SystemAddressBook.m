//
//  SystemAddressBook.m
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "SystemAddressBook.h"

@implementation SystemAddressBook

+ (ABPeoplePickerNavigationController*)createSystemAddressBook:(id<ABPeoplePickerNavigationControllerDelegate>)delegate
{
    ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
    nav.peoplePickerDelegate = delegate;
    
    if(1)
    {
        nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
    }
    
    return nav;
}
@end
