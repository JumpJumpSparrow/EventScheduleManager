//
//  EventScheduleManager.h
//  Platform
//
//  Created by sun!ng on 2019/11/26.
//  Copyright © 2019 sun!ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 2019-11-26 created by miaocf
 * 将事件集合按序 批量执行，每个阶段可 并发一批无序事件，当本阶段事件都完成后，执行下一批。
 */
@class EventMark;

@protocol EventScheduleDelegate <NSObject>

- (void)arriveOnEventSchedule:(EventMark *)events; // 执行一批事件

- (void)allEventsFinished;                           // 所有事件完成

- (void)scheduleAborted;                             // 队列取消
@end

@interface EventUnit : NSObject

@property (nonatomic, copy) NSString *eventIdentifier;  // 事件标识符
@property (nonatomic, copy) NSString *eventMethod;      // 事件方法
@property (nonatomic, assign) BOOL done;                // 事件是否完成

//获取事件实例
+ (instancetype)getEventWith:(NSString *)identifier eventMethod:(NSString *)methodName;

@end

@interface EventMark : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableSet <EventUnit *>*events;
@property (nonatomic, strong) EventMark * _Nullable nextPeriod;

- (BOOL)finished; //当前阶段的事件是否完成

+ (instancetype)getEventMarkWithEvents:(NSArray <EventUnit *>*)events;

@end

/*
 注意事项：
 1. 在当前 schedule 执行完毕之前，尽量不要开启新的 schedule, 否则可能会产生不可预知的后果
 2. 如果需要 开启新的 schedule， 尽量保证 之前的 schedule 的事件都已完成或者取消
 3. 每个事件都 ==/ 必须有完成回调 ‘didFinishedEvent:’ /==，否则 会阻塞在 未回调的事件上 ！！！！！
 */

@interface EventScheduleManager : NSObject

@property (nonatomic, strong) EventMark * _Nullable head;    // 队列头
@property (nonatomic, strong) EventMark * _Nullable tail;    // 队尾
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, weak) id<EventScheduleDelegate> delegate;


- (void)push:(EventMark *)eventMark;  // 入队列,添加到队尾
- (EventMark *)pop;                   // 出队列，拿到队列第一个元素
- (void)start;
- (void)resetAllEvents;                 // 重置所有事件
- (void)clearAllEvents;                 // 清理所有事件
- (void)abortSchedule;                  // 取消执行

// 在所有操作完毕后 再调用这个方法
- (void)didFinishedEvent:(NSString *)event;

// 当前是否有任务在执行
- (BOOL)isBusy;

@end

NS_ASSUME_NONNULL_END
