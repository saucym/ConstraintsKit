//
//  ObjcTests.m
//  ConstraintsKitTests
//
//  Created by saucymqin on 2019/12/5.
//  Copyright © 2019 413132340@qq.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ConstraintsKit/ConstraintsKit.h>
#import <ConstraintsKitTests-Swift.h>

@interface ObjcTests : XCTestCase

@property (nonatomic, strong) TTView *view;

@end

@implementation ObjcTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _view = [[TTView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    UIView *sub = [UIView new];
    [self.view addSubview:sub];
    sub.wy_left(0).wy_top(0).wy_right(0).wy_bottom(0);
    [self.view layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(sub.frame, self.view.frame));
}

- (void)testExample2 {
    UIView *sub = [UIView new];
    [self.view addSubview:sub];
    sub.wy_left(@(0)).wy_top([NSNumber numberWithFloat:0]).wy_right([NSNumber numberWithInt:0]).wy_bottom([NSNumber numberWithUnsignedLong:0]);
    [self.view layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(sub.frame, self.view.frame));
}

- (void)testExample3 {
    UIView *sub = [UIView new];
    [self.view addSubview:sub];
    sub.wy_edge(UIEdgeInsetsZero);
    [self.view layoutIfNeeded];
    XCTAssertTrue(CGRectEqualToRect(sub.frame, self.view.frame));
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
