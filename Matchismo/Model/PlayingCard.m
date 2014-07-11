//
//  PlayingCard.m
//  Matchismo
//
//  Created by Alessandro on 06/07/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int) match:(NSArray *)otherCards
{
	int score = 0;
	int ranks = 0;
	int suits = 0;
	NSMutableArray *allCards = [NSMutableArray arrayWithArray:otherCards];
	[allCards insertObject:self atIndex:0];
	for (int i = 0; i < [allCards count] - 1; i++){
		for (int j = i + 1; j < [allCards count]; j++){
			Card *ci = allCards[i];
			Card *cj = allCards[j];
			if ([ci isKindOfClass:[PlayingCard class]] &&
				[cj isKindOfClass:[PlayingCard class]]){
				PlayingCard *card1 = (PlayingCard *) ci;
				PlayingCard *card2 = (PlayingCard *) cj;
				if ([card1.suit isEqualToString:card2.suit]){
					suits++;
				} else if (card1.rank == card2.rank){
					ranks++;
				}
			}
		}
	}
	score = 4 * ranks  + suits;
	
	return score;
}

- (NSString *)contents
{
	NSArray *rankStrings = [PlayingCard rankStrings];
	return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter !!!

+ (NSArray *)validSuits
{
	return @[@"♥️", @"♦️", @"♠️", @"♣️"];
}

- (void)setSuit:(NSString *)suit
{
	if ([[PlayingCard validSuits] containsObject:suit]) {
		_suit = suit;
	}
}

- (NSString *)suit
{
	return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
	return @[@"?", @"A", @"2", @"3", @"4",
			 @"5", @"6", @"7", @"8", @"9",
			 @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank { return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
	if (rank <= [PlayingCard maxRank]) {
		_rank = rank;
	}
}

@end
