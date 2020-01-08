//
//  EventScheduleManager.m
//  Platform
//
//  Created by sun!ng on 2019/11/26.
//  Copyright © 2019 sun!ng. All rights reserved.
//

#import "EventScheduleManager.h"

@implementation EventUnit

+ (instancetype)getEventWith:(NSString *)identifier eventMethod:(NSString *)methodName {
    
    EventUnit *event = [[EventUnit alloc] init];
    
    event.eventIdentifier = identifier;
    event.eventMethod = methodName;
    event.done = NO;
    
    return event;
}

@end

@implementation EventMark

+ (instancetype)getEventMarkWithEvents:(NSArray<EventUnit *> *)events {
    
    EventMark *eventMark = [[EventMark alloc] init];
    
    for (EventUnit *event in events) {
        [eventMark.events addObject:event];
    }
    
    return eventMark;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.events = [NSMutableSet setWithCapacity:1];
    }
    return self;
}

- (BOOL)finished {
    
    __block BOOL finished = YES;
    [self.events enumerateObjectsUsingBlock:^(EventUnit * _Nonnull obj, BOOL * _Nonnull stop) {
        finished = finished && obj.done;
    }];
    return finished;
}

@end

@interface EventScheduleManager ()

@property (nonatomic, strong) EventMark *currentEvents;

@end

@implementation EventScheduleManager

- (BOOL)isBusy {
    
    BOOL busy = NO;
    
    [self.lock lock];
    busy = (_currentEvents != nil);
    [self.lock unlock];
    
    return busy;
}

- (void)clearAllEvents {
    
    [self.lock lock];
    //遍历 移除
    while (_head) {
        EventMark *next = _head.nextPeriod;
        [_head.events removeAllObjects];
        _head = next; //最后一个元素自动置空
    }
    _tail = nil;
    _currentEvents = nil;
    [self.lock unlock];
}

// 取消
- (void)abortSchedule {
    
    if (_currentEvents) {
        
        [self clearAllEvents];
        
        if ([self.delegate respondsToSelector:@selector(scheduleAborted)]) {
            [self.delegate scheduleAborted];
        }
    }
}

- (void)didFinishedEvent:(NSString *)event {
    
    // 当前任务 不为空
    if (_currentEvents) {
        [self.lock lock];
        [self.currentEvents.events enumerateObjectsUsingBlock:^(EventUnit * _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj.eventIdentifier isEqualToString:event]) {
                obj.done = YES;
                *stop = YES;
            }
        }];
        [self.lock unlock];
        //执行下一个
        if ([self.currentEvents finished]){
            // 开始下一个事件
            [self start];
        }
    }
}

- (void)start {
    
    EventMark *events = [self pop];
    
    if (events) {
        
        [self excuteEvents:events];
        
    } else {
        // 所有事件执行完毕
        _currentEvents = nil;
        if ([self.delegate respondsToSelector:@selector(allEventsFinished)]) {
            [self.delegate allEventsFinished];
        }
    }
}
// 执行事件
- (void)excuteEvents:(EventMark *)events{
    [self.lock lock];
    self.currentEvents = events;
    if ([self.delegate respondsToSelector:@selector(arriveOnEventSchedule:)]) {
        [self.delegate arriveOnEventSchedule:events];
    }
    [self.lock unlock];
}

- (void)push:(EventMark *)eventMark {
    
    [self.lock lock];
    if (_head) {
        // 如不是空队列，添加到队尾
        _tail.nextPeriod = eventMark;
        _tail = eventMark;
    } else {
        //空队列， 第一个元素
        _head = eventMark;
        _tail = eventMark;
    }
    [self.lock unlock];
}

- (EventMark *)pop{
    
    if (_head) {
        [self.lock lock];
        // 移除队头
        EventMark *first = _head;
        _head = first.nextPeriod;
        
        first.nextPeriod = nil;
        
        [self.lock unlock];
        
        return first;
        
    } else {
        // 空队列，返回空
        return nil;
    }
}

- (void)resetAllEvents {
    [self.lock lock];
    EventMark *mark = _head;
    while (mark.nextPeriod != nil) {
        // 遍历重置
        [mark.events enumerateObjectsUsingBlock:^(EventUnit * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.done = NO;
        }];
        mark = mark.nextPeriod;
    }
    [self.lock unlock];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
    }
    return self;
}

@end
