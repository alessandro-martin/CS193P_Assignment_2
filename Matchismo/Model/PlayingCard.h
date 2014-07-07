//
//  PlayingCard.h
//  Matchismo
//
//  Created by Alessandro on 06/07/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;


@end
