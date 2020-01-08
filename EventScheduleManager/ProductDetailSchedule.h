//
//  ProductDetailSchedule.h
//  Platform
//
//  Created by sun!ng on 2019/11/26.
//  Copyright © 2019 sun!ng. All rights reserved.
//


// 2019-11-16 created by miaocf
// 管理事件并发队列

#import "EventScheduleManager.h"

// schedule arrangment

// 第一批次
extern NSString * _Nonnull const ProductDetailGetBasicInfo;          // 获取商品基本信息

// 第二批次
extern NSString * _Nonnull const ProductDetailGetSaleInfo;           // 获取商品销售信息
extern NSString * _Nonnull const ProductDetailItemUniqueInfo;        // 卖点，售后保障 图文详情

// 第二批次完成 刷新 UI 事件
extern NSString * _Nonnull const ProductDetailFirstStage;            // 第一阶段完成

// 第三批次

extern NSString * _Nonnull const ProductDetailLogistics;             // 物流时效
extern NSString * _Nonnull const ProductDetailFreightInfo;           // 运费

// 刷新 UI 事件
extern NSString * _Nonnull const ProductDetailSecondStage;            // 第二阶段完成

// 第四批次
extern NSString * _Nonnull const ProductDetailComments;              //评论
extern NSString * _Nonnull const ProductDetailRecommend;             //推荐品

NS_ASSUME_NONNULL_BEGIN

@interface ProductDetailSchedule : EventScheduleManager

// 商品详情页 事件 
- (void)createSchedule;

@end

NS_ASSUME_NONNULL_END
