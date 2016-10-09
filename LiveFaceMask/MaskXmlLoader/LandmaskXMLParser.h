//
//  LandmaskXMLParser.h
//  DisplayLiveSamples
//

//

#import <Foundation/Foundation.h>
#import "FaceLandmarks.h"
#import "Landmarks.h"
@protocol ParsingDidEndDelegate<NSObject>
-(void)didEndLandmarksParsing:(FaceLandmarks *)faceLandmarks;
@end
@interface LandmaskXMLParser : NSObject<NSXMLParserDelegate>
{
    @private
    NSMutableArray *landmarkArray;
    NSXMLParser *xmlParser;
    NSInteger depth;
    NSString *currentElement;
    
    FaceLandmarks *faceLandmarks;
}
@property (readonly) BOOL isErrorOccured;
@property (readwrite) id<ParsingDidEndDelegate> parseDelegate;

- (void)loadRssFeed:(NSString *) urlString;

@end
