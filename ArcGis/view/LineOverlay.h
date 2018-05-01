//
//  LineOverlay.h
//  ArcGis
//
//  Created by 姜宽 on 2018/4/25.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "GeodeticOverlay.h"

@interface LineOverlay : GeodeticOverlay

@property (nonatomic,strong) AGSGraphic *lineGraphic;

@end
