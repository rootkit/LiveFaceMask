//
//  XmlParser.h
//  BangladeshInfo
//
//  Created by Outsourcsing1 on 9/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceMaskCategories.h"
#import "FaceMaskItem.h"


@interface XmlParser:NSObject<NSXMLParserDelegate>
{
    
@private
    NSXMLParser *xmlParser;
    NSInteger depth;
    NSString *currentElement;
    NSMutableString *currentName;
    
    
    FaceMaskCategories *faceMaskCategory;
    FaceMaskItem *faceMaskItem;
    
    NSMutableArray *faceMaskItemArray;
    
    
}
@property (readonly) BOOL isErrorOccured;
@property (readwrite) NSMutableArray *faceMaskArray;
- (void)loadRssFeed:(NSString *) urlString;//load XML file from Internet
@end
