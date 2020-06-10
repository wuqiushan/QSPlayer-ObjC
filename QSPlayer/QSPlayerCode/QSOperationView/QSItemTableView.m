//
//  QSItemTableView.m
//  QSPlayer
//
//  Created by wuqiushan on 2020/6/10.
//  Copyright © 2020 wuqiushan3@163.com. All rights reserved.
//

#import "QSItemTableView.h"
#import "masonry.h"

#define QSITEMTABLEVIEWCELLID @"QSItemTableViewCellId"

@interface QSItemTableView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSouce;

@end

@implementation QSItemTableView

- (instancetype)initTableViewWithArray:(NSArray <NSString *> *)titleArray {
    
    if (self = [super init]) {
        self.dataSouce = titleArray;
        if (self.dataSouce == nil) {
            self.dataSouce = @[];
        }
        [self addSubview: self.tableView];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:QSITEMTABLEVIEWCELLID];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QSITEMTABLEVIEWCELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QSITEMTABLEVIEWCELLID];
    }
    if (indexPath.row < self.dataSouce.count) {
        cell.textLabel.text = self.dataSouce[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickItemBlock) {
        self.clickItemBlock(indexPath.row, self.dataSouce[indexPath.row]);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

@end
