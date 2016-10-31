//
//  ViewController.m
//  OPenGLES-Demo
//
//  Created by 王潇 on 16/10/27.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import "ViewController.h"
#import "Demo1ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
	Demo1ViewController *demoVC = [[Demo1ViewController alloc] init];
	
	[self.navigationController pushViewController:demoVC animated:YES];
}


@end
