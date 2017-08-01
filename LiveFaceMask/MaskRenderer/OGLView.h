//
//  OpenGLView.h
//  DisplayLiveSamples
//
//  Created by Mamunul on 7/17/16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
#import "VertexData_t.h"
#import "FaceMaskItem.h"
#import "XmlParser.h"
#import "FaceLandmarks.h"
#import "Landmarks.h"


//#include <vector>

typedef struct{
	float curDistOf36and45;
	float curAngleOf36and45;
	float angleOfIndexand36;
	float distOfIndexand36;
	float angleChanged;


}LandmarkInfo;

//
@interface OGLView : GLKView
//

//- (void) updateVertices:(std::vector<double>)v;

//- (void) updateDlibVertices:(dlib::full_object_detection)shape  WithRect:(CGRect)faceRect;

- (void) updateDlibVertices:(NSMutableArray *)shape  WithRect:(CGRect)faceRect;
- (void)setupVBOs:(NSString *)imageName withLandmaskArray:(NSMutableArray *)landmaskArray;

- (void) updateDlibVertices:(NSMutableArray *)shape  WithRect:(CGRect)faceRect;
- (id)initWithFrame:(CGRect)frame imageName:(NSString *)textureName landmarkArray:(NSMutableArray *)landmarkArray;

@end


