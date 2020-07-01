//
//  TweetCell.m
//  twitter
//
//  Created by zurken on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.name.text = tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    self.text.text = tweet.text;
    self.createdAt.text = tweet.createdAtString;
    self.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    self.likeCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
    // getting profile picture from api and setting it in the table cell
    NSURL *profileURL = [NSURL URLWithString:tweet.user.profileImageURL];
    self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL:profileURL];
}

- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO) { // tweet has not been retweeted
        self.tweet.retweeted = YES;
        self.retweetButton.selected = YES;
        self.tweet.retweetCount++;
        
        NSString *urlStr = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.tweet.idStr];
        [[APIManager shared] postRetweetFavorite:self.tweet urlString:urlStr completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
        }];
    }
    else { // tweet was already retweeted
        self.tweet.retweeted = NO;
        self.retweetButton.selected = NO;
        self.tweet.retweetCount--;
        
        NSString *urlStr = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", self.tweet.idStr];
        [[APIManager shared] postRetweetFavorite:self.tweet urlString:urlStr completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error UN-retweeting: %@", error.localizedDescription);
            }
        }];
    }
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
}

- (IBAction)didTapFavorite:(id)sender {
    if (self.tweet.favorited == NO) { // tweet has not been liked
        self.tweet.favorited = YES;
        self.likeButton.selected = YES;
        self.tweet.favoriteCount++;
        
        [[APIManager shared] postRetweetFavorite:self.tweet urlString:@"1.1/favorites/create.json" completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
        }];
    }
    else { // tweet was already liked
        self.tweet.favorited = NO;
        self.likeButton.selected = NO;
        self.tweet.favoriteCount--;
        
        [[APIManager shared] postRetweetFavorite:self.tweet urlString:@"1.1/favorites/destroy.json" completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error UN-favoriting tweet: %@", error.localizedDescription);
            }
        }];
    }
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
}

@end
