//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Alessandro on 07/07/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *) cards
{
	if (!_cards) _cards = [[NSMutableArray alloc] init];
	return _cards;
}

- (instancetype) initWithCardCount:(NSUInteger)count
						 usingDeck:(Deck *)deck
{
	self = [super init];
	
	if (self) {
		for (int i = 0; i < count; i++) {
			Card *card = [deck drawRandomCard];
			if (card) {
				[self.cards addObject:card];
			} else {
				self = nil;
				break;
			}
		}
	}
	
	return self;
}

- (instancetype) init
{
	return nil;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
	return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void) chooseCardAtIndex:(NSUInteger)index
{
	Card *card = [self cardAtIndex:index];
	if (!card.isMatched) {
		if (card.isChosen) {
			card.chosen = NO;
		} else {
			// match against another card
			for (Card *otherCard in self.cards) {
				if (otherCard.isChosen && !otherCard.isMatched){
					int matchScore = [card match:@[otherCard]];
					if (matchScore) {
						self.score += matchScore * MATCH_BONUS;
						card.matched = YES;
						otherCard.matched = YES;
					} else {
						self.score -= MISMATCH_PENALTY;
						otherCard.chosen = NO;
					}
					break; // if match found we break, work done
				}
			}
			self.score -= COST_TO_CHOOSE;
			card.chosen = YES;
		}
	}
}
@end
