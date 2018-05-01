//
//  ControllBar.h
//  ArcGis
//
//  Created by 姜宽 on 2018/4/25.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControllBarDelegate

-(void)didSelectedLine;
-(void)didSelectedArea;
-(void)didSelectPosition;
-(void)didDeselectPostion;
-(void)didTapClear;

@end

@interface ControllBar : UIView

@property (nonatomic,strong) UIView *select;
@property (nonatomic,strong) UIButton *line;
@property (nonatomic,strong) UIButton *area;
@property (nonatomic,strong) UIButton *positon;
@property (nonatomic,strong) UIButton *clear;

@property (nonatomic,weak) id<ControllBarDelegate> delegate;

@end
