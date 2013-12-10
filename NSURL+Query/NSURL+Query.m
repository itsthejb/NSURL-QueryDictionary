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

@implementation NSURL (Query)

- (NSDictionary*) queryDictionary {
  NSMutableDictionary *mute = @{}.mutableCopy;
  for (NSString *query in [self.query componentsSeparatedByString:kQuerySeparator]) {
    NSArray *components = [query componentsSeparatedByString:kQueryDivider];
    if (components.count == 2) {
      mute[components[0]] = components[1];
    }
  }
  return mute.count ? mute.copy : nil;
}

- (NSURL*) URLByAppendingQuery:(NSDictionary*) queryDictionary {
  return nil;
}


@end
