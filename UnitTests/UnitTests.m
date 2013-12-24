//
//  UnitTests.m
//  UnitTests
//
//  Created by Jon Crooke on 10/12/2013.
//  Copyright (c) 2013 Jonathan Crooke. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURL+QueryDictionary.h"

#define URL(STRING) ((NSURL*) [NSURL URLWithString: STRING])

@interface UnitTests : XCTestCase
@end

@implementation UnitTests

- (void) testShouldExtractQueryDictionary {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?cat=cheese&foo=bar").queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void) testShouldExtractQueryWithEncodedValues {
  NSDictionary *dict = @{@"翻訳":@"久しぶり"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?%E7%BF%BB%E8%A8%B3=%E4%B9%85%E3%81%97%E3%81%B6%E3%82%8A").queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void) testShouldIgnoreInvalidQueryComponent {
  NSDictionary *dict = @{@"cat":@"cheese"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?cat=cheese&invalid=foo=bar").queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void) testShouldCreateSimpleQuery {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com")
                         URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com?cat=cheese&foo=bar",
                        @"Did not create correctly formatted URL");
}

- (void) testShouldAppendASimpleQuery {
  NSDictionary *dict = @{@"key":@"value"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com/path")
                         URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com/path?key=value",
                        @"Did not create correctly formatted URL");
}

- (void) testShouldAppendToExistingQueryWithFragment {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com?aKey=aValue&another=val2#fragment")
                         URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com?aKey=aValue&another=val2&cat=cheese&foo=bar#fragment",
                        @"Did not create correctly formatted URL");
}

- (void) testShouldEncodeKeysAndValues {
  NSDictionary *dict = @{@"翻訳":@"久しぶり"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com") URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com?%E7%BF%BB%E8%A8%B3=%E4%B9%85%E3%81%97%E3%81%B6%E3%82%8A",
                        @"Did not return correct keys/values");
}

- (void) testShouldDealWithEmptyDictionary {
  NSString *urlString = @"http://www.foo.com?aKey=aValue&another=val2#fragment";
  XCTAssertEqualObjects([URL(urlString) URLByAppendingQueryDictionary:@{}].absoluteString,
                        urlString,
                        @"Did not create correctly formatted URL");
}

- (void) testShouldHandleEmptyValue {
    NSString *urlString = @"http://www.foo.com?aKey=";
    XCTAssertEqual([URL(urlString) queryDictionary][@"aKey"], @"", @"Value should be empty string");
}

@end

#undef URL
