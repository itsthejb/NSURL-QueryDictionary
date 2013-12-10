//
//  NSURL+Query.h
//  NSURL+Query
//
//  Created by Jon Crooke on 10/12/2013.
//  Copyright (c) 2013 Jonathan Crooke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Query)

/** 
 *  @return URL's query component as keys/values 
 *  Returns nil for an empty query
 */
- (NSDictionary*) queryDictionary;

/**
 *  @return URL with keys values appending to query string
 *  @param queryDictionary Query keys/values
 *  @warning If keys overlap in receiver and query dictionary,
 *  behaviour is undefined.
 */
- (NSURL*) URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary;

@end
