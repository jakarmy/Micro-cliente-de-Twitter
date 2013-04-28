
#import <UIKit/UIKit.h>
#import "TweetCell.h"
#import "DetailTweet.h"
#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView *table;
    UIActivityIndicatorView *activity;
    UIView *viewActivity;
}
@property (strong, nonatomic) NSMutableArray *dataSource;
@end
