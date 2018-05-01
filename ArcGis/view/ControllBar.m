//
//  ControllBar.m
//  ArcGis
//
//  Created by 姜宽 on 2018/4/25.
//  Copyright © 2018年 com.jk. All rights reserved.
//

#import "ControllBar.h"
#import <Masonry.h>

@implementation ControllBar

-(instancetype)init{
    self = [super init];
    if (self) {
        [self.select addSubview:self.line];
        [self.select addSubview:self.area];
        
        [self addSubview:self.select];
        [self addSubview:self.positon];
        [self addSubview:self.clear];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints{
    __weak ControllBar *weakSelf = self;
    [self.select mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(100);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.select);
        make.height.equalTo(weakSelf.select.mas_height).multipliedBy(0.5);
    }];
    [self.area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.select);
        make.top.equalTo(weakSelf.line.mas_bottom);
        make.height.equalTo(weakSelf.select.mas_height).multipliedBy(0.5);
    }];
    [self.positon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.select.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    [self.clear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.positon.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
}

-(void)lineBtnClick{
    [self.line setSelected:YES];
    [self.area setSelected:NO];
    if (self.delegate) {
        [self.delegate didSelectedLine];
    }
}

-(void)areaBtnClick{
    [self.line setSelected:NO];
    [self.area setSelected:YES];
    if (self.delegate) {
        [self.delegate didSelectedArea];
    }
}

-(void)positonBtnClick{
    if (self.positon.selected) {
        [self.positon setSelected:NO];
        if (self.delegate) {
            [self.delegate didDeselectPostion];
        }
    }else{
        [self.positon setSelected:YES];
        if (self.delegate) {
            [self.delegate didSelectPosition];
        }
    }
}

-(void)clearBtnClick{
    if (self.delegate) {
        [self.delegate didTapClear];
    }
}

#pragma mark getter

-(UIView *)select{
    if (!_select) {
        _select = [[UIView alloc] init];
        _select.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _select.layer.cornerRadius = 10;
        _select.layer.masksToBounds = YES;
    }
    return _select;
}

-(UIButton *)line{
    if (!_line) {
        _line = [UIButton buttonWithType:UIButtonTypeCustom];
        [_line setBackgroundImage:[UIImage imageNamed:@"button_color_select"] forState:UIControlStateSelected];
        [_line setTitle:@"长度" forState:UIControlStateNormal];
        [_line setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_line.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_line addTarget:self action:@selector(lineBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_line setSelected:YES];
    }
    return _line;
}

-(UIButton *)area{
    if (!_area) {
        _area = [UIButton buttonWithType:UIButtonTypeCustom];
        [_area setBackgroundImage:[UIImage imageNamed:@"button_color_select"] forState:UIControlStateSelected];
        [_area setTitle:@"面积" forState:UIControlStateNormal];
        [_area setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_area.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_area addTarget:self action:@selector(areaBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _area;
}

-(UIButton *)positon{
    if (!_positon) {
        _positon = [UIButton buttonWithType:UIButtonTypeCustom];
        _positon.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _positon.layer.cornerRadius = 10;
        _positon.layer.masksToBounds = YES;
        [_positon setBackgroundImage:[UIImage imageNamed:@"button_color_select"] forState:UIControlStateSelected];
        [_positon setTitle:@"定位" forState:UIControlStateNormal];
        [_positon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_positon.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_positon addTarget:self action:@selector(positonBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _positon;
}

-(UIButton *)clear{
    if (!_clear) {
        _clear = [UIButton buttonWithType:UIButtonTypeCustom];
        _clear.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _clear.layer.cornerRadius = 10;
        _clear.layer.masksToBounds = YES;
        [_clear setBackgroundImage:[UIImage imageNamed:@"button_color_select"] forState:UIControlStateHighlighted];
        [_clear setTitle:@"清空" forState:UIControlStateNormal];
        [_clear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clear.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_clear addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clear;
}

@end
