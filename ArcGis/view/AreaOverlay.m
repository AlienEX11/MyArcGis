//
//  AreaOverlay.m
//  ArcGis
//
//  Created by 姜宽 on 2018/4/24.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "AreaOverlay.h"

@implementation AreaOverlay

-(instancetype)init{
    self = [super init];
    if (self) {
        self.sceneProperties.surfacePlacement = AGSSurfacePlacementDraped;
        AGSSimpleRenderer *render = [[AGSSimpleRenderer alloc] init];
        AGSSimpleLineSymbol *line = [[AGSSimpleLineSymbol alloc] initWithStyle:AGSSimpleLineSymbolStyleDash color:[UIColor blueColor] width:1];
        render.symbol = [[AGSSimpleFillSymbol alloc] initWithStyle:AGSSimpleFillSymbolStyleHorizontal color:[UIColor blueColor] outline:line];
        self.renderer = render;
        
        [self setSelectionColor:[UIColor greenColor]];
        [self.graphics addObject:self.fillGraphic];
        self.visible = NO;
    }
    return self;
}

- (void)updateGraphics {
    if (self.pointArr.count > 2) {
        self.fillGraphic.visible = YES;
        AGSPolygonBuilder *builder = [[AGSPolygonBuilder alloc] initWithSpatialReference:[AGSSpatialReference WGS84]];
        for (AGSGraphic *item in self.pointArr) {
            [builder addPoint:(AGSPoint*)item.geometry];
        }
        [self.fillGraphic setGeometry:[builder toGeometry]];
    }else{
        self.fillGraphic.visible = NO;
    }
}

- (AGSGeometry *)getGeometry {
    if (self.pointArr.count > 2) {
        return self.fillGraphic.geometry;
    }else{
        return nil;
    }
}

#pragma mark getter

-(AGSGraphic *)fillGraphic{
    if (!_fillGraphic) {
        _fillGraphic = [[AGSGraphic alloc] initWithGeometry:nil symbol:nil attributes:nil];
    }
    return _fillGraphic;
}

@end
