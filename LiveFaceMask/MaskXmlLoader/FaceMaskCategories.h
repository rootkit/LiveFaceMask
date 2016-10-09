//
//  FaceMaskCategories.h


//

#import <Foundation/Foundation.h>
#import "FaceMaskItem.h"
@interface FaceMaskCategories : NSObject
@property (readwrite) NSString *imageName;
@property (readwrite) NSString *title;
@property (readwrite) NSInteger categoryID;
@property (readwrite) NSMutableArray *faceMaskItemArray;
@end
