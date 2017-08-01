//
//  DlibWrapper.m
//  DisplayLiveSamples
//
//  Created by Luis Reisewitz on 16.05.16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

#import "DlibWrapper.h"
#import <UIKit/UIKit.h>
//#import "ViewController.swift"

#include <dlib/image_processing.h>
#include <dlib/image_io.h>

long Threshold = 9;

@interface DlibWrapper ()

@property (assign) BOOL prepared;

+ (dlib::rectangle)convertScaleCGRect:(CGRect)rect toDlibRectacleWithImageSize:(CGSize)size;
+ (std::vector<dlib::rectangle>)convertCGRectValueArray:(NSArray<NSValue *> *)rects toVectorWithImageSize:(CGSize)size;

@end
@implementation DlibWrapper {
	
	dlib::shape_predictor sp;
	dlib::full_object_detection prevShape;
	BOOL isPrevShapeNull;
	BOOL isDebug;
	long maxDiff;
	
}


-(instancetype)init {
	self = [super init];
	if (self) {
		_prepared = NO;
		isDebug = NO;
		isPrevShapeNull = YES;
		maxDiff = 0;
	}
	return self;
}

- (void)prepare {
	NSString *modelFileName = [[NSBundle mainBundle] pathForResource:@"shape_predictor_68_face_landmarks" ofType:@"dat"];
	std::string modelFileNameCString = [modelFileName UTF8String];
	
	dlib::deserialize(modelFileNameCString) >> sp;
	
	// FIXME: test this stuff for memory leaks (cpp object destruction)
	self.prepared = YES;
	
	
}
-(void)detectFaceFromSampleBuffer:(CMSampleBufferRef)sampleBuffer inRect:(CGRect)rect  InGLView:(OGLView *) glView
{
	if (!self.prepared)
		[self prepare];
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	char *baseBuffer = (char *)CVPixelBufferGetBaseAddress(imageBuffer);
	int width = (int)CVPixelBufferGetWidth(imageBuffer);
	int height = (int)CVPixelBufferGetHeight(imageBuffer);
	
	int originX = rect.origin.x * height ;
	int originY = rect.origin.y * width;
	int rectW = rect.size.width * height ;
	int rectH = rect.size.height * width;
	dlib::rectangle oneFaceRect = dlib::rectangle(width - originY - rectW ,originX , width - originY , originX + rectH);
	
	//    NSLog(@"width %d, height %d orgx %d orgy %d rw %d rh %d ", width, height, originX, originY, rectW, rectH);
	dlib::array2d<dlib::bgr_pixel> img;
	img.set_size(height,width);
	img.reset();
	long position = 0;
	while (img.move_next())
	{
		dlib::bgr_pixel& pixel = img.element();
		long bufferLocation = position * 4;
		char b = baseBuffer[bufferLocation];
		char g = baseBuffer[bufferLocation + 1];
		char r = baseBuffer[bufferLocation + 2];
		dlib::bgr_pixel newpixel(b, g, r);
		pixel = newpixel;
		position++;
	}
	
	
	
	if(isDebug){
		dlib::draw_line(oneFaceRect.left(), oneFaceRect.top(), oneFaceRect.right(), oneFaceRect.top(), img, dlib::rgb_pixel(255, 0, 0));
		dlib::draw_line(oneFaceRect.right(), oneFaceRect.bottom(), oneFaceRect.left(), oneFaceRect.bottom(), img, dlib::rgb_pixel(0, 0, 0));
		dlib::draw_line(oneFaceRect.right(), oneFaceRect.top(), oneFaceRect.right(), oneFaceRect.bottom(), img, dlib::rgb_pixel(0, 255, 0));
		dlib::draw_line(oneFaceRect.left(), oneFaceRect.top(), oneFaceRect.left(), oneFaceRect.bottom(), img, dlib::rgb_pixel(0, 255, 0));
	}
	
	dlib::full_object_detection shape = sp(img, oneFaceRect);
	img.reset();
	NSMutableArray *landmarkPoint = [[NSMutableArray alloc] init];
	for(int i = 0; i< shape.num_parts();i++)
	{
		dlib::point p = shape.part(i);
		CGPoint point = CGPointMake(p.y(), p.x());
		
		if (!isPrevShapeNull) {
			dlib::point p2 = prevShape.part(i);
			long diffX = std::abs(p.x() - p2.x());
			long diffY = std::abs(p.y() - p2.y());
			
			maxDiff = MAX(maxDiff, diffX);
			maxDiff = MAX(maxDiff, diffY);
		}
		
		NSValue *value = [NSValue valueWithCGPoint:point];
		[landmarkPoint addObject:value];
	}
	
	if(isDebug){
	
		for(int i = 0; i< shape.num_parts();i++)
		{
			dlib::point p = shape.part(i);
			
			if (!isPrevShapeNull){
				
				if(maxDiff>Threshold){
				
					p = shape.part(i);
				}else{
					p = prevShape.part(i);
				}
				
				}
			
			dlib::draw_solid_circle(img, p, 4, dlib::rgb_pixel(255, 0, 0));
			
	
		}
	
	}
	
	if (maxDiff >= Threshold || isPrevShapeNull) {
		prevShape = shape;
		isPrevShapeNull = NO;
		[glView updateDlibVertices:landmarkPoint WithRect:rect];
		
	}

		maxDiff = 0;

	if(isDebug){
		position = 0;
		while (img.move_next())
		{
			dlib::bgr_pixel& pixel = img.element();
			long bufferLocation = position * 4;
			baseBuffer[bufferLocation] = pixel.blue;
			baseBuffer[bufferLocation + 1] = pixel.green;
			baseBuffer[bufferLocation + 2] = pixel.red;
			position++;
		}
		CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	}

}

+ (dlib::rectangle)convertScaleCGRect:(CGRect)rect toDlibRectacleWithImageSize:(CGSize)size {
	
	long left = rect.origin.x * size.width;
	long top = rect.origin.y * size.height;
	long right = (rect.origin.x + rect.size.width) * size.width;
	long bottom = (rect.origin.y + rect.size.height) * size.height;
	
	dlib::rectangle dlibRect(left, top, right, bottom);
	return dlibRect;
}

+ (std::vector<dlib::rectangle>)convertCGRectValueArray:(NSArray<NSValue *> *)rects toVectorWithImageSize:(CGSize)size {
	std::vector<dlib::rectangle> myConvertedRects;
	for (NSValue *rectValue in rects) {
		
		CGRect singleRect = [rectValue CGRectValue];
		
		dlib::rectangle dlibRect = [DlibWrapper convertScaleCGRect:singleRect toDlibRectacleWithImageSize:size];
		myConvertedRects.push_back(dlibRect);
	}
	return myConvertedRects;
}

@end
