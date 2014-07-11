//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alessandro on 06/07/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchMode; // Needed for TASK #3
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController

- (IBAction)sliderOverride:(UISlider *)sender
{
	[self updateUI];
}

- (IBAction)modeControl:(UIControl *)sender
{
	[self deal:sender];
}

- (IBAction)deal:(UIControl *)sender
{
	// TASK #2 of Assignment (#1 was to build the game as from the lectures)
	self.historySlider.enabled = NO;
	self.matchMode.enabled = YES;
	_game = nil;
	[self updateUI];
}

- (CardMatchingGame *)game
{
	if (!_game){
		int numberOfCards = self.matchMode.selectedSegmentIndex + 2;
		_game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
												  usingDeck:[self createDeck]
											       withMode:numberOfCards];
	}
	return _game;
}

- (Deck *)createDeck
{
	return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
	if (!self.historySlider.enabled) self.historySlider.enabled = YES;
	[self.historySlider setValue:self.historySlider.maximumValue
						animated:YES];
	self.matchMode.enabled = NO;
	int cardIndex = [self.cardButtons indexOfObject:sender];
	[self.game chooseCardAtIndex:cardIndex];
	[self updateUI];
}

- (void) updateUI
{
	for (UIButton *cardButton in self.cardButtons) {
		int cardIndex = [self.cardButtons indexOfObject:cardButton];
		Card * card = [self.game cardAtIndex:cardIndex];
		[cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
		[cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
		cardButton.enabled = !card.isMatched;
	}
	self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
	
	float sliderIndex = self.historySlider.value;
	int historyIndex = sliderIndex;
	if ([self.game.resultsHistory count] > 0) {
		historyIndex = (self.game.resultsHistory.count - 1) * sliderIndex;
		self.statusLabel.text = self.game.resultsHistory[historyIndex];
	} else {
		self.statusLabel.text = @"";
		[self.historySlider setValue:self.historySlider.maximumValue
							animated:YES];
	}
	
	if (self.historySlider.value != self.historySlider.maximumValue) {
		self.statusLabel.alpha = 0.5f;
	} else {
		self.statusLabel.alpha = 1.0f;
	}
}

- (NSString *)titleForCard:(Card *)card
{
	return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
	return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
