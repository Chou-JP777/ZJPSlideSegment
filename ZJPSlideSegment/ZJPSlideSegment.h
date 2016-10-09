//
//  ZJPSlideSegment.h
//  ZJPSlideSegment
//
//  Created by 张近坪 on 2016/10/7.
//  Copyright © 2016年 张近坪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^itemClicked)(NSString *itemTitle, NSInteger index);

typedef enum {
    ZJPSegmentBottomLineStyle = 0,
    ZJPSegmentBackColorStyle = 1,
    ZJPSegmentNoneStyle = 2,
} ZJPSegmentStyle;

@interface ZJPSlideSegment : UIScrollView

//选中颜色，默认为红色
@property (nonatomic,strong) UIColor *zjp_SelectedItemColor;
//item未选中颜色,默认为黑色
@property (nonatomic,strong) UIColor *zjp_ItemsDefualtColor;
//item字体大小，默认为14
@property (nonatomic,assign) CGFloat zjp_ItemsFontSize;
//item之间的距离，默认为8
@property (nonatomic,assign) CGFloat zjp_ItemesOfMargin;
//初始选中项，默认从第一个开始（下标为0）
@property (nonatomic,assign) NSInteger zjp_DefualtSelectedIndexOfItem;

+ (ZJPSlideSegment *)zjp_SlideSegmentWithFrame:(CGRect)frame Style:(ZJPSegmentStyle)style;

- (instancetype)initWithFrame:(CGRect)frame Style:(ZJPSegmentStyle)style;

- (void)zjp_SetItems:(NSArray *)items;

- (void)zjp_ItemClicked:(itemClicked)block;

- (void)zjp_AddItems:(NSArray *)items;

- (void)zjp_RemoveItems:(NSArray *)items;

@end
