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

- (NSMutableArray *) resultsHistory
{
	if (!_resultsHistory) _resultsHistory = [[NSMutableArray alloc] init];
	return _resultsHistory;
}

- (instancetype) initWithCardCount:(NSUInteger)count
						 usingDeck:(Deck *)deck
						  withMode:(NSUInteger)mode
{
	self = [super init];
	
	if (self &&  (mode > 1 && mode <= count)) {
		self.mode = mode;
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
	int matchScore = 0;
	
	NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
	// Every chosen card except for the currently selected card
	for (Card *otherCard in self.cards) {
		if (otherCard.isChosen && !otherCard.isMatched && otherCard != card){
			[chosenCards addObject:otherCard];
		}
	}

	if (!card.isMatched) {
		if (card.isChosen) {
			card.chosen = NO;
		} else {
			// match against other cards
				if ([chosenCards count] == self.mode -1){
				matchScore = [card match:chosenCards];
				if (matchScore) {
					self.score += matchScore * MATCH_BONUS;
					card.matched = YES;
					for (Card *c in chosenCards){
						c.matched = YES;
					}
				} else {
					self.score -= MISMATCH_PENALTY;
					for (Card *c in chosenCards){
						c.chosen = NO;
					}
				}
			}
			self.score -= COST_TO_CHOOSE;
			card.chosen = YES;
		}
	}
	[self updateResultHistoryWithCard:card
					      chosenCards:chosenCards
					    andMatchScore:matchScore];
}

- (void) updateResultHistoryWithCard:(Card *) card
					     chosenCards:(NSArray *) chosenCards
					   andMatchScore:(int) matchScore
{
	__block NSString *result =
	card.isChosen ? [NSString stringWithString:card.contents] : @"";
	[chosenCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		Card *c = (Card *) obj;
		result = [result stringByAppendingString:c.contents];
	}];
	
	if (matchScore) {
		result = [NSString stringWithFormat:@"Matched %@ for %d points.",
				  result, matchScore];
	} else if ([chosenCards count] == self.mode - 1) {
		result = [NSString stringWithFormat:@"%@ don't match! %d point penalty!",
				  result, MISMATCH_PENALTY];
	}
	[self.resultsHistory addObject:result];
}

@end