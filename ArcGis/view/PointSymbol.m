//
//  PointSymbol.m
//  ArcGis
//
//  Created by 姜宽 on 2018/4/26.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "PointSymbol.h"

@implementation PointSymbol

-(instancetype)initWithColor:(UIColor *)color{
    self = [super init];
    if (self) {
        NSMutableArray *rangeArr = [NSMutableArray array];
        for (int i = 0; i < 9; i ++) {
            AGSSimpleMarkerSceneSymbol *cone = [[AGSSimpleMarkerSceneSymbol alloc] initWithStyle:AGSSimpleMarkerSceneSymbolStyleCone color:color height:10 * pow(5, i) width:4 * pow(5, i) depth:4 * pow(5, i) anchorPosition:AGSSceneSymbolAnchorPositionBottom];
            cone.pitch = 180;
            AGSDistanceSymbolRange *range = [[AGSDistanceSymbolRange alloc] initWithSymbol:cone
                                                                               minDistance:i==0?0:1000 * pow(5, i - 1)
                                                                               maxDistance:i==4?0:1000 * pow(5, i)];
            [rangeArr addObject:range];
        }
        self.ranges = [rangeArr copy];
    }
    return self;
}

@end
