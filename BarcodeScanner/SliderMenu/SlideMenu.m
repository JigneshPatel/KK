//
//  SlideMenu.m


#import "SlideMenu.h"
#import "Constant.h"
#import "CreateReportVC.h"
#import "NVSlideMenuController.h"
#import "ContactVC.h"
#import "CreateReportVC.h"
#import "SignUpVC.h"
#import "ZViewController.h"
#import "ViewController.h"
#import "HotAlertsVC.h"
#import "igViewController.h"
#import "WEViewController.h"
#import "MyReportsVC.h"
#import "KnowledgeVC.h"
#import "MyAccountVC.h"
#import "HomeViewController.h"
#import "LocateUsViewController.h"
#import "DiscoverViewController.h"
#import "MainHomeViewController.h"

@interface SlideMenu ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *array_menuitems;
    UIStoryboard *storyboard ;
}

@end

@implementation SlideMenu
AppDelegate *delegate;

@synthesize tabelview_out;


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark FOR LEFT MENU ITEM

- (void)handlePan {
    
    if (!look)
    {
        [self.slideMenuController openMenuAnimated:YES completion:nil];
        
    }
    
    else
    {
        [self.slideMenuController closeMenuAnimated:YES completion:nil];
    }
    
    
    look=!look;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadTable];
}

-(void)loadTable
{
    [array_menuitems removeAllObjects];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kLoggedInUserId] length] ==0)
    {
        NSDictionary *dictData = @{@"title" : @"Scan", @"subtitle" : @"Scan Qr Code", @"image" : @"Scan@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Home", @"subtitle" : @"Home screen", @"image" : @"home@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Discover", @"subtitle" : @"Search our products", @"image" : @"Discover@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Notifications", @"subtitle" : @"Hot alerts", @"image" : @"Notifications@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Sign In", @"subtitle" : @"Sign in to our app", @"image" : @"Sign In.png"};
        [array_menuitems addObject:dictData];
        
        
        dictData = @{@"title" : @"Share", @"subtitle" : @"Share our app with others", @"image" : @"sharemenu@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Locate Us", @"subtitle" : @"Locate Us", @"image" : @"sharemenu@2x.png"};
        [array_menuitems addObject:dictData];
        
    }
    else
    {
        NSDictionary *dictData = @{@"title" : @"Scan", @"subtitle" : @"Scan Qr Code", @"image" : @"Scan@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Home", @"subtitle" : @"Home screen", @"image" : @"home@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Discover", @"subtitle" : @"Search our products", @"image" : @"Discover@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Notifications", @"subtitle" : @"Hot alerts", @"image" : @"Notifications@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Create", @"subtitle" : @"Create new report", @"image" : @"Create.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"My Library", @"subtitle" : @"My reports", @"image" : @"My Library@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Knowledge Library", @"subtitle" : @"Library", @"image" : @"Knowledge Library.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"My Account", @"subtitle" : @"Member account details", @"image" : @"Myaccount@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Share", @"subtitle" : @"Share our app with others", @"image" : @"sharemenu@2x.png"};
        [array_menuitems addObject:dictData];
        
        dictData = @{@"title" : @"Locate Us", @"subtitle" : @"Locate Us", @"image" : @"sharemenu@2x.png"};
        [array_menuitems addObject:dictData];
    }
    
    
    [tabelview_out setBackgroundColor:[UIColor colorWithRed:26.0/255.0f green:27.0/255.0f blue:32.0/255.0f alpha:1.0]];
    [tabelview_out reloadData];
    
}

- (void)viewDidLoad
{
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan)];
    [panGesture setDelegate:self];
    
    /* set no of touch for pan gesture*/
    
    [panGesture setMaximumNumberOfTouches:1];
    
    /*  Add gesture to your image. */
    
    [self.view addGestureRecognizer:panGesture];
    
    
    self.slideMenuController.panGestureEnabled = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate= (AppDelegate *)[[UIApplication sharedApplication]delegate];

    self.title=@"Kalara Oil";
    
    [self.navigationController setNavigationBarHidden:YES];
    
    array_menuitems = [[NSMutableArray alloc] init];
    
    //Static Data
    
    NSLog(@"delegate.strUserId %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"users_id"]);
    
   
}


#pragma mark Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// for no. of rows in section

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section{
    return [array_menuitems count];
}


//for each cell in section

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    //initalization of cell
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             nil];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    //for cell label
    
    NSDictionary *dict = [array_menuitems objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    [cell.textLabel setText:dict[@"title"]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    [cell.detailTextLabel setText:dict[@"subtitle"]];
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];

    [cell.imageView setImage:[UIImage imageNamed:dict[@"image"]]];

    
    //hoverbg@2x.png
    //cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:247.0/255.0f green:104.0/255.0f blue:84.0/255.0f alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
   
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kLoggedInUserId] length] ==0)
    {
        if (indexPath.row==0)//Scan
        {
            NSLog(@"Scan");
            delegate.intScanStatus = 1;

            storyboard = [AppDelegate storyBoardType];
            ZViewController *objView = (ZViewController*)[storyboard instantiateViewControllerWithIdentifier:@"BarViewControllerId"];
            
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
            [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
            
        }
        else if (indexPath.row==1)//Home
        {
            NSLog(@"Home");
            
            storyboard = [AppDelegate storyBoardType];
            MainHomeViewController *objView = (MainHomeViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainHomeViewControllerId"];
            
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
            [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
        }
        else if (indexPath.row==2)//Discover
        {
            NSLog(@"Discover");
            storyboard = [AppDelegate storyBoardType];
            DiscoverViewController *objView = (DiscoverViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DiscoverViewControllerId"];
            
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
            [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
        }
        else if (indexPath.row==3)//Notification
        {
            NSLog(@"Notification");

            storyboard = [AppDelegate storyBoardType];
            HotAlertsVC *objView = (HotAlertsVC*)[storyboard instantiateViewControllerWithIdentifier:@"HotAlertsVCId"];
            
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
            [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
        }
        else if (indexPath.row==4)//sign
        {
            NSLog(@"sign");

            storyboard = [AppDelegate storyBoardType];
            ViewController *objView = (ViewController*)[storyboard instantiateViewControllerWithIdentifier:@"ViewControllerId"];
            
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
            [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
            
            
        }
        else if (indexPath.row==5)//Share
        {
            NSLog(@"Share");
            [self shareIt];

        }
        else if (indexPath.row==6)//Share
        {
            NSLog(@"Share");
            storyboard = [AppDelegate storyBoardType];
            LocateUsViewController *objView = (LocateUsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LocateUsViewControllerId"];
            
            UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
            [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
            
        }

    }
    else
    {
    if (indexPath.row==0)//Scan
    {
        NSLog(@"Scan");
        delegate.intScanStatus = 1;
        
        storyboard = [AppDelegate storyBoardType];
        ZViewController *objView = (ZViewController*)[storyboard instantiateViewControllerWithIdentifier:@"BarViewControllerId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
        
    }
    else if (indexPath.row==1)//Home
    {
        NSLog(@"Home");
        
        storyboard = [AppDelegate storyBoardType];
        MainHomeViewController *objView = (MainHomeViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainHomeViewControllerId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row==2)//Discover
    {
        NSLog(@"Discover");
        storyboard = [AppDelegate storyBoardType];
        DiscoverViewController *objView = (DiscoverViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DiscoverViewControllerId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row==3)//Hot alerts
    {
        NSLog(@"Notification");
        storyboard = [AppDelegate storyBoardType];
        HotAlertsVC *objView = (HotAlertsVC*)[storyboard instantiateViewControllerWithIdentifier:@"HotAlertsVCId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row==4)//Create
    {
        NSLog(@"Create");
        delegate.intScanStatus = 2;
        
        storyboard = [AppDelegate storyBoardType];
        ZViewController *objView = (ZViewController*)[storyboard instantiateViewControllerWithIdentifier:@"BarViewControllerId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row==5)//My Reports
    {
        NSLog(@"My Reports");
        storyboard = [AppDelegate storyBoardType];
        MyReportsVC *objView = (MyReportsVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyReportsVCId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
    }
    else if (indexPath.row==6)//KL
    {//Knowledge
        
        storyboard = [AppDelegate storyBoardType];
        KnowledgeVC *objView = (KnowledgeVC*)[storyboard instantiateViewControllerWithIdentifier:@"KnowledgeVCId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
        
    }
    else if (indexPath.row==7) {//MyACcount
        
        storyboard = [AppDelegate storyBoardType];
        MyAccountVC *objView = (MyAccountVC*)[storyboard instantiateViewControllerWithIdentifier:@"MyAccountVCId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];
        
    }

    else if (indexPath.row==8)//Share
    {
        NSLog(@"Share");
        [self shareIt];
    }
    else if (indexPath.row==9)//map
    {
        NSLog(@"map");
        storyboard = [AppDelegate storyBoardType];
        LocateUsViewController *objView = (LocateUsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"LocateUsViewControllerId"];
        
        UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:objView];
        [self.slideMenuController closeMenuBehindContentViewController:nav animated:YES completion:nil];

    }
    }
    
}

-(void)shareIt
{
    
    NSArray *activityItems= [NSArray arrayWithObjects:@"Share your experience with friends!", nil];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [activityVC setValue:@"Try out the Kalara Oil app" forKey:@"subject"];
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed)
     {
         NSLog(@"Activity = %@",activityType);
         NSLog(@"Completed Status = %d",completed);
         
         if (completed)
         {
             
             UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:Nil message:@"Successfully Shared" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [objalert show];
             objalert = nil;
         }
         else
         {
             
             UIAlertView *objalert = [[UIAlertView alloc]initWithTitle:Nil message:@"Unable To Share" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [objalert show];
             objalert = nil;
             
         }
     }];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
