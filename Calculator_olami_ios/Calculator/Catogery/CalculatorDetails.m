//
//  CalculatorDetails.m
//  Calculator
//
//  Created by Scarlett on 2017/7/18.
//  Copyright © 2017年 Scarlett Zhao. All rights reserved.
//

#import "CalculatorDetails.h"

@interface CalculatorDetails ()

@property (nonatomic,strong)NSMutableArray        *dealedArray;     //存储经过处理的表达式
@property (nonatomic,strong)NSDictionary          *opPriority;      //运算符优先级表
@property (nonatomic,strong)NSMutableArray        *brakectHandledArray;
@property BOOL brakectAfterSingle;

@end

@implementation CalculatorDetails
- (id)init {
    if (self =  [super  init]){
        _opPriority=@{@"(":@0, @"^":@1,@"√":@2,@"%":@2, @"x":@3,@"/":@3, @"+":@4, @"-":@4,@")":@5,  @"#": @6 };
    }
    _brakectAfterSingle = NO;
    return  self;
}

- (NSString*)calculatingWithString:(NSString *)str andAnswerString:(NSString *)answerString {
    if (_brakectAfterSingle) {
        _brakectHandledArray = [NSMutableArray arrayWithArray:_dealedArray];
    }
    
    [self handleInputString:str andAnswerString:answerString];
    
    [_dealedArray    addObject:@"#"];
    [_dealedArray   insertObject:@"#"atIndex:0];
    
    NSInteger   count = [_dealedArray  count];
    
    NSString *finalResult = [NSString  string];
    
    for (int i= (int)count - 2; i>= 0;i--) {
        NSString *str1 = [_dealedArray  objectAtIndex:i];
        if ([str1    isEqualToString:@"#"]) {
            finalResult = [_dealedArray   objectAtIndex:1];
            if ([_dealedArray   count]>3) {
                finalResult =@"error";
            }
            return finalResult;
        }
        
        if ([str1  isEqualToString:@"("]) {
            NSString *subResult = [NSString  string];
            for (NSInteger j = i + 1; j <= count - 1; j++)
            {
                NSString *str2 = [_dealedArray   objectAtIndex:j];
                
                //括号不匹配
                if ([str2   isEqualToString:@"#"]) {
                    finalResult =@"error";
                    return   finalResult;
                }
                
                if ([str2    isEqualToString:@")"])
                {
                    NSRange range =NSMakeRange(i+1, j-i-1);
                    //生成子数组，生成的子数组肯定不存在括号问题
                    NSArray *subArray = [_dealedArray   subarrayWithRange:range];
                    NSMutableArray *arr = [NSMutableArray    arrayWithArray:subArray];
                    subResult = [self calculateNumbers:arr];
                    if ([subResult    isEqualToString:@"error"]) {
                        finalResult =@"error";
                        return  finalResult;
                    }
                    //将返回结果代替表达式，包括括号一起代替
                    range =NSMakeRange(i,j - i +1);
                    [_dealedArray    replaceObjectsInRange:range
                                    withObjectsFromArray: [NSArray arrayWithObject:subResult]];
                    //代替之后，重新获取新表达式的count
                    count = [_dealedArray  count];
                    i = (int)count - 1 ;
                    break;
                }
            }
        }
    }
    return finalResult;   
}

- (void)handleInputString:(NSString *)inputStr andAnswerString:(NSString *)answerString {
    long int  length = [inputStr  length];
    _dealedArray =  [NSMutableArray array];
    int  i  =  0;
    UniChar c = [inputStr  characterAtIndex:0];
    if (c =='-'|| c == '+'||c == 'x'||c =='/'|| c== '^')
    {
        //如果新输入的是运算符，则在前面补上一次的答案(0或者其他值)
        if (length >1)
        {
            UniChar c1 = [inputStr  characterAtIndex:1];
            if (c1 >='0'&&c1 <= '9')
            {
                [_dealedArray addObject:answerString];
                [_dealedArray addObject:[NSString   stringWithCharacters:&c  length:1]];
                i++;
            }
        }
    }
    NSMutableString *mString = [NSMutableString  string];
    while (i< length)
    {
        c = [inputStr   characterAtIndex:i];
        if ((c >='0'&&c <= '9') || c =='.')
        {
            //遇到数字，就要读取整个数，包括小数点，读取完整后再存入数组中
            [mString  appendFormat:@"%c",c];
            if (i == length -1) {
                [_dealedArray addObject:mString];
                //读取数据完成之后，将mString重新初始化，即清空内容
                mString = [NSMutableString   string];
            }
        }
        else
        {
            if (![mString isEqualToString:@""]) {
                //将完整的数存放到数组中
                [_dealedArray  addObject:mString];
                mString = [NSMutableString  string];
            }
            if (c =='(')
            {
                if (i>0)
                {
                    UniChar xc = [inputStr   characterAtIndex:i-1];
                    if (xc >='0'&&xc <= '9') {
                        [_dealedArray   addObject:@"x"];
                        [_dealedArray   addObject:@"("];
                        i++;
                        continue;
                    }
                }
                if (i< length -1)
                    
                {
                    UniChar c1 = [inputStr  characterAtIndex:i+1];
                    if (c1 =='-'|| c1 == '+') {
                        [_dealedArray addObject:@"("];
                        [_dealedArray addObject:@"0"];
                        i++;
                        continue;
                    }
                }
            }
            else  if (c == ')')
            {
                if (i< length -1)
                {
                    UniChar xc = [inputStr   characterAtIndex:i + 1];
                    if (xc >='0'&&xc <= '9') {
                        [_dealedArray   addObject:@")"];
                        [_dealedArray  addObject:@"x"];
                        i++;
                        continue;
                    }
                }
            }
            else if (c == 'c' || c == 's'|| c == 't'|| c== 'e'||c == 'l'){
                NSString *tempStr = [NSString string];
                NSString *single = [NSString string];
                for (int j = i + 1; j < length ;j++ ) {
                    UniChar tempx = [inputStr characterAtIndex:j];
                    if ((tempx >='0'&&tempx <= '9') || tempx =='.') {
                       tempStr = [tempStr stringByAppendingString:[NSString stringWithFormat:@"%c",tempx]];
                    }else if (tempx == '('){
                        _brakectAfterSingle = YES;
                        NSString *string = [inputStr substringFromIndex:j];
                        for (int k = j+1; k < length; k++) {
                            
                            if ([string rangeOfString:@")"].location) {
                                int location = (int)[string rangeOfString:@")"].location;
                                NSRange range = NSMakeRange(0, location + 1);
                                string = [string substringWithRange:range];
                                single =string;
                                break;
                            }
                        }
                        tempStr = [self calculatingWithString:string andAnswerString:answerString];
                        _dealedArray = [NSMutableArray arrayWithArray:_brakectHandledArray];
                        break;
                    }
                    else
                        break;
                }
                if (tempStr.length >0 &&![tempStr isEqualToString:@"error"]) {
                    if (_brakectAfterSingle) {
                        i += single.length + 1;
                        _brakectAfterSingle = NO;
                    }else{
                        i = i + (int)[tempStr length] + 1;
                    }
                    double temp =[tempStr doubleValue];
                    switch (c) {
                            //cos
                        case 'c':
                            temp = cos(temp * M_PI/180.0);
                            break;
                            //sin
                        case 's':
                            temp = sin(temp * M_PI/180.0);
                            break;
                            //tan
                        case 't':
                            temp = tan(temp * M_PI/180.0);
                            break;
                            //log
                        case 'l':
                            temp = log10(temp);
                            break;
                            //ln
                        case 'e':
                            temp = log(temp);
                            break;
                        default:
                            break;
                    }
                    [_dealedArray addObject:[NSString stringWithFormat:@"%g",temp]];
                    continue;
                }
                
            }
            [_dealedArray addObject:[NSString stringWithCharacters:&c length:1] ];
        }
        i++;
    }
    [_dealedArray   insertObject:@"("atIndex:0];
    [_dealedArray   addObject:@")"];
    
}

//双目运算，父（子）级运算,即去除括号的
- (NSString *)calculateNumbersWithOperator:(NSString *)operator betweenDouble:(double)x1 andDoule:(double)x2 {
    double  aresult =0;
    unichar  ch = [operator  characterAtIndex:0];
    NSString *string = [NSString  string];
    BOOL   isOK = YES;
    switch (ch)
    {
        case '+':
            aresult = x1 + x2;
            break;
        case '-':
            aresult = x1 - x2;
            break;
        case 'x':
            aresult = x1 * x2;
            break;
            //开任意次根
        case 'g':
            if (x1 ==0){
                string =@"error";
                isOK =NO;
            }
            aresult = pow(x2, 1/x1);
            break;
            //
        case 'd':
            if (x2 ==0){
                string =@"error";
                isOK =NO;
            }
            aresult = x1 / x2;
            break;
            //求余数
        case '%':
            if (x2 ==0){
                string =@"error";
                isOK =NO;
            }
            aresult = fmod(x1, x2);
            break;
            //任意次方
        case '^':
            aresult = pow(x1, x2);
            break;
        default:
            isOK =NO;
            string =@"error";
            break;
    }
    if (isOK ==YES){
            string = [NSString stringWithFormat:@"%g",aresult];
    }
    return string;
}

- (NSString *)calculateNumbers:(NSMutableArray *)numberArray {
    NSMutableArray *operandStackArray = [NSMutableArray arrayWithObject:@"error"];
    NSMutableArray *stack2 = [NSMutableArray arrayWithObject:@"#"];
    
    NSString *result = [NSString string];
    
    [numberArray addObject:@"#"];
    
    while (1) {
        NSString *subStr1 = [numberArray    objectAtIndex:0];
        UniChar c = [subStr1   characterAtIndex:0];
        //如果是数据则添加到数据栈
        if ((subStr1.length > 1 && [subStr1 hasPrefix:@"-"])||(c >='0'&&c <= '9')) {
            //插到数据栈顶
            [operandStackArray insertObject:subStr1 atIndex:0];
            //元素每次进栈之后要在表达式数组中移除该元素
            [numberArray   removeObjectAtIndex:0];
        }
        else
        {
            //元素是运算符，则每次都要跟运算符栈的栈顶元素比较优先级
            NSString *topStack2 = [stack2   objectAtIndex:0];//取得运算符栈栈顶元素
            if ([subStr1   isEqualToString:@"#"] && [topStack2   isEqualToString:@"#"]){
                //当取得元素和栈顶元素都为#时，说明表达式运算结束，获取运算结果
                result = [operandStackArray  objectAtIndex:0];
                break;
            }
            //对取得的元素在优先级表中获取优先级
            NSInteger one = [[_opPriority objectForKey:subStr1]integerValue];
            //对栈顶元素在优先级表中获取优先级
            NSInteger two = [[_opPriority objectForKey:topStack2]integerValue];
            
            if (one < two) {
                //取得的运算符的优先级大于栈顶元素优先级时，该运算符直接进栈
                [stack2 insertObject:subStr1 atIndex:0];
                [numberArray   removeObjectAtIndex:0];
            }
            else
            {
                //优先级不大的时候，就要取栈顶运算符先进行运算
                //先取两个运算数，如果取到error说明，表达式输入不合法，直接终止循环
                NSString *strX = [operandStackArray  objectAtIndex:0];
                if ([strX   isEqualToString:@"error"]) {
                    result =@"error";
                    break;
                }
                double x1 = [strX  doubleValue];
                [operandStackArray removeObjectAtIndex:0];
                strX = [operandStackArray  objectAtIndex:0];
                if ([strX   isEqualToString:@"error"]) {
                    result =@"error";
                    break;
                }
                double x2 = [strX doubleValue];
                [operandStackArray removeObjectAtIndex:0];
                [stack2 removeObjectAtIndex:0];
                //计算结果
                result = [self calculateNumbersWithOperator:topStack2 betweenDouble:x2 andDoule:x1];
                if ([result   isEqualToString:@"error"]) {
                    //如果计算返回的结果是error说明输入的表达式不合法
                    break;
                }
                //返回合法结果，就将结果放进运算数栈，进行下一轮处理
                [operandStackArray insertObject:result atIndex:0];
                
            }
        }
    }
    return result;
}

@end
