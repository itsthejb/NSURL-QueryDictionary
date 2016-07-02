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

static NSString *const uq_URLReservedChars =  @"￼=,!$&'()*+;@?\r\n\"<>#\t :/";

@interface UnitTests : XCTestCase
@end

@implementation UnitTests

- (void)testShouldExtractQueryDictionary {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?cat=cheese&foo=bar").uq_queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void)testShouldExtractQueryWithEncodedValues {
  NSDictionary *dict = @{@"翻訳":@"久しぶり"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?%E7%BF%BB%E8%A8%B3=%E4%B9%85%E3%81%97%E3%81%B6%E3%82%8A").uq_queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void)testShouldIgnoreInvalidQueryComponent {
  NSDictionary *dict = @{@"cat":@"cheese"};
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?cat=cheese&invalid=foo=bar").uq_queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void)testShouldCreateSimpleQuery {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com")
                         uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com?cat=cheese&foo=bar",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldAppendASimpleQuery {
  NSDictionary *dict = @{@"key":@"value"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com/path")
                         uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com/path?key=value",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldAppendWhenURLContainsJustQueryBegin {
    NSDictionary *dict = @{@"key":@"value"};
    XCTAssertEqualObjects([URL(@"http://www.foo.com/path?")
        uq_URLByAppendingQueryDictionary:dict].absoluteString,
    @"http://www.foo.com/path?key=value",
    @"Did not create correctly formatted URL");
}

- (void)testShouldAppendToExistingQueryWithFragment {
  NSDictionary *dict = @{@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com?aKey=aValue&another=val2#fragment")
                         uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com?aKey=aValue&another=val2&cat=cheese&foo=bar#fragment",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldSortKeysWithOptionProvided {
  NSDictionary *dict = @{@"xyz":@"bazzle",@"cat":@"cheese", @"foo":@"bar"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com")
                         uq_URLByAppendingQueryDictionary:dict withSortedKeys:YES].absoluteString,
                        @"http://www.foo.com?cat=cheese&foo=bar&xyz=bazzle",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldEncodeKeysAndValues {
  NSDictionary *dict = @{@"翻訳":@"久しぶり"};
  XCTAssertEqualObjects([URL(@"http://www.foo.com") uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com?%E7%BF%BB%E8%A8%B3=%E4%B9%85%E3%81%97%E3%81%B6%E3%82%8A",
                        @"Did not return correct keys/values");
}

- (void)testShouldEncodeValuesContainingReservedCharacters {
    NSDictionary *dict = @{@"q": @"gin & tonic", @"other": uq_URLReservedChars};

    XCTAssertEqualObjects([URL(@"http://www.foo.com") uq_URLByAppendingQueryDictionary:dict].absoluteString,
    @"http://www.foo.com?q=gin%20%26%20tonic&other=%EF%BF%BC%3D%2C%21%24%26%27%28%29%2A%2B%3B%40%3F%0D%0A%22%3C%3E%23%09%20%3A%2F",
    @"Did not return correct keys/values");
}

- (void)testShouldEncodeKeysContainingReservedCharacters {
    NSDictionary *dict = @{ uq_URLReservedChars: @YES};

    XCTAssertEqualObjects([URL(@"http://www.foo.com") uq_URLByAppendingQueryDictionary:dict].absoluteString,
    @"http://www.foo.com?%EF%BF%BC%3D%2C%21%24%26%27%28%29%2A%2B%3B%40%3F%0D%0A%22%3C%3E%23%09%20%3A%2F=1",
    @"Did not return correct keys/values");
}

- (void)testShouldDealWithEmptyDictionary {
  NSString *urlString = @"http://www.foo.com?aKey=aValue&another=val2#fragment";
  XCTAssertEqualObjects([URL(urlString) uq_URLByAppendingQueryDictionary:@{}].absoluteString,
                        urlString,
                        @"Did not create correctly formatted URL");
}

- (void)testShouldHandleDictionaryValuesOtherThanStrings {
  NSDictionary *dict = @{@"number":@47, @"date":[NSDate dateWithTimeIntervalSince1970:0]};
  XCTAssertEqualObjects([URL(@"http://www.foo.com/path")
                         uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com/path?number=47&date=1970-01-01%2000%3A00%3A00%20%2B0000",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldHandleDictionaryWithEmptyPropertiesCorrectly {
  NSDictionary *dict = @{ @"key" : @"" };
  XCTAssertEqualObjects([URL(@"http://www.foo.com/")
                         uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com/?key",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldHandleDictionaryWithNullPropertyCorrectly {
  NSDictionary *dict = @{ @"key1" : [NSNull null], @"key2" : @"value" };
  XCTAssertEqualObjects([URL(@"http://www.foo.com/")
                         uq_URLByAppendingQueryDictionary:dict].absoluteString,
                        @"http://www.foo.com/?key1&key2=value",
                        @"Did not create correctly formatted URL");
}

- (void)testShouldConvertURLWithEmptyQueryValueToNSNull {
  NSDictionary *dict = @{ @"key" : [NSNull null] };
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?key").uq_queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void)testShouldHandlePossiblyInvalidURLWithSeparatorButNoValue {
  NSDictionary *dict = @{ @"key1" : [NSNull null], @"key2" : @"value" };
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?key1=&key2=value").uq_queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void)testShouldConvertURLWithEmptyQueryValueToNSNullWithMultipleKeys {
  NSDictionary *dict = @{ @"key1" : [NSNull null], @"key2" : @"value" };
  XCTAssertEqualObjects(URL(@"http://www.foo.com/?key1&key2=value").uq_queryDictionary,
                        dict,
                        @"Did not return correct keys/values");
}

- (void)testShouldCreateURLByRemovingQuery {
  XCTAssertEqualObjects([URL(@"http://www.foo.com/path/?cat=cheese&foo=bar") uq_URLByRemovingQuery],
                        URL(@"http://www.foo.com/path/"));
}

- (void)testShouldCreateURLByReplacingQueryDictionary {
  NSURL *url = URL(@"http://www.foo.com/?cat=cheese&foo=bar");
  NSURL *url2 = [url uq_URLByReplacingQueryWithDictionary:@{ @"tree" : @1}];
  XCTAssertEqualObjects(url2, URL(@"http://www.foo.com/?tree=1"));
}

@end

#undef URL
