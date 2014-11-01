//
//  ViewController.m
//  Barrage
//
//  Created by Jarvis on 14/10/30.
//  Copyright (c) 2014年 com.thongbin. All rights reserved.
//

#import "ViewController.h"
#import <FBGlowLabel/FBGlowLabel.h>

static const NSInteger kRowCount = 6;
static const NSInteger kAnimationDuration = 6;

@interface ViewController (){
    
    IBOutlet UIImageView *_testImage;
    IBOutlet UITextField *_contentTextField;
    IBOutlet UIButton *_showBarrageButton;
    
    NSMutableArray *_contentArray;
    NSTimer *_timer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_showBarrageButton addTarget:self action:@selector(showBarrageButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    NSArray * defaultArray = @[@"屌丝男",
                      @"高度帅",
                      @"白富美",
                      @"优质用户",
                      @"砖石王老五",
                      @"搬砖男",
                      @"IT工程师",
                      @"程序猿",
                      @"互联网新人王",
                      @"富二三四代",];
    _contentArray = [NSMutableArray arrayWithArray:defaultArray];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self countDown:3];
    [self startAnimation];
}


-(void)startAnimation{
   _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(configuration:) userInfo:nil repeats:YES];
}

-(void)configuration:(id)sender
{
    for (int i = 0 ; i < kRowCount ; i++) {
        [self configureContent:i];
    }
}

-(void)configureContent:(int)i
{
    
    NSString * contentStr = [NSString new];
    contentStr = [_contentArray objectAtIndex:arc4random() % [_contentArray count] + 0];

    CGFloat hue = ( arc4random() % 256 / 256.0 );
    
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    
    __block UILabel *_testLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [_testLabel setText:contentStr];
    [_testLabel setTextColor:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1]];
    [_testLabel setTextAlignment:NSTextAlignmentLeft];
    [_testLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    
    CGSize textSize = [_testLabel.text boundingRectWithSize:_testLabel.frame.size options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : _testLabel.font} context:nil].size;
    
    [_testLabel setFrame:CGRectMake(_testImage.frame.size.width,  30 * i  + 15, textSize.width, textSize.height)];
    
    [_testImage addSubview:_testLabel];
    
    float offset = _testLabel.frame.size.width + _testImage.frame.size.width;
    [UIView animateWithDuration:kAnimationDuration
                          delay:arc4random() % 5 + 3 //随机3 - 5 延迟时间，实现出现时间差效果
                        options:UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                     animations:^{
                         _testLabel.transform = CGAffineTransformMakeTranslation(-offset, 0);
                     }
                     completion:^(BOOL finished) {
                         [_testLabel removeFromSuperview];
                         _testLabel = nil;
                         NSLog(@"%ld",[[_testImage subviews] count]);
                     }
     ];
}

#pragma mark - Button Action
- (IBAction)sendBarrage:(id)sender {
    
    int randY = arc4random() % 6 + 0;
    __block FBGlowLabel *_testLabel = [[FBGlowLabel alloc]initWithFrame:CGRectZero];
    [_testLabel setText:_contentTextField.text];
    [_testLabel setTextColor:[UIColor whiteColor]];
    [_testLabel setTextAlignment:NSTextAlignmentLeft];
    [_testLabel setBackgroundColor:[UIColor clearColor]];
    [_testLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    _testLabel.clipsToBounds = YES;
    _testLabel.glowSize = 3;
    _testLabel.glowColor = [UIColor redColor];
    
    CGSize textSize = [_testLabel.text boundingRectWithSize:_testLabel.frame.size options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : _testLabel.font} context:nil].size;
    
    [_testLabel setFrame:CGRectMake(_testImage.frame.size.width,  30 * randY  + 15, textSize.width, textSize.height)];
    
    [_testImage addSubview:_testLabel];
    
    float offset = _testLabel.frame.size.width + _testImage.frame.size.width;
    [UIView animateWithDuration:kAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear //动画的时间曲线，滚动字幕线性比较合理
                     animations:^{
                         _testLabel.transform = CGAffineTransformMakeTranslation(-offset, 0);
                     }
                     completion:^(BOOL finished) {
                         [_testLabel removeFromSuperview];
                         _testLabel = nil;
                         NSLog(@"%ld",[[_testImage subviews] count]);
                     }
     ];
    
    [_contentArray addObject:_contentTextField.text];
    
}

-(void)showBarrageButtonDidClicked:(UIButton*)sender
{
    if ([[sender titleForState:UIControlStateNormal] hasPrefix:@"不显示"]) {
        
        [_timer invalidate];
        [sender setTitle:@"显示" forState:UIControlStateNormal];
        if ([_testImage subviews]) {
            for (__strong UIView *ob  in [_testImage subviews]) {
                [ob setHidden:YES];
                [ob removeFromSuperview];
            }
        }
    }else{
        
        [self countDown:3];
        [self startAnimation];
        [sender setTitle:@"不显示" forState:UIControlStateNormal];
        if ([_testImage subviews]) {
            for (__strong UIView *ob  in [_testImage subviews]) {
                [ob setHidden:NO];
            }
        }
    }
}

#pragma  mark - CountDown
-(void)countDown:(int)count{
    
    if(count <=0){
        
        return;
        
    }
    
    UILabel* lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    [lblCountDown setCenter:CGPointMake(CGRectGetWidth(_testImage.frame)/2, CGRectGetHeight(_testImage.frame)/2)];
    
    lblCountDown.textColor = [UIColor whiteColor];
    
    lblCountDown.font = [UIFont boldSystemFontOfSize:66];
    
    lblCountDown.backgroundColor = [UIColor clearColor];
    
    lblCountDown.text = [NSString stringWithFormat:@"%d",count];
    
    [_testImage addSubview:lblCountDown];
    
    [UIView animateWithDuration:1
     
                          delay:0
     
                        options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         
                         lblCountDown.alpha = 0;
                         
                         lblCountDown.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                         
                     }
     
                     completion:^(BOOL finished) {
                         
                         [lblCountDown removeFromSuperview];
                         
                         //递归调用，直到计时为零
                         
                         [self countDown:count -1];
                         
                     }
     
     ];
    
}

@end
