//
//  UnitTests.m
//  UnitTests
//
//  Created by Jon Crooke on 10/12/2013.
//  Copyright (c) 2013 Jonathan Crooke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURL+Query.h"

#define URL(STRING) ((NSURL*) [NSURL URLWithString: STRING])

@interface UnitTests : XCTestCase
@end

@implementation UnitTests

- (void) testExtractQueryDictionary {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?cat=cheese&foo=bar").queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

@end

#undef URL
