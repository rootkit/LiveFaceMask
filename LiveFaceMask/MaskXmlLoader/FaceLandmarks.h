//
//  FaceLandmarks.h


//

#import <Foundation/Foundation.h>

@interface FaceLandmarks : NSObject
@property (readwrite) NSInteger landmarksCount;
@property (readwrite) NSInteger maskHeight;
@property (readwrite) NSInteger maskWidth;
@property (readwrite) NSString *maskTitle;
@property (readwrite) NSString *maskImageName;
@property (readwrite) NSMutableArray *landmarksArray;
@end
