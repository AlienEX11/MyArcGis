//
//  PointSymbol.h
//  ArcGis
//
//  Created by 姜宽 on 2018/4/26.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface PointSymbol : AGSDistanceCompositeSceneSymbol

-(instancetype) initWithColor:(UIColor*)color;

@end
