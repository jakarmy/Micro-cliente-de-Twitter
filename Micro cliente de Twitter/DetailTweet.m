
#import "DetailTweet.h"

@interface DetailTweet ()

@end

@implementation DetailTweet
@synthesize userTwittertoDefine,userNametoDefine,userImagetoDefine,userImagePathtoDefine,comentTwittertoDefine,userBackgroundtoDefine,userBackgroudPathtoDefine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    border.layer.cornerRadius=5.0f;
    userName.text=userNametoDefine;
    userName.layer.cornerRadius=5.0f;
    userTwitter.text=userTwittertoDefine;
    userTwitter.layer.cornerRadius=5.0f;
    comentTwitter.text=comentTwittertoDefine;
    comentTwitter.layer.cornerRadius=5.0f;
    NSLog(@"%@",userImagePathtoDefine);
    CGImageRef cgref = [userImagetoDefine CGImage];
    if (userImagetoDefine  == nil && cgref == NULL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image= [self downloadImge:userImagePathtoDefine];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                userImage.image=image;
                
            });
        });
    }else{
        userImage.image=userImagetoDefine;
    }
    userImage.layer.cornerRadius=5.0f;
    
    
    cgref = [userBackgroundtoDefine CGImage];
    if (userBackgroundtoDefine  == nil && cgref == NULL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image= [self downloadImge:userBackgroudPathtoDefine];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                self.view.backgroundColor = [UIColor colorWithPatternImage:image];
                
            });
        });

    }else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:userBackgroundtoDefine];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*There's no need for this. It should have been implemented using segues in this case, since it's a simple back behavior.*/
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImage*)downloadImge: (NSString*)path{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    result = [UIImage imageWithData:data];
    
    return result;
}

@end
