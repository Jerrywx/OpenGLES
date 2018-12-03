//
//  ViewController.m
//  OPenGLES-Demo
//
//  Created by 王潇 on 16/10/27.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import "ViewController.h"
#import "Demo1ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

/// 列表
@property (nonatomic, strong) UITableView		*tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	/// 初始化界面
	[self setupView];
}

/// 初始化界面
- (void)setupView {
	
	/// 控制器背景色
	self.view.backgroundColor = [UIColor whiteColor];
	
	/// 创建列表
	self.tableView = ({
		UITableView *tableView 	= [[UITableView alloc] initWithFrame:self.view.bounds
															   style:UITableViewStyleGrouped];
		tableView.delegate 		= self;
		tableView.dataSource 	= self;
		[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
		[self.view addSubview:tableView];
		tableView;
	});
	
}

#pragma mark - UITableViewDataSource
///
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

///
- (UITableViewCell *)tableView:(UITableView *)tableView
		 						cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = @"TEST";
	return cell;
}

#pragma mark - UITableViewDelegate
/// 点击列表
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	Demo1ViewController *demoVC = [[Demo1ViewController alloc] init];
	[self.navigationController pushViewController:demoVC animated:YES];
}

@end
