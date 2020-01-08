//
//  ProductDetailSchedule.m
//  Platform
//
//  Created by sun!ng on 2019/11/26.
//  Copyright © 2019 sun!ng. All rights reserved.
//

#import "ProductDetailSchedule.h"

// 第一批次
NSString * const ProductDetailGetBasicInfo         = @"ProductDetailGetBasicInfo";          // 获取商品基本信息

// 第二批次
NSString * const ProductDetailGetSaleInfo          = @"ProductDetailGetSaleInfo";           // 获取商品销售信息
NSString * const ProductDetailItemUniqueInfo       = @"ProductDetailItemUniqueInfo";        // 卖点，售后保障 图文详情

// 第三批次
NSString * const ProductDetailLogistics            = @"ProductDetailLogistics";             //物流时效
NSString * const ProductDetailFreightInfo          = @"ProductDetailFreightInfo";           // 运费

// 第四批次
NSString * const ProductDetailComments             = @"ProductDetailComments";              //评论
NSString * const ProductDetailRecommend            = @"ProductDetailRecommend";             //推荐品

NSString * const ProductDetailFirstStage           = @"ProductDetailFirstStage";            // 第一阶段完成
NSString * const ProductDetailSecondStage          = @"ProductDetailSecondStage";           // 第二阶段完成

@implementation ProductDetailSchedule


- (void)createSchedule {
    // 清空
    [self clearAllEvents];
    
    //第一阶段
    EventUnit *unit_1 = [EventUnit getEventWith:ProductDetailGetBasicInfo eventMethod:@"ProductBasicInfo"];

    EventMark *mark_1 = [EventMark getEventMarkWithEvents:@[unit_1]];
    mark_1.name = @"第一阶段";
    
    [self push:mark_1];
    
    
    //第二阶段
    EventUnit *unit_2 = [EventUnit getEventWith:ProductDetailGetSaleInfo eventMethod:@"ProductSaleInfo"];
    EventUnit *unit_4 = [EventUnit getEventWith:ProductDetailItemUniqueInfo eventMethod:@"ItemUniqueInfo"];

    EventMark *mark_2 = [EventMark getEventMarkWithEvents:@[unit_2,unit_4]];
    mark_2.name = @"第二阶段";
    
    [self push:mark_2];
    
    // 第一个 milestone 完成
    EventUnit *first = [EventUnit getEventWith:ProductDetailFirstStage eventMethod:@"fistStageFinished"];
    
    EventMark *firstMileStone = [EventMark getEventMarkWithEvents:@[first]];
    firstMileStone.name = @"firstMileStone";
    
    [self push:firstMileStone];
    
    //第三阶段
    EventUnit *unit_8 = [EventUnit getEventWith:ProductDetailLogistics eventMethod:@"LogisticsInfo"];
    EventUnit *unit_9 = [EventUnit getEventWith:ProductDetailFreightInfo eventMethod:@"FreightInfo"];

    EventMark *mark_3 = [EventMark getEventMarkWithEvents:@[unit_8,unit_9]];
    mark_3.name = @"第三阶段";
    
    [self push:mark_3];
    
    // 第二个 milestone 完成
    EventUnit *second = [EventUnit getEventWith:ProductDetailSecondStage eventMethod:@"secondStageFinished"];
    
    EventMark *secondMileStone = [EventMark getEventMarkWithEvents:@[second]];
    secondMileStone.name = @"secondMileStone";
    
    [self push:secondMileStone];
    
    //第四阶段
    EventUnit *unit_10 = [EventUnit getEventWith:ProductDetailRecommend eventMethod:@"RecommendInfo"];
    EventUnit *unit_13 = [EventUnit getEventWith:ProductDetailComments eventMethod:@"CommentsInfo"];

    EventMark *mark_4 = [EventMark getEventMarkWithEvents:@[unit_10,unit_13]];
    mark_4.name = @"第四阶段";
    
    [self push:mark_4];
}

@end
