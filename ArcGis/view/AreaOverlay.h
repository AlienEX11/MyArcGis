//
//  AreaOverlay.h
//  ArcGis
//
//  Created by 姜宽 on 2018/4/24.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "GeodeticOverlay.h"

@interface AreaOverlay : GeodeticOverlay

@property (nonatomic,strong) AGSGraphic *fillGraphic;

@end
