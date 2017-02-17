//
//  ZJPSlideSegment.m
//  ZJPSlideSegment
//
//  Created by 张近坪 on 2016/10/7.
//  Copyright © 2016年 张近坪. All rights reserved.
//

#import "ZJPSlideSegment.h"

#define SELF_WIDTH (CGRectGetWidth(self.bounds))
#define INDICATOR_MARGIN 4

@interface ZJPSlideSegment ()

@property (nonatomic,strong) NSMutableArray *allItems;
@property (nonatomic,strong) NSMutableArray *buttonList;

@property (nonatomic,strong) UIButton *selectedItemButton;

@property (nonatomic,strong) UIView *indicator;

@property (nonatomic,assign) ZJPSegmentStyle style;

@property (nonatomic,copy) itemClicked itemClicked;

@property (nonatomic,assign) CGFloat itemMaxY;

@end

@implementation ZJPSlideSegment

- (UIColor *)selectedItemColor {
    if (!_selectedItemColor) {
        _selectedItemColor = [UIColor redColor];
    }
    return _selectedItemColor;
}

- (CGFloat)itemesOfMargin {
    if (!_itemesOfMargin) {
        _itemesOfMargin = 8;
    }
    return _itemesOfMargin;
}

- (CGFloat)itemsFontSize {
    if (!_itemsFontSize) {
        _itemsFontSize = 14;
    }
    return _itemsFontSize;
}

- (UIColor *)itemsDefualtColor {
    if (!_itemsDefualtColor) {
        _itemsDefualtColor = [UIColor blackColor];
    }
    return _itemsDefualtColor;
}

+ (ZJPSlideSegment *)slideSegmentWithFrame:(CGRect)frame Style:(ZJPSegmentStyle)style {
    return [[ZJPSlideSegment alloc]initWithFrame:frame Style:style];
}

- (instancetype)initWithFrame:(CGRect)frame Style:(ZJPSegmentStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.allItems = [NSMutableArray array];
        self.buttonList = [NSMutableArray array];
        self.indicator = [[UIView alloc]init];
        [self addSubview:_indicator];
        _indicator.hidden = YES;
        self.style = style;
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    if (!items || items.count == 0) {
        return;
    }
    self.allItems = [items copy];
    self.itemMaxY = self.itemesOfMargin;
    for (int i = 0; i < items.count; i++) {
        [self creatItem:items[i]];
    }
    [self resizeButtonWidth];
}

- (void)addItems:(NSArray *)items {
    if (!items || items.count == 0) {
        return;
    }
    NSMutableArray *addItems = [NSMutableArray array];
    [addItems addObjectsFromArray:_allItems];
    [addItems addObjectsFromArray:items];
    self.allItems = addItems;
    for (int i = 0; i < items.count; i++) {
        [self creatItem:items[i]];
    }
    [self resizeButtonWidth];
}

- (void)removeItems:(NSArray *)items {
    if ((!items || items.count == 0) && _allItems.count == 0) {
        return;
    }
    for (int i = 0; i < items.count; i++) {
        NSString *item = items[i];
        for (int j = 0; j < _allItems.count; j++) {
            if ([item isEqualToString:_allItems[j]]) {
                UIButton *itemButton = _buttonList[j];
                [itemButton removeFromSuperview];
                [_buttonList removeObjectAtIndex:j];
                [_allItems removeObjectAtIndex:j];
                [self resizeButtonWidth];
            }
        }
    }
}

- (void)creatItem:(NSString *)item {
    CGFloat itemWidth = [self getItemTextFontSize:self.itemsFontSize withItem:item];
    UIButton *itemButton = [[UIButton alloc]initWithFrame:CGRectMake(_itemMaxY, 0, itemWidth, CGRectGetHeight(self.bounds))];
    itemButton.titleLabel.font = [UIFont systemFontOfSize:self.itemsFontSize];
    [itemButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [itemButton setTitle:item forState:UIControlStateNormal];
    [itemButton setTitleColor:self.itemsDefualtColor forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonList addObject:itemButton];
    [self addSubview:itemButton];
    _itemMaxY += _itemesOfMargin + itemWidth;
    self.contentSize = CGSizeMake(_itemMaxY, CGRectGetHeight(self.bounds));
}

- (void)resizeButtonWidth {
    _itemMaxY = _itemesOfMargin;
    for (int i = 0; i < _buttonList.count; i++) {
        CGFloat buttonWidth = (SELF_WIDTH - _itemesOfMargin * (_buttonList.count + 1)) / _buttonList.count;
        UIButton *itemButton = _buttonList[i];
        if ( buttonWidth != CGRectGetWidth(itemButton.bounds)) {
            CGRect itemButtonFrame = itemButton.frame;
            CGFloat newButtonWidth;
            if (buttonWidth > [self getItemTextFontSize:self.itemsFontSize withItem:itemButton.titleLabel.text]) {
                newButtonWidth = buttonWidth;
            } else if (buttonWidth < [self getItemTextFontSize:self.itemsFontSize withItem:itemButton.titleLabel.text]) {
                newButtonWidth = [self getItemTextFontSize:self.itemsFontSize withItem:itemButton.titleLabel.text];
            }
            itemButtonFrame.size.width = newButtonWidth;
            itemButtonFrame.origin.x = _itemMaxY;
            itemButton.frame = itemButtonFrame;
            _itemMaxY += _itemesOfMargin + newButtonWidth;
        } else {
            _itemMaxY += itemButton.bounds.size.width + _itemesOfMargin;
        }
    }
    _indicator.backgroundColor = self.selectedItemColor;
    self.contentSize = CGSizeMake(_itemMaxY, CGRectGetHeight(self.bounds));
    
    UIButton *button = _buttonList[_defualtSelectedIndexOfItem >= _buttonList.count ? 0 : _defualtSelectedIndexOfItem ];
    [self.selectedItemButton setTitleColor:_itemsDefualtColor forState:UIControlStateNormal];
    self.selectedItemButton = button;
    switch (self.style) {
        case 0:
            _indicator.frame = CGRectMake(CGRectGetMinX(button.frame), self.bounds.size.height -2, button.bounds.size.width, self.bounds.size.height);
            _indicator.hidden = NO;
            [button setTitleColor:_selectedItemColor forState:UIControlStateNormal];
            break;
        case 1:
            _indicator.frame = CGRectMake(CGRectGetMinX(button.frame), self.bounds.origin.y + INDICATOR_MARGIN, button.bounds.size.width, self.bounds.size.height - INDICATOR_MARGIN * 2);
            _indicator.layer.cornerRadius = 5;
            _indicator.layer.masksToBounds = YES;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _indicator.hidden = NO;
            break;
        case 2:
            [button setTitleColor:_selectedItemColor forState:UIControlStateNormal];
            _indicator.hidden = YES;
        default:
            break;
    }

}

- (void)itemClicked:(itemClicked)block {
    self.itemClicked = block;
}

- (void)itemButtonClicked:(id)sender {
    if (_selectedItemButton == sender) {
        return;
    }
    __block UIButton *button = sender;
    CGFloat bottomLineWidth = CGRectGetWidth(button.bounds);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_selectedItemButton setTitleColor:self.itemsDefualtColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedItemColor forState:UIControlStateNormal];
        CGRect frame = _indicator.frame;
        frame.size.width = bottomLineWidth;
        frame.origin.x = button.frame.origin.x;
        _indicator.frame = frame;
        _selectedItemButton = button;
        if (_style == ZJPSegmentBackColorStyle) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat buttonX = button.frame.origin.x;
            CGFloat buttonWidth = button.frame.size.width;
            CGFloat scrollerWidth = self.contentSize.width;
            // 移动到中间
            if (scrollerWidth > SELF_WIDTH && // Scroller的宽度大于屏幕宽度
                buttonX > SELF_WIDTH / 2.0f - buttonWidth / 2.0f && //按钮的坐标大于屏幕中间位置
                scrollerWidth > buttonX + SELF_WIDTH / 2.0f + buttonWidth / 2.0f // Scroller的宽度大于按钮移动到中间坐标加上屏幕一半宽度加上按钮一半宽度
                ) {
                self.contentOffset = CGPointMake(button.frame.origin.x - SELF_WIDTH / 2.0f + button.frame.size.width / 2.0f, 0);
            } else if (buttonX < SELF_WIDTH / 2.0f - buttonWidth / 2.0f) { // 移动到开始
                self.contentOffset = CGPointMake(0, 0);
            } else if (scrollerWidth - buttonX < SELF_WIDTH / 2.0f + buttonWidth / 2.0f || // Scroller的宽度减去按钮的坐标小于屏幕的一半，移动到最后
                       buttonX + buttonWidth + self.itemesOfMargin == scrollerWidth) {
                if (scrollerWidth > SELF_WIDTH) {
                    self.contentOffset = CGPointMake(scrollerWidth - SELF_WIDTH, 0); // 移动到末尾
                }
            }
        }];
    }];
    NSInteger selectedIndex = [self indexOfitemsSelected:sender];
    self.selectedItemButton = sender;
    self.defualtSelectedIndexOfItem = selectedIndex;
    if (self.itemClicked != nil) {
        self.itemClicked (button.titleLabel.text,selectedIndex);
    }

}

- (int)indexOfitemsSelected:(UIButton *)items {
    for (int i = 0; i < _allItems.count; i++) {
        if ([items.titleLabel.text isEqualToString:_allItems[i]] && _selectedItemButton == _buttonList[i]) {
            return i;
        }
    }
    return -1;
}

- (CGFloat)getItemTextFontSize:(CGFloat)fontSize withItem:(NSString *)itemTitle {
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]};
    CGRect itemTitleSize = [itemTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                                   options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attr
                                                   context:nil];
    return itemTitleSize.size.width + 20;
}


@end
