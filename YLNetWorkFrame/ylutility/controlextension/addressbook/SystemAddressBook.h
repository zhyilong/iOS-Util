//
//  SystemAddressBook.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/20.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

@interface SystemAddressBook : NSObject

+ (ABPeoplePickerNavigationController*)createSystemAddressBook:(id)delegate;

@end
