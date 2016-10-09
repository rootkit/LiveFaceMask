//
//  OpenGLView.m
//  DisplayLiveSamples
//
//  Created by Mamunul on 7/17/16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

#import "OGLView.h"
#include <iostream>
#include <vector>
#include <dlib/image_processing.h>
#include <dlib/image_io.h>
//


using namespace std;

@interface OGLView() {
	//
	CAEAGLLayer* _eaglLayer;
	EAGLContext* _context;
	GLKBaseEffect* _baseEffect;
	//
	GLuint _vertexBufferID;
	GLuint _indexBufferID;
	
	MaskMap maskmap;
	
	
	float prevDistOf36and45;
	float prevAngleOf36and45;
	
	float prevDistOf68and36;
	float prevAngleOf68and36;
	
	float prevDistOf69and36;
	float prevAngleOf69and36;
	
	
	float prevDistOf70and36;
	float prevAngleOf70and36;
	
	float prevDistOf71and36;
	float prevAngleOf71and36;
	
	float prevDistOf72and36;
	float prevAngleOf72and36;
	
	
	float prevDistOf73and36;
	float prevAngleOf73and36;
	
	
	float prevDistOf74and36;
	float prevAngleOf74and36;
	
	
	float prevDistOf75and36;
	float prevAngleOf75and36;
	
	
	//
}
//
@end
//
@implementation OGLView
//
//// define the face shape vertex bufferfor drawing
//
int numVertices = 76;
int sizeFaceShapeVertices = numVertices * sizeof(VertexData_t);
float W = 512.0;
float H = 512.0;


float screenWidth = 300.0;
float screenHeight = 300.0;

VertexData_t faceShapeVertices[76];



GLubyte faceShapeTriangles[] = {
	
	68,69,0,
	68,0,17,
	68,17,18,
	68,18,19,
	68,19,75,
	75,19,20,
	75,20,21,
	75,21,22,
	75,22,23,
	75,23,24,
	75,24,74,
	74,24,25,
	74,25,26,
	74,26,16,
	74,16,73,
	73,16,15,
	73,15,14,
	73,14,13,
	73,13,72,
	72,13,12,
	72,12,11,
	72,11,10,
	72,10,71,
	71,10,9,
	71,9,8,
	71,8,7,
	71,7,70,
	70,7,6,
	70,6,5,
	70,5,4,
	70,4,69,
	69,4,3,
	69,3,2,
	69,2,1,
	69,1,0,
	
	//
	0,1,36,
	1,36,41,
	1,41,31,
	1,2,31,
	2,48,31,
	2,3,48,
	3,4,48,
	4,5,48,
	5,59,48,
	5,6,59,
	6,58,59,
	6,7,58,
	7,57,58,
	7,8,57,
	8,56,57,
	8,9,56,
	9,10,56,
	10,55,56,
	
	//
	10,11,55,
	11,54,55,
	11,12,54,
	12,13,54,
	13,14,54,
	14,35,54,
	14,46,35,
	14,45,46,
	14,15,45,
	15,26,45,
	15,16,26,
	26,45,25,
	25,24,45,
	24,44,45,
	24,23,44,
	23,43,44,
	23,22,43,
	22,42,43,
	22,27,42,
	22,21,27,
	//
	
	21,39,27,
	21,38,39,
	21,20,38,
	20,37,38,
	20,19,37,
	19,18,37,
	18,36,37,
	18,17,36,
	17,0,36,
	36,37,41,
	37,41,40,
	37,40,38,
	38,40,39,
	39,28,27,
	27,28,42,
	42,43,47,
	43,47,44,
	44,47,46,
	44,46,45,
	46,47,35,
	47,42,35,
	
	
	//
	
	42,29,35,
	42,28,29,
	28,29,39,
	39,40,29,
	40,29,31,
	40,41,31,
	31,29,30,
	29,30,35,
	35,30,34,
	34,30,33,
	33,30,32,
	32,30,31,
	31,48,49,
	31,49,32,
	32,49,50,
	32,50,33,
	33,50,51,
	33,51,52,
	33,52,34,
	34,52,35,
	52,35,53,
	35,53,54,
	
	//
	
	
	52,53,63,
	52,51,63,
	51,62,63,
	51,62,61,
	51,61,50,
	50,61,49,
	49,48,60,
	48,60,59,
	60,59,49,
	49,59,61,
	61,59,67,
	61,67,62,
	62,67,66,
	62,66,65,
	62,65,63,
	63,65,55,
	63,55,53,
	53,55,64,
	53,64,54,
	54,64,55,
	55,65,56,
	56,65,66,
	56,66,57,
	
	
	//
	
	66,57,58,
	66,67,58,
	67,59,58
	
};


-(instancetype)init {
	self = [super init];
	if (self) {
		
	}
	
	return self;
}

- (void) updateVertices:(std::vector<double>)v {
	int i = 0;
	int l = numVertices;
	
	float offsetX = 0;
	
	for(; i < l; ++i) {
		float x = (float)v[i * 2];
		float y = (float)v[i * 2 + 1];
		
		VertexData_t& data = faceShapeVertices[i];
		
		data.position[0] = x + offsetX;
		data.position[1] = y;
	}
	
}



-(void) initReferenceMaskData{
	
	
	VertexData_t& data = faceShapeVertices[68];
	
	maskmap.point68 = CGPointMake(data.position[0],data.position[1]);
	
	VertexData_t& data21 = faceShapeVertices[69];
	
	maskmap.point69 = CGPointMake(data21.position[0],data21.position[1]);
	
	VertexData_t& data22 = faceShapeVertices[70];
	
	maskmap.point70 = CGPointMake(data22.position[0],data22.position[1]);
	
	VertexData_t& data23 = faceShapeVertices[71];
	
	maskmap.point71 = CGPointMake(data23.position[0],data23.position[1]);
	
	VertexData_t& data24 = faceShapeVertices[72];
	
	maskmap.point72 = CGPointMake(data24.position[0],data24.position[1]);
	
	VertexData_t& data25 = faceShapeVertices[73];
	
	maskmap.point73 = CGPointMake(data25.position[0],data25.position[1]);
	
	
	VertexData_t& data26 = faceShapeVertices[74];
	
	maskmap.point74 = CGPointMake(data26.position[0],data26.position[1]);
	
	
	VertexData_t& data27 = faceShapeVertices[75];
	
	maskmap.point75 = CGPointMake(data27.position[0],data27.position[1]);
	
	
	VertexData_t& data4 = faceShapeVertices[36];
	
	
	maskmap.prevPoint36 = CGPointMake(data4.position[0],data4.position[1]);
	
	
	VertexData_t& data5 = faceShapeVertices[45];
	
	maskmap.prevPoint45 = CGPointMake(data5.position[0],data5.position[1]);
	
	
	
	prevDistOf36and45 =[self distanceFromPoint1:maskmap.prevPoint45 Point2:maskmap.prevPoint36];
	prevAngleOf36and45 = [self angleFromLinePoint1:maskmap.prevPoint45 Point2:maskmap.prevPoint36];
	
	prevDistOf68and36 = [self distanceFromPoint1:maskmap.point68 Point2:maskmap.prevPoint36];
	prevAngleOf68and36 = [self angleFromLinePoint1:maskmap.point68 Point2:maskmap.prevPoint36];
	
	prevDistOf72and36 = [self distanceFromPoint1:maskmap.point72 Point2:maskmap.prevPoint36];
	prevAngleOf72and36 = [self angleFromLinePoint1:maskmap.point72 Point2:maskmap.prevPoint36];
	
	prevDistOf74and36 = [self distanceFromPoint1:maskmap.point74 Point2:maskmap.prevPoint36];
	prevAngleOf74and36 = [self angleFromLinePoint1:maskmap.point74 Point2:maskmap.prevPoint36];
	
	
	prevDistOf70and36 = [self distanceFromPoint1:maskmap.point70 Point2:maskmap.prevPoint36];
	prevAngleOf70and36 = [self angleFromLinePoint1:maskmap.point70 Point2:maskmap.prevPoint36];
	
	
	prevDistOf69and36 = [self distanceFromPoint1:maskmap.point69 Point2:maskmap.prevPoint36];
	prevAngleOf69and36 = [self angleFromLinePoint1:maskmap.point69 Point2:maskmap.prevPoint36];
	
	
	prevDistOf71and36 = [self distanceFromPoint1:maskmap.point71 Point2:maskmap.prevPoint36];
	prevAngleOf71and36 = [self angleFromLinePoint1:maskmap.point71 Point2:maskmap.prevPoint36];
	
	
	
	prevDistOf73and36 = [self distanceFromPoint1:maskmap.point73 Point2:maskmap.prevPoint36];
	prevAngleOf73and36 = [self angleFromLinePoint1:maskmap.point73 Point2:maskmap.prevPoint36];
	
	
	prevDistOf75and36 = [self distanceFromPoint1:maskmap.point75 Point2:maskmap.prevPoint36];
	prevAngleOf75and36 = [self angleFromLinePoint1:maskmap.point75 Point2:maskmap.prevPoint36];
	
	
}


-(void)calculateMaskRect{

	float curDistOf36and45 = [self distanceFromPoint1:maskmap.curPoint45 Point2:maskmap.curPoint36];
	float curAngleOf36and45 = [self angleFromLinePoint1:maskmap.curPoint45 Point2:maskmap.curPoint36];

	float angleDif =  prevAngleOf36and45 - curAngleOf36and45;

	
	LandmarkInfo landInfo;
	
	landInfo.angleChanged = angleDif;
	landInfo.curAngleOf36and45 = curAngleOf36and45;
	landInfo.curDistOf36and45 = curDistOf36and45;
	
	//////////////////////////**************68***************/////////////////
	
	landInfo.angleOfIndexand36 = M_PI - prevAngleOf68and36;
	
	landInfo.distOfIndexand36 = prevDistOf68and36;
	
	[self updateLandmarkPoint:68 UpdateWith:landInfo];
	//////////////////////////**************72***************/////////////////
	
	landInfo.angleOfIndexand36 = (M_PI * 2) - abs( prevAngleOf72and36);
	
	landInfo.distOfIndexand36 = prevDistOf72and36;
	
	[self updateLandmarkPoint:72 UpdateWith:landInfo];
	
	//////////////////////////**************74***************/////////////////
	
	landInfo.angleOfIndexand36 = -prevAngleOf74and36 ;
	
	landInfo.distOfIndexand36 = prevDistOf74and36;
	
	[self updateLandmarkPoint:74 UpdateWith:landInfo];
	
	//////////////////////////**************70***************/////////////////

	landInfo.angleOfIndexand36 = M_PI + abs( prevAngleOf70and36);
	
	landInfo.distOfIndexand36 = prevDistOf70and36;
	
	[self updateLandmarkPoint:70 UpdateWith:landInfo];
	
	
	//////////////////////////**************69***************/////////////////
	
	landInfo.angleOfIndexand36 = M_PI + abs( prevAngleOf69and36);
	
	landInfo.distOfIndexand36 = prevDistOf69and36;
	
	[self updateLandmarkPoint:69 UpdateWith:landInfo];

	
	//////////////////////////**************71***************/////////////////
	landInfo.angleOfIndexand36 = (M_PI * 2) - abs( prevAngleOf71and36);
	
	landInfo.distOfIndexand36 = prevDistOf71and36;
	
	[self updateLandmarkPoint:71 UpdateWith:landInfo];
	
	//////////////////////////**************73***************/////////////////

	landInfo.angleOfIndexand36 = (M_PI * 2) - abs( prevAngleOf73and36);
	
	landInfo.distOfIndexand36 = prevDistOf73and36;
	
	[self updateLandmarkPoint:73 UpdateWith:landInfo];
	
	
	//////////////////////////**************75***************/////////////////

	landInfo.angleOfIndexand36 =  -prevAngleOf75and36;
	landInfo.distOfIndexand36 = prevDistOf75and36;
	
	[self updateLandmarkPoint:75 UpdateWith:landInfo];
	
}

-(void)updateLandmarkPoint:(int)index UpdateWith:(LandmarkInfo) landInfo{
	
	float curDistOfIndexand36 = (landInfo.curDistOf36and45 / prevDistOf36and45) * landInfo.distOfIndexand36;
	
	float x_offset = curDistOfIndexand36 * cos( landInfo.angleOfIndexand36 + landInfo.angleChanged);
	
	float y_offset = curDistOfIndexand36 * sin( landInfo.angleOfIndexand36 + landInfo.angleChanged);
	
	CGPoint newPoint = CGPointMake(maskmap.curPoint36.x + x_offset, maskmap.curPoint36.y - y_offset);
	
	VertexData_t& data = faceShapeVertices[index];
	//
	data.position[0] = newPoint.x;
	data.position[1] = newPoint.y;
	
}

-(void)updateLandmarkPoint:(int)index Offset:(CGPoint) point{

	CGPoint newPoint = CGPointMake(maskmap.curPoint36.x + point.x, maskmap.curPoint36.y - point.y);
	
	VertexData_t& data = faceShapeVertices[index];
	//
	data.position[0] = newPoint.x;
	data.position[1] = newPoint.y;

}


-(float) angleFromLinePoint1:(CGPoint) point1 Point2:(CGPoint) point2{
	
	float slope = (point1.y - point2.y) / (point1.x - point2.x);
	
	float angle = atan(slope);
	
	return angle;
	
	
}

-(float) distanceFromPoint1:(CGPoint) point1 Point2:(CGPoint)point2{
	
	
	
	float d = sqrtf(powf((point1.y - point2.y),2 )+ powf((point1.x - point2.x),2));
	
	return d;
	
}

- (void) updateDlibVertices:(NSMutableArray *)shape  WithRect:(CGRect)faceRect{
	
	
	for(int i = 0; i < [shape count] ; i++){
		
		CGPoint p = [(NSValue*)[shape objectAtIndex:i] CGPointValue];
		
		//		NSLog(@"Landmark no. %d: %@",i,NSStringFromCGPoint(p));
		CGRect rect = [[UIScreen mainScreen] bounds];
//		UIScreen.bounds
//		NSLog(@"%@",NSStringFromCGRect([[UIScreen mainScreen] bounds]));
		
		float x = ((float)p.y * rect.size.width)/ 720;  // dlib axis to drawing axis conversion (y)->(x) & (x)->(y)
		
		float y = ((float)p.x * rect.size.height)/ 1280; // dlib dimension to device dimension conversion (720*1280)->(320*568)
		//
		VertexData_t& data = faceShapeVertices[i];
		//
		data.position[0] = x;
		data.position[1] = y;
		
	}
	
	VertexData_t& data234 = faceShapeVertices[57];
	
//	NSLog(@"Mask:%f,%f",data234.position[0],data234.position[1]);
	
	VertexData_t& data6 = faceShapeVertices[36];
	
	maskmap.curPoint36 = CGPointMake(data6.position[0],data6.position[1]);
	
	
	VertexData_t& data3 = faceShapeVertices[45];
	
	maskmap.curPoint45 = CGPointMake(data3.position[0],data3.position[1]);
	
		[self calculateMaskRect];
	
	
}
//
+ (Class)layerClass {
	return [CAEAGLLayer class];
}
//
- (void)setupLayer {
	_eaglLayer = (CAEAGLLayer*) self.layer;
	_eaglLayer.opaque = NO;
	_eaglLayer.drawableProperties =
	[NSDictionary dictionaryWithObjectsAndKeys: kEAGLColorFormatRGBA8,
		kEAGLDrawablePropertyColorFormat, nil];
}

- (void)setupContext {
	_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	
	GLKView* view = (GLKView*) self;
	view.context = _context;
	
	if (!_context) {
		NSLog(@"Failed to initialize OpenGLES 2.0 context");
		exit(1);
	}
	
	if (![EAGLContext setCurrentContext:_context]) {
		NSLog(@"Failed to set current OpenGL context");
		exit(1);
	}
	
	
	
	_baseEffect = [[GLKBaseEffect alloc] init];
	_baseEffect.transform.projectionMatrix =
	GLKMatrix4MakeOrtho(0, self.frame.size.width, self.frame.size.height, 0, 0, 1); // which makes top left corner as 0,0 for opengl drawing
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	
}

- (void)setupVBOs:(NSString *)imageName withLandmaskArray:(NSMutableArray *)landmarkArray {
	
	for(int i = 0; i < landmarkArray.count; ++i) {
		
		Landmarks *landmark = [landmarkArray objectAtIndex:i];
		VertexData_t& data = faceShapeVertices[i];
		data.position[0] = (landmark.xCoodinate * screenWidth)/W;
		data.position[1] = (landmark.yCoodinate * screenHeight)/H;
		data.position[2] = 0;
		data.uv[0] = landmark.xCoodinate / W;
		data.uv[1] = landmark.yCoodinate / H;
	}
	[self initReferenceMaskData];
	glGenBuffers(1, &_vertexBufferID);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
	glBufferData(GL_ARRAY_BUFFER, sizeFaceShapeVertices, NULL, GL_DYNAMIC_DRAW);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeFaceShapeVertices, faceShapeVertices);
	
	glGenBuffers(1, &_indexBufferID);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(faceShapeTriangles), NULL, GL_STATIC_DRAW);
	glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, sizeof(faceShapeTriangles), faceShapeTriangles);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData_t), (GLvoid*) offsetof(VertexData_t, position));
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData_t), (GLvoid*) offsetof(VertexData_t, uv));
	
	CGImageRef texRef = [[UIImage imageNamed:imageName] CGImage];
	//texture upside down: options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft]
	GLKTextureInfo* textureInfo =[GLKTextureLoader textureWithCGImage:texRef
															  options:nil error:NULL];
	
	_baseEffect.texture2d0.name = textureInfo.name;
	_baseEffect.texture2d0.target = GLKTextureTarget2D;// textureInfo.target;
}

//
- (void)setupVBOs {
	
	glGenBuffers(1, &_vertexBufferID);
	glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
	glBufferData(GL_ARRAY_BUFFER, sizeFaceShapeVertices, NULL, GL_DYNAMIC_DRAW);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeFaceShapeVertices, faceShapeVertices);
	
	glGenBuffers(1, &_indexBufferID);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(faceShapeTriangles), NULL, GL_STATIC_DRAW);
	glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, sizeof(faceShapeTriangles), faceShapeTriangles);
	
	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData_t), (GLvoid*) offsetof(VertexData_t, position));
	
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(VertexData_t), (GLvoid*) offsetof(VertexData_t, uv));
	
	CGImageRef texRef = [[UIImage imageNamed:@"leopard_512.png"] CGImage];
	//texture upside down: options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:GLKTextureLoaderOriginBottomLeft]
	GLKTextureInfo* textureInfo =[GLKTextureLoader textureWithCGImage:texRef
															  options:nil error:NULL];
	
	_baseEffect.texture2d0.name = textureInfo.name;
	_baseEffect.texture2d0.target = GLKTextureTarget2D;// textureInfo.target;
}
//
- (void)render:(CADisplayLink*)displayLink {
	
	glClear(GL_COLOR_BUFFER_BIT);
	
	glBufferData(GL_ARRAY_BUFFER, sizeFaceShapeVertices, NULL, GL_DYNAMIC_DRAW);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeFaceShapeVertices, faceShapeVertices);
	
	[_baseEffect prepareToDraw];
	
	glDrawElements(GL_TRIANGLES, sizeof(faceShapeTriangles)/sizeof(faceShapeTriangles[0]), GL_UNSIGNED_BYTE, 0);
	
	[_context presentRenderbuffer:GL_RENDERBUFFER];
}
//
- (void)setupDisplayLink {
	
	CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
}

- (id)initWithFrame:(CGRect)frame imageName:(NSString *)textureName landmarkArray:(NSMutableArray *)landmarkArray{
	self = [super initWithFrame:frame];
	if (self) {
		[self setupLayer];
		[self setupContext];
		[self setupVBOs:textureName withLandmaskArray:landmarkArray];
		[self setupDisplayLink];
		
		//        [self initReferenceMaskData];
	}
	return self;
}
//
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setupLayer];
		[self setupContext];
		[self setupVBOs];
		[self setupDisplayLink];
		
		[self initReferenceMaskData];
	}
	return self;
}
//
- (void)dealloc
{
	_context = nil;
}
//
@end

