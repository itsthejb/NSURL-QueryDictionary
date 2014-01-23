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
    if (components.count == 2) {
      NSString *key = [components[0] stringByRemovingPercentEncoding];
      NSString *value = [components[1] stringByRemovingPercentEncoding];
      mute[key] = value;
    }
  }
  return mute.count ? mute.copy : nil;
}

@end

#pragma mark -

@implementation NSDictionary (URLQuery)

- (NSString*) URLQueryString {
  NSMutableString *queryString = @"".mutableCopy;
  for (NSString *key in self.allKeys) {
    NSString *value = [[self[key] description]
                       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [queryString appendFormat:@"%@%@%@%@",
     queryString.length ? kQuerySeparator : @"",    // appending?
     [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
     kQueryDivider,
     value];
  }
  return queryString.length ? queryString.copy : nil;
}

@end
