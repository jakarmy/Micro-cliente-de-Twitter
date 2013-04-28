
#import <UIKit/UIKit.h>

@interface DetailTweet : UIViewController{
    IBOutlet UILabel *userName;
    IBOutlet UILabel *userTwitter;
    IBOutlet UITextView *comentTwitter;
    IBOutlet UIImageView *userImage;
    IBOutlet UIView *border;
}
// Why not using ARC ??
@property (nonatomic,retain) NSString *userNametoDefine;
@property (nonatomic,retain) NSString *userTwittertoDefine;
@property (nonatomic,retain) NSString *comentTwittertoDefine;
@property (nonatomic,retain) UIImage *userImagetoDefine;
@property (nonatomic,retain) NSString *userImagePathtoDefine;
@property (nonatomic,retain) UIImage *userBackgroundtoDefine;
@property (nonatomic,retain) NSString *userBackgroudPathtoDefine;
-(void)back:(id)sender;
@end
