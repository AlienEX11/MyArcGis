//
//  ViewController.m
//  ArcGis
//
//  Created by 姜宽 on 2018/4/18.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>
#import <Masonry.h>
#import "ViewController.h"
#import "AreaOverlay.h"
#import "LineOverlay.h"
#import "ControllBar.h"
#import "PointSymbol.h"

typedef enum {
    GeodeticStatusLine = 0,
    GeodeticStatusArea
}GeodeticStatus;

@interface ViewController ()<AGSGeoViewTouchDelegate, ControllBarDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong) AGSScene *scene;
@property (nonatomic,strong) AGSSceneView *sceneView;
@property (nonatomic,strong) AreaOverlay *areaOverlay;
@property (nonatomic,strong) LineOverlay *lineOverlay;
@property (nonatomic,strong) AGSGraphicsOverlay *positionOverlay;
@property (nonatomic,strong) AGSGraphic *dragGraphic;
@property (nonatomic,strong) AGSGraphic *positionGraphic;
@property (nonatomic,strong) ControllBar *controllBar;
@property (nonatomic,strong) UILabel *geodeticBar;

@property (nonatomic) GeodeticStatus status;
@property (strong, nonatomic) CLLocationManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sceneView];
    [self.view addSubview:self.controllBar];
    [self.view addSubview:self.geodeticBar];
    [self makeConstraints];
    
    self.status = GeodeticStatusLine;
    [self currentOverlay].visible = YES;
    self.geodeticBar.text = [self currentGeodeticString];
}

-(void)makeConstraints{
    __weak ViewController *weakSelf = self;
    [self.sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.controllBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(220);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(weakSelf.view.mas_safeAreaLayoutGuideRight).offset(-15);
            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop).offset(15);
        } else {
            make.right.equalTo(weakSelf.view).offset(-15);
            make.top.equalTo(weakSelf.view).offset(15);
        }
    }];
    [self.geodeticBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-60);
        make.centerX.equalTo(weakSelf.view);
    }];
}

-(GeodeticOverlay*)currentOverlay{
    switch (self.status) {
        case GeodeticStatusArea:
            return self.areaOverlay;
        case GeodeticStatusLine:
            return self.lineOverlay;
        default:
            return self.lineOverlay;
    }
}

-(NSString*)currentGeodeticString{
    NSString *result = @"";
    switch (self.status) {
        case GeodeticStatusArea:
            result = [NSString stringWithFormat:@"当前面积: %0.2f 平方千米", [self.areaOverlay getGeometry] ? [AGSGeometryEngine geodeticAreaOfGeometry:[self.areaOverlay getGeometry] areaUnit:[AGSAreaUnit squareKilometers] curveType:AGSGeodeticCurveTypeShapePreserving] : 0];
            break;
        case GeodeticStatusLine:
            result = [NSString stringWithFormat:@"当前长度: %0.2f 千米", [self.lineOverlay getGeometry] ? [AGSGeometryEngine geodeticLengthOfGeometry:[self.lineOverlay getGeometry] lengthUnit:[AGSLinearUnit kilometers] curveType:AGSGeodeticCurveTypeShapePreserving] : 0];
            break;
    }
    return result;
}

#pragma mark AGOTouchDelegate

-(void)geoView:(AGSGeoView *)geoView didTapAtScreenPoint:(CGPoint)screenPoint mapPoint:(nonnull AGSPoint *)mapPoint{
    [[self currentOverlay] addNewPoint:mapPoint];
    self.geodeticBar.text = [self currentGeodeticString];
}

-(void)geoView:(AGSGeoView *)geoView didLongPressAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint{
    [self.sceneView identifyGraphicsOverlay:[self currentOverlay] screenPoint:screenPoint tolerance:1 returnPopupsOnly:false completion:^(AGSIdentifyGraphicsOverlayResult * _Nonnull identifyResult) {
        if (!identifyResult.error && identifyResult.graphics.count > 0) {
            for (AGSGraphic *graphic in identifyResult.graphics) {
                if ([graphic.symbol isKindOfClass:[AGSDistanceCompositeSceneSymbol class]]) {
                    self.dragGraphic = graphic;
                    [self.dragGraphic setSelected:YES];
                    break;
                }
            }
        }
    }];
}

-(void)geoView:(AGSGeoView *)geoView didMoveLongPressToScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint{
    if (self.dragGraphic && mapPoint) {
        [self.dragGraphic setGeometry:mapPoint];
        [[self currentOverlay] updateGraphics];
        self.geodeticBar.text = [self currentGeodeticString];
    }
}

-(void)geoView:(AGSGeoView *)geoView didEndLongPressAtScreenPoint:(CGPoint)screenPoint mapPoint:(AGSPoint *)mapPoint{
    if (self.dragGraphic) {
        [self.dragGraphic setSelected:NO];
        self.dragGraphic = nil;
    }
}

-(void)geoViewDidCancelLongPress:(AGSGeoView *)geoView{
    if (self.dragGraphic) {
        [self.dragGraphic setSelected:NO];
        self.dragGraphic = nil;
    }
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    AGSPoint *point = [[AGSPoint alloc] initWithCLLocationCoordinate2D:[locations lastObject].coordinate];
    self.positionGraphic.geometry = point;
    if (self.positionGraphic.visible == NO) {
        self.positionGraphic.visible = YES;
        [self.sceneView setViewpointCamera:[[AGSCamera alloc] initWithLookAtPoint:point distance:1500 heading:0 pitch:0 roll:0] completion:nil];
    }
}

#pragma mark ControllBarDelegate

-(void)didSelectedLine{
    self.dragGraphic = nil;
    [self.areaOverlay clear];
    self.areaOverlay.visible = NO;
    self.lineOverlay.visible = YES;
    self.status = GeodeticStatusLine;
    self.geodeticBar.text = [self currentGeodeticString];
}

-(void)didSelectedArea{
    self.dragGraphic = nil;
    [self.lineOverlay clear];
    self.lineOverlay.visible = NO;
    self.areaOverlay.visible = YES;
    self.status = GeodeticStatusArea;
    self.geodeticBar.text = [self currentGeodeticString];
}

-(void)didTapClear{
    [[self currentOverlay] clear];
    self.geodeticBar.text = [self currentGeodeticString];
}

- (void)didSelectPosition {
    @try{
        [_manager requestWhenInUseAuthorization];
        [self.manager startUpdatingLocation];
    }
    @catch(NSException *exception){
    }
}

- (void)didDeselectPostion {
    @try{
        self.positionGraphic.visible = NO;
        [self.manager stopUpdatingLocation];
    }
    @catch(NSException *exception){
    }
}

#pragma mark getter

-(AGSScene *)scene{
    if (!_scene) {
        _scene = [[AGSScene alloc] init];
        _scene.basemap = [AGSBasemap imageryBasemap];
        
        AGSArcGISSceneLayer *sceneLayer = [[AGSArcGISSceneLayer alloc] initWithURL:[NSURL URLWithString:@"https://tiles.arcgis.com/tiles/P3ePLMYs2RVChkJx/arcgis/rest/services/Buildings_Brest/SceneServer/layers/0"]];
        [_scene.operationalLayers addObject:sceneLayer];
        
        AGSArcGISTiledElevationSource *elevationSource = [[AGSArcGISTiledElevationSource alloc] initWithURL:[NSURL URLWithString:@"https://elevation3d.arcgis.com/arcgis/rest/services/WorldElevation3D/Terrain3D/ImageServer"]];
        AGSSurface *surface = [[AGSSurface alloc] init];
        NSMutableArray *mutableArray = [surface.elevationSources mutableCopy];
        [mutableArray addObject:elevationSource];
        surface.elevationSources = mutableArray;
        _scene.baseSurface = surface;
    }
    return _scene;
}

-(AGSSceneView *)sceneView{
    if (!_sceneView) {
        _sceneView = [[AGSSceneView alloc] initWithFrame:self.view.frame];
        _sceneView.scene = self.scene;
        [_sceneView.graphicsOverlays addObject:self.positionOverlay];
        [_sceneView.graphicsOverlays addObject:self.areaOverlay];
        [_sceneView.graphicsOverlays addObject:self.lineOverlay];
        _sceneView.touchDelegate = self;
    }
    return _sceneView;
}

-(AreaOverlay *)areaOverlay{
    if (!_areaOverlay) {
        _areaOverlay = [[AreaOverlay alloc] init];
    }
    return _areaOverlay;
}

-(LineOverlay *)lineOverlay{
    if (!_lineOverlay) {
        _lineOverlay = [[LineOverlay alloc] init];
    }
    return _lineOverlay;
}

-(AGSGraphicsOverlay *)positionOverlay{
    if (!_positionOverlay) {
        _positionOverlay = [[AGSGraphicsOverlay alloc] init];
        _positionOverlay.sceneProperties.surfacePlacement = AGSSurfacePlacementDraped;
        [_positionOverlay.graphics addObject:self.positionGraphic];
    }
    return _positionOverlay;
}

-(AGSGraphic *)positionGraphic{
    if (!_positionGraphic) {
        _positionGraphic = [[AGSGraphic alloc] initWithGeometry:nil symbol:[[PointSymbol alloc] initWithColor:[UIColor redColor]] attributes:nil];
        _positionGraphic.visible = NO;
    }
    return _positionGraphic;
}

-(CLLocationManager *)manager{
    if (!_manager) {
        _manager = [[CLLocationManager alloc] init];
        [_manager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_manager setDistanceFilter:100];
        _manager.delegate = self;
    }
    return _manager;
}

-(ControllBar *)controllBar{
    if (!_controllBar) {
        _controllBar = [[ControllBar alloc] init];
        _controllBar.frame = CGRectMake(30, 60, 60, 180);
        _controllBar.delegate = self;
    }
    return _controllBar;
}

-(UILabel *)geodeticBar{
    if (!_geodeticBar) {
        _geodeticBar = [[UILabel alloc] init];
        _geodeticBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _geodeticBar.textColor = [UIColor whiteColor];
        _geodeticBar.font = [UIFont systemFontOfSize:15];
    }
    return _geodeticBar;
}

@end
