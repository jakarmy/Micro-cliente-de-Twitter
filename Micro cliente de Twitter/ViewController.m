
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize dataSource;
- (void)viewDidLoad
{
    [super viewDidLoad];
    //This could be done on IB. Also, calling viewDidAppear is NOT recommended as the selector of method. It doesn't encapsulate behavior properly. Wouldn't I want to put write that code on viewWillAppear anyway?
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewDidAppear:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void) viewDidAppear:(BOOL)animated{
    /////
    /*Ok, so this "activity indicator message" should be in a seperate class that encapsulates the behavior.
     That way, if I change the way my app shows a "loading view", I don't have to rewrite the code everywhere.
     This shouldn't be responsability of this class. This represents extra work, which btw, gets called everytime
     the view appears. Besides the fact that this should be a seperate class, IT SHOULD BE ADDED AS SUBVIEW ONCE,
     AND THEN TOGGLE THE ALPHA VALUE. This is much better than allocating views all the time*/
    viewActivity = [[UIView alloc]initWithFrame:CGRectMake(90, 150, 150, 100)];
    viewActivity.backgroundColor = [UIColor blackColor];
    viewActivity.layer.cornerRadius = 8;
    activity = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50, 10, 50, 50)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    UILabel *lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(20, 65,140, 20)];
    [lblStatus setTextColor:[UIColor whiteColor]];
    [lblStatus setBackgroundColor:[UIColor clearColor]];
    [lblStatus setFont:[UIFont systemFontOfSize:14]];
    [lblStatus setText:@"Loading..."];
    [viewActivity addSubview:activity];
    [viewActivity addSubview:lblStatus];
    [self.view addSubview:viewActivity];
    [activity startAnimating];
    
    //////
    /*The data source and delegate should be set once on viewDidLoad. This is unnecessary.*/
    table.dataSource = self;
    table.delegate = self;
    [self getTimeLine];
    [super viewDidAppear:animated];
}
- (void)getTimeLine {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];

             //if ([arrayOfAccounts count]) --> Convention
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount = [arrayOfAccounts lastObject];

                 /*Ok, so all parameters should be set in a seperate file (say constants.h) where I can easily
                  change this values for the entire app*/
                 NSURL *requestURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
                 
                 NSMutableDictionary *parameters =
                 [[NSMutableDictionary alloc] init];
                 [parameters setObject:@"20" forKey:@"count"];
                 [parameters setObject:@"1" forKey:@"include_entities"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:parameters];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      self.dataSource = [NSJSONSerialization
                                         JSONObjectWithData:responseData
                                         options:NSJSONReadingMutableLeaves
                                         error:&error];
                      
                      if (self.dataSource.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [table reloadData];
                              [table setHidden:NO];
                              [activity stopAnimating];
                              [viewActivity removeFromSuperview];

                          });
                      }
                  }];
             }
         } else {
         }
     }];
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"TweetCell";
    /*I don't believe it's necessary to implement a custom class for a cell that only has custom controls.
     Custom class is justified when you want to add custom behavior.*/
    TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TweetCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
     NSDictionary *tweet = dataSource[[indexPath row]];
    NSDictionary *user=[tweet objectForKey:@"user"];
    
    cell.comentTwitter.text= tweet[@"text"];
    cell.userName.text= user[@"name"] ;
    cell.userTwitter.text=[NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    cell.userImagePath=user[@"profile_image_url_https"];
    cell.userBackgroundPath=user[@"profile_background_image_url"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image= [self downloadImge:user[@"profile_image_url_https"]];
        UIImage *imageBackgroud= [self downloadImge:user[@"profile_background_image_url"]];
        dispatch_async(dispatch_get_main_queue(), ^{

            cell.userImage.image=image;
            cell.userBackground.image=imageBackgroud;
            cell.userImage.layer.cornerRadius=5.0f;
            cell.userImage.layer.borderWidth = 1.0;
            cell.userImage.layer.borderColor = [[UIColor grayColor] CGColor];
            [cell.activity stopAnimating];
            [cell.activity setHidden:YES];

        });
    });
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard=self.storyboard;
    TweetCell *content = (TweetCell *)[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row] inSection:0]] ;
    
    DetailTweet *detailTweet= (DetailTweet*)[storyboard instantiateViewControllerWithIdentifier:@"DetailTweet"];
    detailTweet.userNametoDefine=content.userName.text;
    detailTweet.userTwittertoDefine=content.userTwitter.text;
    detailTweet.comentTwittertoDefine=content.comentTwitter.text;
    detailTweet.userImagetoDefine=content.userImage.image;
    detailTweet.userImagePathtoDefine=content.userImagePath;
    detailTweet.userBackgroundtoDefine=content.userBackground.image;
    detailTweet.userBackgroudPathtoDefine=content.userBackgroundPath;
    [self.navigationController pushViewController:detailTweet animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 101;
}

-(UIImage*)downloadImge: (NSString*)path{
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    result = [UIImage imageWithData:data];
    
    return result;
}



@end
