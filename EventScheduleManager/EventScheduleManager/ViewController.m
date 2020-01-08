//
//  ViewController.m
//  EventScheduleManager
//
//  Created by sun!ng on 2020/1/8.
//  Copyright © 2020 Personal. All rights reserved.
//

#import "ViewController.h"
#import "ProductDetailSchedule.h"

@interface ViewController ()<EventScheduleDelegate>

@property (nonatomic) UITextView *resultTextView;

@property (nonatomic, strong) ProductDetailSchedule *scheduleManager;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239.f/255 green:239.f/255 blue:244.f/255 alpha:1];
    [self.view addSubview:self.resultTextView];
    
    self.scheduleManager = [[ProductDetailSchedule alloc] init];
    self.scheduleManager.delegate = self;
    // 创建队列
    [self.scheduleManager createSchedule];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.resultTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.scheduleManager start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.resultTextView removeObserver:self forKeyPath:@"contentSize"];
    self.resultTextView.text = @"";
}

#pragma mark - EventScheduleDelegate 

// 执行一批事件
- (void)arriveOnEventSchedule:(EventMark *)events{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== %@ ====",events.name]];
    [events.events enumerateObjectsUsingBlock:^(EventUnit * _Nonnull obj, BOOL * _Nonnull stop) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
            [NSThread sleepForTimeInterval:1];
            [self appendLog:[NSString stringWithFormat:@"\n==== %@ \n==== %@ ",obj.eventIdentifier, obj.eventMethod]];

            SEL selector = NSSelectorFromString(obj.eventMethod);
            if ([self respondsToSelector:selector]) {
                
                IMP imp = [self methodForSelector:selector];
                void (*func)(id, SEL) = (void *)imp;
                func(self, selector);
            }
        });
    }];
}

 // 所有事件完成
- (void)allEventsFinished{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== allEventsFinished ====\n"]];
}

- (void)scheduleAborted{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== scheduleAborted ====\n"]];
}



- (void)ProductBasicInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== ProductBasicInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailGetBasicInfo];
}

- (void)ProductSaleInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== ProductSaleInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailGetSaleInfo];
}

- (void)ItemUniqueInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== ItemUniqueInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailItemUniqueInfo];
}

- (void)fistStageFinished{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== fistStageFinished 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailFirstStage];
}


- (void)LogisticsInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== LogisticsInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailLogistics];
}
- (void)FreightInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== FreightInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailFreightInfo];
}

- (void)secondStageFinished{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== secondStageFinished 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailSecondStage];
}


- (void)RecommendInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== RecommendInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailRecommend];
}

- (void)CommentsInfo{
    
    [self appendLog:[NSString stringWithFormat:@"\n==== CommentsInfo 执行完毕 ====\n"]];

    [self.scheduleManager didFinishedEvent:ProductDetailComments];
}


#pragma mark - 日志输出
- (void)appendLog:(NSString *)log{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *currentLog = self.resultTextView.text;
        if (currentLog.length) {
            currentLog = [currentLog stringByAppendingString:log];
        } else {
            currentLog = log;
        }
        self.resultTextView.text = currentLog;
    });
}

- (UITextView *)resultTextView{
    if (!_resultTextView) {
        NSInteger padding = 20;
        NSInteger viewWith = self.view.frame.size.width;
        NSInteger viewHeight = self.view.frame.size.height - 64;
        _resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, padding + 64, viewWith - padding * 2, viewHeight - padding * 2)];
        _resultTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _resultTextView.layer.borderWidth = 1;
        _resultTextView.editable = NO;
        _resultTextView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _resultTextView.font = [UIFont systemFontOfSize:14];
        _resultTextView.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _resultTextView.contentOffset = CGPointZero;
        _resultTextView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _resultTextView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSInteger contentHeight = self.resultTextView.contentSize.height;
        NSInteger textViewHeight = self.resultTextView.frame.size.height;
        [self.resultTextView setContentOffset:CGPointMake(0, MAX(contentHeight - textViewHeight, 0)) animated:YES];
    }
}

@end
