//
//  YLAreaPickerView.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/7/29.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonObject.h"
#import "DropDownNode.h"
#import "YLScrollLabel.h"

@class YLAreaSelectView;

@interface YLAreaModel : JsonObject

@property(nonatomic, strong) NSString*  id;
@property(nonatomic, strong) NSString*  name;
@property(nonatomic, strong) NSString*  parentId;
@property(nonatomic, strong) NSArray*   list;

@end


typedef void(^YLAreaSelectViewCallback)(YLAreaSelectView* view, NSArray* areas, NSString* name);


@protocol YLAreaSelectViewDelegate <NSObject>

@optional
- (void)ylareaSelectView:(YLAreaSelectView*)view Areas:(NSArray*)areas Name:(NSString*)name;

@end

typedef NS_ENUM(NSInteger, YLAreaSelectViewStyle)
{
    YLAreaView_TableView,
    YLAreaView_Picker,
};


@interface YLAreaSelectView : UIView <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) YLScrollLabel*   titleLb;
@property(nonatomic, strong) UITableView*     tableView;
@property(nonatomic, strong) UIPickerView*    pickerView;

@property(nonatomic, copy) YLAreaSelectViewCallback     callback;
@property(nonatomic, weak) id<YLAreaSelectViewDelegate> delegate;
@property(nonatomic, assign) YLAreaSelectViewStyle      style;
@property(nonatomic, strong) NSString*                  topName;

- (instancetype)initWithFrame:(CGRect)frame JsonFile:(NSString*)jsonfile Style:(YLAreaSelectViewStyle)Style;
- (NSMutableArray*)getSelNode;
- (void)setTopNode:(NSString*)iD;
- (void)showYLAreaPicker;
- (void)closeYLAreaPicker;
- (void)addTitle:(NSString*)title;

@end
