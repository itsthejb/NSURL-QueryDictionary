//
//  NSURL+Query.m
//  NSURL+Query
//
//  Created by Jon Crooke on 10/12/2013.
//  Copyright (c) 2013 Jonathan Crooke. All rights reserved.
//

#import "NSURL+QueryDictionary.h"

static NSString *const kQuerySeparator  = @"&";
static NSString *const kQueryDivider    = @"=";
static NSString *const kQueryBegin      = @"?";
static NSString *const kFragmentBegin   = @"#";

@implementation NSURL (Query)

- (NSDictionary*) queryDictionary {
  return self.query.URLQueryDictionary;
}

- (NSURL*) URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary {
  NSMutableArray *queries = self.query ? @[self.query].mutableCopy : @[].mutableCopy;
  NSString *dictionaryQuery = queryDictionary.URLQueryString;
  if (dictionaryQuery) {
    [queries addObject:dictionaryQuery];
  }
  NSString *newQuery = [queries componentsJoinedByString:kQuerySeparator];

  if (newQuery.length) {
    NSArray *queryComponents = [self.absoluteString componentsSeparatedByString:kQueryBegin];
    if (queryComponents.count) {
      return [NSURL URLWithString:
              [NSString stringWithFormat:@"%@%@%@%@%@",
               queryComponents[0],                      // existing url
               kQueryBegin,
               newQuery,
               self.fragment.length ? kFragmentBegin : @"",
               self.fragment.length ? self.fragment : @""]];
    }
  }
  return self;
}

@end

#pragma mark -

@implementation NSString (URLQuery)

- (NSDictionary*) URLQueryDictionary {
  NSMutableDictionary *mute = @{}.mutableCopy;
  for (NSString *query in [self componentsSeparatedByString:kQuerySeparator]) {
    NSArray *components = [query componentsSeparatedByString:kQueryDivider];
    NSString *key = nil;
    id value = nil;
    if (components.count > 0) {
      key = [components[0] stringByRemovingPercentEncoding];
    }
    if (components.count == 1) {
      // key with no value
      value = [NSNull null];
    }
    if (components.count == 2) {
      value = [components[1] stringByRemovingPercentEncoding];
      // cover case where there is a separator, but no actual value
      value = [value length] ? value : [NSNull null];
    }
    if (components.count > 2) {
      // invalid - ignore this pair. is this best, though?
      continue;
    }
    mute[key] = value;
  }
  return mute.count ? mute.copy : nil;
}

@end

#pragma mark -

@implementation NSDictionary (URLQuery)

- (NSString*) URLQueryString {
  NSMutableString *queryString = @"".mutableCopy;
  for (NSString *key in self.allKeys) {
    id rawValue = self[key];
    NSString *value = nil;
    // beware of empty or null
    if (!(rawValue == [NSNull null] || ![rawValue description].length)) {
      value = [[self[key] description] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    [queryString appendFormat:@"%@%@%@%@",
     queryString.length ? kQuerySeparator : @"",    // appending?
     [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
     value ? kQueryDivider : @"",
     value ? value : @""];
  }
  return queryString.length ? queryString.copy : nil;
}

@end
