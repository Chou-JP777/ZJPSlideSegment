//
//  ViewController.m
//  ZJPSlideSegmentDemo
//
//  Created by 张近坪 on 2016/10/9.
//  Copyright © 2016年 张近坪. All rights reserved.
//

#import "ViewController.h"
#import "ZJPSlideSegment.h"

#define SCREEN_WIDTH (CGRectGetWidth(self.view.bounds))

@interface ViewController ()
@property (nonatomic,strong) ZJPSlideSegment *segmentBottomLine;
@property (nonatomic,strong) ZJPSlideSegment *segmentBackColor;
@property (nonatomic,strong) ZJPSlideSegment *segmentNone;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentBottomLine = [[ZJPSlideSegment alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40) Style:ZJPSegmentBottomLineStyle];
    self.segmentBottomLine.itemesOfMargin = 10;
    self.segmentBottomLine.selectedItemColor = [UIColor orangeColor];
    self.segmentBottomLine.backgroundColor = [UIColor lightGrayColor];
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        NSString *string = [NSString stringWithFormat:@"菜单%d",i+1];
        [items addObject:string];
    }
    [self.segmentBottomLine setItems:items];
    [self.view addSubview:self.segmentBottomLine];
    
    [self.segmentBottomLine itemClicked:^(NSString *itemTitle, NSInteger index) {
        NSLog(@"%@被选中，下标为%ld",itemTitle,(long)index);
    }];
    
    self.segmentBackColor = [[ZJPSlideSegment alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 40) Style:ZJPSegmentBackColorStyle];
    self.segmentBackColor.backgroundColor = [UIColor lightGrayColor];
    [self.segmentBackColor setItems:@[@"菜单1",@"测试菜单1",@"菜单2",@"测试菜单2"]];
    [self.view addSubview:self.segmentBackColor];
    
    self.segmentNone = [[ZJPSlideSegment alloc]initWithFrame:CGRectMake(0, 180, SCREEN_WIDTH, 40) Style:ZJPSegmentNoneStyle];
    self.segmentNone.backgroundColor = [UIColor lightGrayColor];
    [self.segmentNone setItems:@[@"菜单1",@"测试菜单1",@"菜单2",@"测试菜单2"]];
    [self.view addSubview:self.segmentNone];
    
}
- (IBAction)addItemsButton:(id)sender {
    [self addItems];
}
- (IBAction)deleteItemsButton:(id)sender {
    [self deleteItems];
}

- (void)addItems {
    [self.segmentBottomLine addItems:@[@"添加菜单1",@"添加菜单2"]];
}

- (void)deleteItems {
    [self.segmentBottomLine removeItems:@[@"添加菜单1",@"添加菜单2"]];
}

@end
