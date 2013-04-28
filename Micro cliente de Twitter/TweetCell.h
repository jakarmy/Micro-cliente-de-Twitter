
#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *userName;
@property (nonatomic, retain) IBOutlet UILabel *userTwitter;
@property (nonatomic, retain) IBOutlet UILabel *comentTwitter;
@property (nonatomic, retain) IBOutlet UIImageView *userImage;
@property (nonatomic, retain) NSString *userImagePath;
@property (nonatomic, retain) IBOutlet UIImageView *userBackground;
@property (nonatomic, retain) NSString *userBackgroundPath;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@end
