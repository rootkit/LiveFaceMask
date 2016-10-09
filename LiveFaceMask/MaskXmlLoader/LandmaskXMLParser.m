//
//  LandmaskXMLParser.m
//  DisplayLiveSamples
//
//

#import "LandmaskXMLParser.h"



@implementation LandmaskXMLParser
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
    faceLandmarks = [[FaceLandmarks alloc] init];
    
    path = [[NSBundle mainBundle] pathForResource:urlString ofType:@"xml"];

    landmarkArray = [[NSMutableArray alloc] init];
    
    NSString *xml = [[NSString alloc] initWithContentsOfFile:path encoding:kCFStringEncodingUTF8 error:nil];
    xmlParser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
    [xmlParser setDelegate:self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
    [xmlParser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    currentElement = [elementName copy];
    if ([currentElement isEqualToString:@"landmark"]) {
        Landmarks *landMark = [[Landmarks alloc] init];
        landMark.landmarkIndex = ((NSString *)[attributeDict objectForKey:@"vertex"]).integerValue;
        landMark.xCoodinate = ((NSString *)[attributeDict objectForKey:@"x"]).integerValue;
        landMark.yCoodinate = ((NSString *)[attributeDict objectForKey:@"y"]).integerValue;
        [landmarkArray addObject:landMark];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmedString.length)
    {
        if ([currentElement isEqualToString:@"mask_title"])
        {
            faceLandmarks.maskTitle = trimmedString;
        }
        else if ([currentElement isEqualToString:@"mask_image_name"])
        {
            faceLandmarks.maskImageName = trimmedString;
        }
        else if ([currentElement isEqualToString:@"landmarks_count"])
        {
            faceLandmarks.landmarksCount = trimmedString.integerValue;
        }
        else if ([currentElement isEqualToString:@"width"])
        {
            faceLandmarks.maskWidth = trimmedString.integerValue;
        }
        else if ([currentElement isEqualToString:@"height"])
        {
            faceLandmarks.maskHeight = trimmedString.integerValue;
        }
    }
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"masklandmark"])
    {
        faceLandmarks.landmarksArray = landmarkArray;
//        landmarkArray = [[NSMutableArray alloc] init];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_parseDelegate didEndLandmarksParsing:faceLandmarks];
}
@end
