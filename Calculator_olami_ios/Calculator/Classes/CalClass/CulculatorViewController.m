//
//  CulculatorViewController.m
//  Culculator
//
//  Created by Scarlett on 2017/6/29.
//  Copyright © 2017年 Scarlett Zhao. All rights reserved.
//

#import "CulculatorViewController.h"
#import "OlamiRecognizer.h"
#import "WaveView.h"
#import "UIViewController+ZYSliderViewController.h"
#import "ZYSliderViewController.h"
#import "DataBaseManager.h"
#import "Equation.h"
#import "CalculatorDetails.h"
#import "SkinViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ScaleLabel.h"


@interface CulculatorViewController ()<OlamiRecognizerDelegate, UITextViewDelegate>{
    SystemSoundID soundID;
    SystemSoundID soundID1;
}

@property (nonatomic, strong) CalculatorDetails *calcultor;

@property (nonatomic, strong) OlamiRecognizer *olamiRecognizer;

@property (nonatomic, strong) WaveView *waveView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSString *lastAnswer;//上一次的记录

@property (nonatomic, strong) NSString *passString;//转码之后将有些Unicode码转换

@property (nonatomic, strong) UIImageView *backView;

@property (strong, nonatomic) ScaleLabel *resultLabel;
@end

@implementation CulculatorViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [[NSMutableArray alloc] init];
    _calcultor = [[CalculatorDetails alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //接收传值通知(注册)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyTongzhi:) name:@"historyTongzhi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chuanTongzhi:) name:@"chuanTongzhi" object:nil];
    
    
    //设置nav栏
    [self setupNavView];

    //UI
    [self setupUI];
    
    //语音初始化
    [self setupOLAMI];
    
    //音频提示音初始化
    [self setupMusic];

}

//历史记录传回
- (void)historyTongzhi:(NSNotification *) text {
    NSRange range = [text.userInfo[@"text"] rangeOfString:@"="];
    _resultLabel.text = [text.userInfo[@"text"] substringFromIndex:range.location+1];
    _resultLabel.font = [UIFont systemFontOfSize:50];
    [_resultLabel startAnimation];

    _showTextView.text = [text.userInfo[@"text"] substringToIndex:range.location+1];
}

//传桌面背景值处理
- (void)chuanTongzhi:(NSNotification *)text {
    _backView.image = [UIImage imageNamed:text.userInfo[@"str"]];
}

- (void)setupNavView {
    self.navigationController.navigationBar.backgroundColor = BlueColor;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(OpenLeftMenuView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[[UIImage imageNamed:@"history4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(OpenHistoryView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupUI {
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:kScreenBounds];
    backImage.image = [UIImage imageNamed:@"3186-150119164122-50.jpg"];
    [self.view addSubview:backImage];
    [self.view sendSubviewToBack:backImage];
    _backView = backImage;
    
    _resultLabel = [[ScaleLabel alloc] initWithFrame:CGRectMake(10, 64+50, kScreenWidth-20, 130)];
    _resultLabel.backgroundColor = ClearColor;
    _resultLabel.startScale       = 1.5f;
    _resultLabel.endScale         = 2.f;
    _resultLabel.backedLabelColor = [UIColor whiteColor];
    _resultLabel.colorLabelColor  = [UIColor cyanColor];
    _resultLabel.font             = [UIFont systemFontOfSize:50.f];
    [self.view addSubview:_resultLabel];

    //波动图
    _waveView = [[WaveView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    [self.view addSubview:_waveView];
    [self.view bringSubviewToFront:_recordButton];
}

#pragma mark --  asr语音系统初始化设置
- (void)setupOLAMI {
    _olamiRecognizer= [[OlamiRecognizer alloc] init];
    _olamiRecognizer.delegate = self;

    [_olamiRecognizer setAuthorization:AppKey api:@"asr" appSecret:AppSecret cusid:macID];
    
    //设置语言，目前只支持中文
    [_olamiRecognizer setLocalization:LANGUAGE_SIMPLIFIED_CHINESE];

}

#pragma mark -- 音频初始化
- (void)setupMusic {
    NSString *faulePath = [[NSBundle mainBundle] pathForResource:@"5404" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:faulePath], &soundID);
    
    NSString *seccessPath = [[NSBundle mainBundle] pathForResource:@"8378" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:seccessPath], &soundID1);
}

#pragma mark -- rightViewOpen
- (void)OpenHistoryView {
    [[self sliderViewController] showRight];
    
}

#pragma mark -- leftViewOpen
- (void)OpenLeftMenuView {
    [[self sliderViewController] showLeft];
}


#pragma mark--NLU delegate
- (void)onUpdateVolume:(float)volume {
    if (_olamiRecognizer.isRecording) {
        _waveView.present = volume/100;
    }
}

#pragma mark --返回结果
- (void)onResult:(NSData *)result {
    NSError *error;
    __weak typeof(self) weakSelf = self;
    if (error) {
        NSLog(@"error is %@",error.localizedDescription);
    }else{
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:result
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        NSLog(@"json=%@",json);
        
        if ([json[@"status"] isEqualToString:@"ok"]) {

            
            NSDictionary *asr = [json[@"data"] objectForKey:@"asr"];
            
            //如果asr不为空，说明目前是语音输入
            if (asr) {
                [weakSelf processASR:asr];
            }
            
            
            NSDictionary *nli = [[json[@"data"] objectForKey:@"nli"] objectAtIndex:0];
            NSDictionary *desc = [nli objectForKey:@"desc_obj"];
            int status = [[desc objectForKey:@"status"] intValue];
            if (status != 0) {// 0 说明状态正常,非零为状态不正常
                NSString *result  = [desc objectForKey:@"result"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _resultLabel.text = result;//输出不正常提示
                    _resultLabel.font = [UIFont systemFontOfSize:20];
                    [_resultLabel startAnimation];
                    
                    _showTextView.text = asr[@"result"];
                    AudioServicesPlaySystemSound (soundID);
                });
                
            }else{
                NSDictionary *semantic = [[nli objectForKey:@"semantic"]
                                          objectAtIndex:0];
                //对slot和算式的处理结果
                [weakSelf processSemantic:semantic asr:asr];
                //处理modifier
                NSArray *modifierArr = [semantic objectForKey:@"modifier"];
                
                [weakSelf processModifier:modifierArr result:desc[@"result"]];
            }
            

        }else{
            _showTextView.text = @"请说出要计算的公式";
        }
    }
    
}

- (void)processModifier:(NSArray *)modifierArr result:(NSString *)result {
    if (modifierArr.count != 0) {
        for (NSString *str in modifierArr) {
            if ([str isEqualToString:@"clear"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self clear];
                });
            }
            else if([str isEqualToString:@"save"]){
                [self save];
                [self showAlert:result];
            }
            
        }
        
    }

}


- (void)processSemantic:(NSDictionary*)semanticDic asr:(NSDictionary *)asr {
    NSMutableArray *numArr1 = [NSMutableArray array];
    NSMutableArray *numArr2 = [NSMutableArray array];
    NSMutableArray *numArr3 = [NSMutableArray array];
    NSMutableArray *numArr4 = [NSMutableArray array];
    NSMutableArray *numArr5 = [NSMutableArray array];
    NSMutableArray *sumArr = [NSMutableArray array];
    for (NSDictionary *dic in semanticDic[@"slots"]) {
        NSString *nameStr = dic[@"name"];
        if ([nameStr containsString:@"1"]) {
            if ([nameStr isEqualToString:@"sqr1"]) {
                [numArr1 addObject:@"2√"];
            }
            if ([nameStr isEqualToString:@"number1"]) {
                [numArr1 addObject:dic[@"num_detail"][@"recommend_value"]];
            }
            if ([nameStr isEqualToString:@"symbol1"]) {
                [numArr1 addObject:dic[@"value"]];
            }
        }
        if ([nameStr containsString:@"sqr2"]) {
            [numArr2 addObject:@"2√"];
        }
        if ([nameStr isEqualToString:@"number2"]) {
            [numArr2 addObject:dic[@"num_detail"][@"recommend_value"]];
        }
        if ([nameStr isEqualToString:@"symbol2"]) {
            [numArr2 addObject:dic[@"value"]];
        }
        
        
        if ([nameStr isEqualToString:@"sqr3"]) {
            [numArr3 addObject:@"2√"];
        }
        if ([nameStr isEqualToString:@"number3"]) {
            [numArr3 addObject:dic[@"num_detail"][@"recommend_value"]];
        }
        if ([nameStr isEqualToString:@"symbol3"]) {
            [numArr3 addObject:dic[@"value"]];
        }

        
        
        if ([nameStr isEqualToString:@"sqr4"]) {
            [numArr4 addObject:@"2√"];
        }
        if ([nameStr isEqualToString:@"number4"]) {
            [numArr4 addObject:dic[@"num_detail"][@"recommend_value"]];
        }
        if ([nameStr isEqualToString:@"symbol4"]) {
            [numArr4 addObject:dic[@"value"]];
        }

        

        if ([nameStr isEqualToString:@"sqr5"]) {
            [numArr5 addObject:@"2√"];
        }
        if ([nameStr isEqualToString:@"number5"]) {
            [numArr5 addObject:dic[@"num_detail"][@"recommend_value"]];
        }

    }
    if ([numArr2 containsObject:@"2√"]) {
        [numArr2 exchangeObjectAtIndex:0 withObjectAtIndex:1];
    }
    if ([numArr3 containsObject:@"2√"]) {
        [numArr3 exchangeObjectAtIndex:0 withObjectAtIndex:1];
    }

    if (numArr4.count == 3) {
        if ([numArr4 containsObject:@"2√"]) {
//            [numArr4 exchangeObjectAtIndex:0 withObjectAtIndex:2];
//            [numArr4 exchangeObjectAtIndex:1 withObjectAtIndex:2];
        }
    }else{
        if ([numArr4 containsObject:@"2√"]) {
            [numArr4 removeObject:@"2√"];
            [numArr4 insertObject:@"2√" atIndex:0];
        }
    }

    if ([numArr5 containsObject:@"2√"]) {
        [numArr5 removeObject:@"2√"];
        [numArr5 insertObject:@"2√" atIndex:0];
        
    }

    
    [sumArr addObjectsFromArray:numArr1];
    [sumArr addObjectsFromArray:numArr2];
    [sumArr addObjectsFromArray:numArr3];
    [sumArr addObjectsFromArray:numArr4];
    [sumArr addObjectsFromArray:numArr5];

    NSLog(@"arr1%@ arr2%@ arr3=%@ arr4=%@ arr5=%@ sumArr=%@",numArr1,numArr2,numArr3,numArr4,numArr5,sumArr);
 
    NSString *textStr = [[sumArr componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSLog(@"textstr=%@",textStr);
    
    if (![textStr isEqualToString:@""]) {
        _passString = [self replaceInputStrWithPassStr:textStr];

        if (asr) {
            _lastAnswer = _resultLabel.text;//语音记录上一次记录
        }else{
            _lastAnswer = @"";
        }
        
        //第一次运算或者不再加
        if ([_lastAnswer isEqualToString:@"error"]||[_lastAnswer isEqualToString:@""]) {
            if (asr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _showTextView.text = [[textStr stringByReplacingOccurrencesOfString:@"2√" withString:@"√"] stringByAppendingString:@"="];//计算公式
                });
                textStr = [_calcultor calculatingWithString:_passString andAnswerString:@"0"];
            }else{
                textStr = [_calcultor calculatingWithString:_passString andAnswerString:@"0"];
            }


        //有结果考虑再运算的步骤
        }else{
            
            //有结果再运算的情况
            UniChar c = [_passString characterAtIndex:0];
            if (c =='-'|| c == '+'||c == 'x'||c =='/')
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _showTextView.text = [[_lastAnswer stringByAppendingString:[textStr stringByReplacingOccurrencesOfString:@"2√" withString:@"√"]] stringByAppendingString:@"="];//计算公式
                });
                
                textStr = [_calcultor calculatingWithString:[_lastAnswer stringByAppendingString:_passString] andAnswerString:@"0"];//
            }
            //有结果但是不想再运算
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    _showTextView.text = [[textStr stringByReplacingOccurrencesOfString:@"2√" withString:@"√"] stringByAppendingString:@"="];//计算公式
                });
                textStr = [_calcultor calculatingWithString:_passString andAnswerString:@"0"];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (![textStr isEqualToString:@"error"]) {
                AudioServicesPlaySystemSound (soundID1);

                _resultLabel.font = [UIFont systemFontOfSize:50.0];
                _resultLabel.text = textStr;

//            }
        });
        
        [_resultLabel startAnimation];

    }
    

}

#pragma - mark Ultity Methods
- (NSString *)replaceInputStrWithPassStr:(NSString *)inputStr {
    NSString *tempString = inputStr;
    //将字符串长度大于1的运算符换成单字符，以便后面的操作

    //替换根号符，由于除号编码超过了unichar，所以换成字母
    if (!([tempString rangeOfString:@"√"].location == NSNotFound)) {
        tempString = [tempString stringByReplacingOccurrencesOfString:@"√" withString:@"g"];
    }
    
    //替换除号，由于除号编码超过了unichar，所以换成字母
    if (!([tempString rangeOfString:@"÷"].location == NSNotFound)) {
        tempString = [tempString stringByReplacingOccurrencesOfString:@"÷" withString:@"d"];
    }

    return tempString;
}


#pragma mark --处理ASR语音对话节点
- (void)processASR:(NSDictionary*)asrDic {
    NSString *result  = [asrDic objectForKey:@"result"];
    if (result.length == 0) { //如果结果为空，则弹出警告框
        [self showAlert:@"没有接受到语音，请重新输入!"];
        return;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = [result stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉字符中间的空格
            NSLog(@"answer result = %@",str);
        });
    }
}

#pragma mark --olamidelegate error
- (void)onError:(NSError *)error {
    [self showAlert:@"网络超时，请重试!"];
    if (error) {
        NSLog(@"error is %@",error.localizedDescription);
    }
}

#pragma mark -- 录音结束
- (void)onEndOfSpeech {
    [_recordButton setImage:[UIImage imageNamed:@"话筒4.png"] forState:UIControlStateNormal];
    [_recordButton.layer removeAnimationForKey:@"aAlpha"];
}

#pragma mark --录音键
- (IBAction)recordButton:(UIButton *)sender {
    //设置为语音模式
    [_olamiRecognizer setInputType:0];
    
    //开始录音
    if (_olamiRecognizer.isRecording) {//isRecording = YES 即为录音模式
        [_olamiRecognizer stop];
        [_recordButton setImage:[UIImage imageNamed:@"话筒4.png"] forState:UIControlStateNormal];
        
    }else{
        [_olamiRecognizer start];
        
        [_recordButton setImage:[UIImage imageNamed:@"话筒7.png"] forState:UIControlStateNormal];
        [_recordButton.layer addAnimation:[self AlphaLight:0.5] forKey:@"aAlpha"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clear {
    _showTextView.text = @"";
    _resultLabel.text = @"";
    _passString = @"";
    _lastAnswer = @"";
}

- (void)save {
    if ([_showTextView.text isEqualToString:@""] || _resultLabel.text == nil) {
        [self showAlert:@"请输入内容后再保存哦"];
        return;
    }
    
    NSLog(@"save:%@",[_showTextView.text stringByAppendingString:_resultLabel.text]);
    Equation *equation = [[Equation alloc] init];
    equation.resultstr = [[_showTextView.text stringByAppendingString:_resultLabel.text] stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    equation.content = @"1";
    equation.equateID = [NSString stringWithFormat:@"%@%u",equation.resultstr,arc4random_uniform(1000) ];
    
    [[DataBaseManager shareDataBase] insertEquation:equation];
    _dataArr = [[DataBaseManager shareDataBase] getAllEquation];
    NSLog(@"arr=%@",_dataArr);
    
    //通知传值
    NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:_dataArr,@"arr", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"saveTongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self showAlert:@"已保存到我的收藏"];
}

//发光动画
- (CABasicAnimation *)AlphaLight:(float)time {
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//透明度
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

//提示框
- (void)showAlert:(NSString *)str {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:str
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:^{
        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    }];
}

- (IBAction)tapAction:(UIButton *)sender {
    
    long int tag = sender.tag;
    switch (tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        {

            if (_resultLabel.text != nil) {
                if (tag == 10 || tag == 11 || tag == 12 || tag == 13 || tag == 14) {
                    _showTextView.text = _resultLabel.text;
                    _showTextView.text = [_showTextView.text stringByAppendingString:sender.titleLabel.text];
                    _resultLabel.text = nil;

                } else {
                    _showTextView.text = nil;
                    _showTextView.text = [_showTextView.text stringByAppendingString:sender.titleLabel.text];
                    _resultLabel.text = nil;
                }
            }else{
                _showTextView.text = [_showTextView.text stringByAppendingString:sender.titleLabel.text];
            }
        }
            break;
        case 15:
        {
            //回退
            if (![_showTextView.text isEqual:@""]) {
                if (([_showTextView.text length] == 1)||[_showTextView.text isEqualToString: @"error"]) {
                    _showTextView.text = @"";
                }else{
                    _showTextView.text = [_showTextView.text substringToIndex:_showTextView.text.length -1];
                }
            }
        }
            break;
        case 16:
        {
            [self clear];
        }
            break;
        case 17:
        {
            [self save];
        }
            break;
        case 18:{
            if (_showTextView.text.length != 0) {
                NSLog(@"文本输入=%@",_showTextView.text);
                
                [_olamiRecognizer setInputType:1];//设置为文本输入
                [_olamiRecognizer sendText:[_showTextView.text stringByReplacingOccurrencesOfString:@"=" withString:@""]];
                //发送文本到服务器
                if (![_showTextView.text containsString:@"="]) {
                    _showTextView.text = [_showTextView.text stringByAppendingString:@"="];
                }
            }

        }
            break;
        default:
            break;
    }
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"historyTongzhi" object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chuanTongzhi" object:self];
}

@end
