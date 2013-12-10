//
//  NSURL+Query.m
//  NSURL+Query
//
//  Created by Jon Crooke on 10/12/2013.
//  Copyright (c) 2013 Jonathan Crooke. All rights reserved.
//

#import "NSURL+Query.h"

static NSString *const kQuerySeparator  = @"&";
static NSString *const kQueryDivider    = @"=";
static NSString *const kQueryBegin      = @"?";
static NSString *const kFragmentBegin   = @"#";

@implementation NSURL (Query)

- (NSDictionary*) queryDictionary {
  NSMutableDictionary *mute = @{}.mutableCopy;
  for (NSString *query in [self.query componentsSeparatedByString:kQuerySeparator]) {
    NSArray *components = [query componentsSeparatedByString:kQueryDivider];
    if (components.count == 2) {
      NSString *key = [components[0] stringByRemovingPercentEncoding];
      NSString *value = [components[1] stringByRemovingPercentEncoding];
      mute[key] = value;
    }
  }
  return mute.count ? mute.copy : nil;
}

- (NSURL*) URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary {
  NSMutableString *query = self.query ? self.query.mutableCopy : @"".mutableCopy;
  for (NSString *key in queryDictionary.allKeys) {
    [query appendFormat:@"%@%@%@%@",
     query.length ? kQuerySeparator : @"",    // appending?
     [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
     kQueryDivider,
     [queryDictionary[key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  }
  if (query.length) {
    NSArray *queryComponents = [self.absoluteString componentsSeparatedByString:kQueryBegin];
    if (queryComponents.count) {
      return [NSURL URLWithString:
              [NSString stringWithFormat:@"%@%@%@%@%@",
               queryComponents[0],                      // existing url
               kQueryBegin,
               query,
               self.fragment.length ? kFragmentBegin : @"",
               self.fragment.length ? self.fragment : @""]];
    }
  }
  return self;
}

@end
