//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *tweetsArray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
//            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetsArray = (NSMutableArray *) tweets;
//            for (NSDictionary *dictionary in tweets) {
//               [self.tweetsArray addObject:dictionary];
//                NSString *text = dictionary[@"text"];
//                NSLog(@"%@", text);
//            }
//            NSLog(@"here");
            for (Tweet *tweet in self.tweetsArray) {
                NSLog(@"%@", tweet.text);
            }
//            NSLog(@"down here");
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"went in");
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    Tweet *tweet = self.tweetsArray[indexPath.row];

    cell.tweet = tweet;
    cell.name.text = tweet.user.name;
    cell.screenName.text = tweet.user.screenName;
    cell.text.text = tweet.text;
    cell.createdAt.text = tweet.createdAtString;
    cell.retweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.likeCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    
//    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
//    NSString *posterURLString = [baseURLString stringByAppendingString:movie[@"poster_path"]];
//    NSURL *posterURL = [NSURL URLWithString:posterURLString];
//    cell.moviePosterView.image = nil;
//    [cell.moviePosterView setImageWithURL:posterURL];

    return cell;
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
