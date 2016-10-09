//
//  XmlParser.m
//  BangladeshInfo
//
//  Created by Outsourcsing1 on 9/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser


- (void)dealloc
{
    xmlParser.delegate = nil;
}

-(id)init
{
    self = [super init];
    return  self;
}

- (void)loadRssFeed:(NSString *)urlString
{
    NSString *path;
//    NSLog(@"url %@", urlString);
	
    path = [[NSBundle mainBundle] pathForResource:urlString ofType:@"xml"];
    _faceMaskArray = [[NSMutableArray alloc] init];
    faceMaskItemArray =  [[NSMutableArray alloc] init];
    NSString *xml = [[NSString alloc] initWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    xmlParser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
    
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    depth = 0;
    currentElement = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", [parseError localizedDescription]);
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    if ([currentElement isEqualToString:@"category"])
    {
        faceMaskCategory = [[FaceMaskCategories alloc] init];
    }
    else if ([currentElement isEqualToString:@"item"])
    {
        faceMaskItem = [[FaceMaskItem alloc] init];
    }
}





- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmedString.length)
    {
        if ([currentElement isEqualToString:@"landmarks_file_name"]) {
            faceMaskItem.landmakrFile = string;
        }
        else if ([currentElement isEqualToString:@"item_id"])
        {
            faceMaskItem.itemID = string.integerValue;
        } else if ([currentElement isEqualToString:@"mask_title"])
        {
            faceMaskItem.title = string;
        }else if ([currentElement isEqualToString:@"mask_image_name"])
        {
            faceMaskItem.imageName = string;
        }
        else if ([currentElement isEqualToString:@"id"])
        {
            faceMaskCategory.categoryID = string.integerValue;
        } else if ([currentElement isEqualToString:@"title"])
        {
            faceMaskCategory.title = string;
        }else if ([currentElement isEqualToString:@"image_name"])
        {
            faceMaskCategory.imageName = string;
        }
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        --depth;
        [faceMaskItemArray addObject:faceMaskItem];
    }
    else if ([elementName isEqualToString:@"category"])
    {
        faceMaskCategory.faceMaskItemArray = faceMaskItemArray;
        [_faceMaskArray addObject:faceMaskCategory];
        faceMaskItemArray = [[NSMutableArray alloc] init];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}




#pragma mark -
#pragma mark Private methods

- (void)showCurrentDepth
{
    //NSLog(@"Current depth: %d", depth);
}

@end
