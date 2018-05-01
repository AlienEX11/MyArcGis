//
//  LineOverlay.m
//  ArcGis
//
//  Created by 姜宽 on 2018/4/25.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "LineOverlay.h"
#import "PointSymbol.h"

@implementation LineOverlay
-(instancetype)init{
    self = [super init];
    if (self) {
        self.sceneProperties.surfacePlacement = AGSSurfacePlacementDraped;
        AGSSimpleRenderer *render = [[AGSSimpleRenderer alloc] init];
        render.symbol = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleDash color:[UIColor blueColor] width:1];;
        self.renderer = render;
        
        [self setSelectionColor:[UIColor greenColor]];
        [self.graphics addObject:self.lineGraphic];
        self.visible = NO;
    }
    return self;
}

- (void)updateGraphics {
    if (self.pointArr.count > 1) {
        self.lineGraphic.visible = YES;
        AGSPolylineBuilder *builder = [[AGSPolylineBuilder alloc] initWithSpatialReference:[AGSSpatialReference WGS84]];
        for (AGSGraphic *item in self.pointArr) {
            [builder addPoint:(AGSPoint*)item.geometry];
        }
        [self.lineGraphic setGeometry:[builder toGeometry]];
    }else{
        self.lineGraphic.visible = NO;
    }
}

- (AGSGeometry *)getGeometry {
    if (self.pointArr.count > 1) {
        return self.lineGraphic.geometry;
    }else{
        return nil;
    }
}

#pragma mark getter

-(AGSGraphic *)lineGraphic{
    if (!_lineGraphic) {
        _lineGraphic = [[AGSGraphic alloc] initWithGeometry:nil symbol:nil attributes:nil];
    }
    return _lineGraphic;
}

@end
