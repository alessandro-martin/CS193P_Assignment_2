//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Alessandro on 07/07/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype) initWithCardCount:(NSUInteger)count
						 usingDeck:(Deck *) deck
						  withMode:(NSUInteger)mode;

- (void) chooseCardAtIndex:(NSUInteger) index;
- (Card *) cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger mode;// TASK #3 how many cards can we match?
@property (nonatomic, strong) NSMutableArray *resultsHistory;
@end
