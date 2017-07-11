//
//  SMDTableViewIndexView.m
//  Echo
//
//  Created by robu on 15/2/2.
//  Copyright (c) 2015年 Static Ga. All rights reserved.
//

#import "YXTableViewIndexView.h"


#define titleLabel_w 12
#define titleLabel_h 12
#define titleLabel_font 9
#define titleLabel_right_margin 12/2.0
#define titleLabel_top_margin 24/2.0
#define titleLabel_vertical_margin_default 4/2.0



@interface YXTableViewIndexView()
@property (assign,nonatomic) CGFloat titleLabelW;
@property (assign,nonatomic) CGFloat titleLabelH;
@property (assign,nonatomic) CGFloat titleLabelFont;
@property (assign,nonatomic) CGFloat titleLabelTopMargin;
@property (assign,nonatomic) CGFloat titleLabelRightMargin;
@property (assign,nonatomic) CGFloat titleLabelVerticalMargin;

@property (strong,nonatomic)NSMutableArray * titlesArray;
@property (strong,nonatomic)NSMutableArray * titleLabelsArray;
@property (strong,nonatomic)NSMutableArray * titleLabelCacheArray;

@property (assign,nonatomic)BOOL isMoveOutView;//touches事件是否移动超出当前view

@property (strong,nonatomic) UIImageView * titleTipImageView;
@property (strong,nonatomic) UILabel * titleTipLabel;
@end
@implementation YXTableViewIndexView

+ (id)loadFromXibForFrameWork {
    NSString * path = [[NSBundle mainBundle] pathForResource:@"ZYXCommon" ofType:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithPath:path];
    return [[bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
+ (id)loadFromXib{
    NSBundle * bundle = [NSBundle mainBundle];
    return [[bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(instancetype)init{
    if(self = [super init]){
        [self initData];
        [self initUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initData];
        [self initUI];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
    [self initUI];
}
-(void)initData{
    if(nil == self.titleLabelsArray){
        self.titleLabelsArray = [[NSMutableArray alloc] init];
    }
    if(nil == self.titleLabelCacheArray){
        self.titleLabelCacheArray = [[NSMutableArray alloc] init];
    }
    self.titleLabelW = titleLabel_w;
    self.titleLabelH = titleLabel_h;
    self.titleLabelFont = titleLabel_font;
    self.titleLabelTopMargin = titleLabel_top_margin;
    self.titleLabelRightMargin = titleLabel_right_margin;
    self.titleLabelVerticalMargin = titleLabel_vertical_margin_default;
    
}
-(void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.isShowTipView = NO;
    
    if(nil == self.titleTipImageView){
        self.titleTipImageView = [[UIImageView alloc] init];
    }
    if(nil == self.titleTipLabel){
        self.titleTipLabel = [[UILabel alloc] init];
    }
    
    self.titleTipImageView.frame = CGRectMake(-(10/2.0+110/2.0), 0, 110/2.0, 100/2.0);
    
    
    CGFloat ZYX_SCREEN_WIDTH = [[UIScreen mainScreen] bounds].size.width;
    CGFloat ZYX_SCREEN_HEIGHT = [[UIScreen mainScreen] bounds].size.height;
    
    ///self.titleTipImageView.centerX = -ZYX_SCREEN_WIDTH/2.0+self.width;
    ///self.titleTipImageView.centerY = ZYX_SCREEN_HEIGHT/2.0-64;
    CGFloat centerX = -ZYX_SCREEN_WIDTH/2.0+self.frame.size.width;
    CGFloat centerY = ZYX_SCREEN_HEIGHT/2.0-64;
    self.titleTipImageView.center = CGPointMake(centerX, centerY);
    
    
    
    ///self.titleTipImageView.backgroundColor = [UIColor colorWithHex:0x01cdce];
    self.titleTipImageView.backgroundColor = [UIColor colorWithRed:1/225.0 green:205/255.0 blue:206/255.0 alpha:1];
    self.titleTipImageView.layer.masksToBounds = YES;
    self.titleTipImageView.layer.cornerRadius = 4;
    
    self.titleTipLabel.frame = self.titleTipImageView.bounds;

    
    self.titleTipLabel.font = [UIFont systemFontOfSize:17];
    self.titleTipLabel.textAlignment = NSTextAlignmentCenter;
    self.titleTipLabel.textColor = [UIColor whiteColor];
    self.titleTipLabel.backgroundColor = [UIColor clearColor];
    [self.titleTipImageView addSubview:self.titleTipLabel];
    
    self.titleTipImageView.hidden = YES;
    [self addSubview:self.titleTipImageView];
}

-(void)setTipViewBackgroundImage:(UIImage *)tipViewBackgroundImage{
    _tipViewBackgroundImage = tipViewBackgroundImage;
    self.titleTipImageView.image = _tipViewBackgroundImage;
}
-(void)setTipViewBackgroundColor:(UIColor *)tipViewBackgroundColor{
    _tipViewBackgroundColor = tipViewBackgroundColor;
    self.titleTipImageView.backgroundColor = _tipViewBackgroundColor;
}
-(void)setTipViewTitleColor:(UIColor *)tipViewTitleColor{
    _tipViewTitleColor = tipViewTitleColor;
    self.titleTipLabel.textColor = _tipViewTitleColor;
}
-(void)setTipViewTitleFont:(UIFont *)tipViewTitleFont{
    _tipViewTitleFont = tipViewTitleFont;
    self.titleTipLabel.font = _tipViewTitleFont;
}
-(void)refreshUI{
    if(self.titlesArray.count<=0){
        return;
    }
    for(UIView * view in self.subviews){
        if([view isKindOfClass:[UILabel class]] && view != self.titleTipLabel){
            [view removeFromSuperview];
        }
    }
    //self.width = 20;
    //self.height = (self.titleLabelH+titleLabel_vertical_margin_default)*self.titlesArray.count + 14/2.0;
    CGRect selfFrame = self.frame;
    selfFrame.size.width = 20;
    selfFrame.size.height = (self.titleLabelH+titleLabel_vertical_margin_default)*self.titlesArray.count + 14/2.0;
    self.frame = selfFrame;
    
    //NSLog(@"titleLabelW=%f titleLabelVerticalMargin=%f",self.titleLabelW,self.titleLabelVerticalMargin);
    if(nil != self.tableView){
        if(self.frame.size.height>=self.tableView.frame.size.height-10){
            //self.height = self.tableView.height-10;
            selfFrame = self.frame;
            selfFrame.size.height = self.tableView.frame.size.height-10;
            self.frame = selfFrame;
            
            CGFloat verticalMargin = (self.frame.size.height - self.titleLabelTopMargin)/self.titlesArray.count - self.titleLabelH;
            if(verticalMargin<titleLabel_vertical_margin_default){
                self.titleLabelVerticalMargin = verticalMargin;
            }else{
                self.titleLabelVerticalMargin = titleLabel_vertical_margin_default;
            }
        }else{
            CGFloat verticalMargin = (self.frame.size.height - self.titleLabelTopMargin)/self.titlesArray.count - self.titleLabelH;
            if(verticalMargin>14/2.0){
                self.titleLabelVerticalMargin = 14/2.0;
            }else{
                self.titleLabelVerticalMargin = titleLabel_vertical_margin_default;
            }
            //self.height = (self.titleLabelH+self.titleLabelVerticalMargin)*self.titlesArray.count + 14/2.0;
            selfFrame = self.frame;
            selfFrame.size.height = (self.titleLabelH+self.titleLabelVerticalMargin)*self.titlesArray.count + 14/2.0;
            self.frame = selfFrame;
        }
        //self.centerY = self.tableView.centerY;
        CGPoint selfCenterPoint = self.center;
        selfCenterPoint.y = self.tableView.center.y;
        self.center = selfCenterPoint;
    }
    
    
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.titleLabelW;
    CGFloat h = self.titleLabelH;
    for(int i = 0;i<self.titlesArray.count;i++){
        NSString * title = self.titlesArray[i];
        UILabel * label = [self getCacheLabel];
        if(nil == label){
            label = [[UILabel alloc] init];
        }
        y = (w+self.titleLabelVerticalMargin)*i +self.titleLabelTopMargin;
        label.frame = CGRectMake(x, y, w, h);
        //label.textColor = [UIColor colorWithHex:0xb5b8bd];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:self.titleLabelFont];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        //label.centerX = self.width/2.0;
        
        CGPoint center = label.center;
        center.x = self.frame.size.width/2.0;
        label.center = center;
        
        label.text = title;
        [self addSubview:label];
        [self.titleLabelsArray addObject:label];
    }
    //self.titleTipImageView.centerY = self.height/2.0;
    CGPoint tCenter = self.titleTipImageView.center;
    tCenter.y = self.frame.size.height/2.0;
    self.titleTipImageView.center = tCenter;
   
}
#pragma mark 从缓存池取label
-(UILabel*)getCacheLabel{
    UILabel * label = nil;
    if(self.titleLabelCacheArray.count > 0){
        label = [self.titleLabelCacheArray lastObject];
        [self.titleLabelCacheArray removeLastObject];
    }
    return label;
}
-(void)setIndexTitlesArray:(NSArray*)titlesArray{
    if(nil == self.titlesArray){
        self.titlesArray = [[NSMutableArray alloc] init];
    }
    [self.titlesArray removeAllObjects];
    [self.titlesArray addObjectsFromArray:titlesArray];
    
    [self.titleLabelCacheArray addObjectsFromArray:self.titleLabelsArray];
    [self.titleLabelsArray removeAllObjects];
    
    [self refreshUI];
}
/* 事件处理 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    //NSLog(@"touchesBegan...%@",NSStringFromClass([self class]));
    self.isMoveOutView = NO;
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:self];
    //NSLog(@"touchesBegan..location = %@",NSStringFromCGPoint(location));
    [self indexTouchedInView:location.y];
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor clearColor];
    //NSLog(@"touchesEnded...%@",NSStringFromClass([self class]));
    
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:self];
    //NSLog(@"touchesEnded..location = %@",NSStringFromCGPoint(location));
    if(!self.isMoveOutView){//点击事件有效
        [self indexTouchedInView:location.y];
    }else{//点击事件无效
        
    }
    self.titleTipImageView.hidden = YES;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"touchesMoved...%@",NSStringFromClass([self class]));
    
    UITouch *touch=[touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    //NSLog(@"touchesMoved..location = %@",NSStringFromCGPoint(location));
    
    if (![self pointInside:[touch locationInView:self] withEvent:nil]) {
        //NSLog(@"touches moved outside the view");
        self.isMoveOutView = YES;
    }else{
        self.isMoveOutView = NO;
        UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
        if (hitView==self){
            //NSLog(@"touches moved in the view");
        }else
        {
            //NSLog(@"touches moved in the subview");
        }
        [self indexTouchedInView:location.y];
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor clearColor];
    //NSLog(@"touchesCancelled...%@",NSStringFromClass([self class]));
    self.titleTipImageView.hidden = YES;
    
}
-(NSInteger)indexTouchedInView:(CGFloat)locationY{
    NSInteger index = [self getCurrentLabelWithLoactionY:locationY];
    if(index<0){
        return index;
    }
    NSString * title = self.titlesArray[index];
    self.titleTipLabel.text = title;
    //UILabel * label = self.titleLabelsArray[index];
    //self.titleTipImageView.centerY = label.centerY;
    if(self.isShowTipView){
        self.titleTipImageView.hidden = NO;
        self.titleTipLabel.hidden = NO;
    }else{
        self.titleTipImageView.hidden = YES;
        self.titleTipLabel.hidden = YES;
    }
    
    if([self.tabelViewIndexViewDelegate respondsToSelector:@selector(tableViewSectionIndexTitle:atIndex:)]){
        [self.tabelViewIndexViewDelegate tableViewSectionIndexTitle:title atIndex:index];
    }
    return index;
}
-(NSInteger)getCurrentLabelWithLoactionY:(CGFloat)locationY{
    NSInteger index = (locationY - self.titleLabelTopMargin)/(self.titleLabelW+self.titleLabelVerticalMargin);
    //NSLog(@"getCurrentLabelWithLoactionY..index = %ld",index);
    if(index>=self.titlesArray.count){
        index = self.titlesArray.count - 1;
    }
    if(index<0){
        index = 0;
    }
    if(0 == self.titlesArray.count){
        return -1;
    }
    return index;
}

@end
