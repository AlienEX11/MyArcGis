//
//  GeodeticOverlay.m
//  ArcGis
//
//  Created by 姜宽 on 2018/4/25.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "GeodeticOverlay.h"
#import "PointSymbol.h"

@implementation GeodeticOverlay

-(void)addNewPoint:(AGSPoint*) mapPoint{
    if (mapPoint != nil) {
        AGSGraphic *point = [[AGSGraphic alloc] initWithGeometry:mapPoint symbol:[[PointSymbol alloc] initWithColor:[UIColor blueColor]] attributes:nil];
        [self.graphics addObject:point];
        [self.pointArr addObject:point];
        [self updateGraphics];
    }
}

-(void)updateGraphics{}

- (void)clear {
    for (AGSGraphic *graphic in self.pointArr) {
        [self.graphics removeObject:graphic];
    }
    [self.pointArr removeAllObjects];
    [self updateGraphics];
}

-(AGSGeometry *)getGeometry{return nil;}

#pragma mark getter

-(NSMutableArray *)pointArr{
    if (!_pointArr) {
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}

@end
