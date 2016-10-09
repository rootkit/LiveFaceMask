//
//  VertexData_t.h
//  DisplayLiveSamples
//
//  Created by Mamunul on 7/18/16.
//  Copyright © 2016 ZweiGraf. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef VertexData_t_h
#define VertexData_t_h


typedef struct {
	float position[3];
	float uv[2];
} VertexData_t;


typedef struct {
	
	
	struct CGPoint point68;
	struct CGPoint point69;
	struct CGPoint point70;
	struct CGPoint point71;
	struct CGPoint point72;
	struct CGPoint point73;
	struct CGPoint point74;
	struct CGPoint point75;
	struct CGPoint prevPoint36;
	struct CGPoint prevPoint45;
	struct CGPoint curPoint36;
	struct CGPoint curPoint45;

//	float x;
//	float y;
//	float w;
//	float h;
//	
//	float ref_prev_x1;
//	float ref_prev_y1;
//	float ref_prev_x2;
//	float ref_prev_y2;
//	
//
//	float ref_cur_x1;
//	float ref_cur_y1;
//	float ref_cur_x2;
//	float ref_cur_y2;
}MaskMap;

#endif /* VertexData_t_h */
