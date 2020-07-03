//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by zurken on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *retweets;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // getting profile picture from api and setting it in the table cell
    NSURL *profileURL = [NSURL URLWithString:self.tweet.user.profileImageURL];
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:profileURL];
    
    self.name.text = self.tweet.user.name;
    self.screenName.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.tweetText.text = self.tweet.text;
    self.date.text = self.tweet.createdAtString;
    self.retweets.text = [NSString stringWithFormat:@"%d Retweets", self.tweet.retweetCount];
    self.likes.text = [NSString stringWithFormat:@"%d Likes", self.tweet.favoriteCount];
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
    self.retweets.text = [NSString stringWithFormat:@"%d Retweets", self.tweet.retweetCount];
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
       self.likes.text = [NSString stringWithFormat:@"%d Likes", self.tweet.favoriteCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
