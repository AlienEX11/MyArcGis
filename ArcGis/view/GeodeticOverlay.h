#import <ArcGIS/ArcGIS.h>

@interface GeodeticOverlay : AGSGraphicsOverlay

@property (nonatomic,strong) NSMutableArray *pointArr;

-(void)addNewPoint:(AGSPoint*)point;
-(void)updateGraphics;
-(void)clear;
-(AGSGeometry*)getGeometry;

@end
