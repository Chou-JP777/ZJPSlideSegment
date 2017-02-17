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
@property (nonatomic,strong) UIColor *selectedItemColor;
//item未选中颜色,默认为黑色
@property (nonatomic,strong) UIColor *itemsDefualtColor;
//item字体大小，默认为14
@property (nonatomic,assign) CGFloat itemsFontSize;
//item之间的距离，默认为8
@property (nonatomic,assign) CGFloat itemesOfMargin;
//初始选中项，默认从第一个开始（下标为0）
@property (nonatomic,assign) NSInteger defualtSelectedIndexOfItem;

+ (ZJPSlideSegment *)slideSegmentWithFrame:(CGRect)frame Style:(ZJPSegmentStyle)style;

- (instancetype)initWithFrame:(CGRect)frame Style:(ZJPSegmentStyle)style;

- (void)setItems:(NSArray *)items;

- (void)itemClicked:(itemClicked)block;

- (void)addItems:(NSArray *)items;

- (void)removeItems:(NSArray *)items;

@end
