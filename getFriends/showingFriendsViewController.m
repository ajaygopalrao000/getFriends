//
//  showingFriendsViewController.m
//  getFriends
//
//  Created by Gopal Rao on 6/26/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "showingFriendsViewController.h"
#import <Social/Social.h>
//" Hello World "

@interface showingFriendsViewController ()
{
    NSMutableArray *friendsArray;
    NSDictionary *friendCollection;
}

@end

@implementation showingFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @" List of Friends ";
    self.view.backgroundColor = [UIColor whiteColor];
    [self showFriends];
    dataSource = [[NSMutableArray alloc] init];
    table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    //[self showFriends];
    //NSLog(@"viewDidLoad");
}

-(void) showFriends
{
    //NSLog(@"showFriends");
        [self getFacebookFriends:^(NSArray *successArray) {
            //Receive the array that is generated after success
            self.theFriendsArray = successArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                //[friendsArray removeAllObjects];
                
                //[friendsArray addObjectsFromArray:[friendCollection objectForKey:@"geonames"]];
                //[friendsArray addObject:friendCollection];
                
                [table reloadData];
            });
        } error:^(NSString *errorString) {
        }];
}

-(void)getFacebookFriends: (FriendsCallbackSuccess)success error:(FriendsCallbackError)inError
{
    //NSLog(@"getFacebookFriends");
    ACAccountStore *store = [[ACAccountStore alloc]init];
    //Specify the account that we're going to use, in this case Facebook
    ACAccountType *facebookAccount = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    //Give the app ID (the one we copied before in our FB application at developer's site), permission keys and the audience that can see what we do (in case we do a POST)
    NSDictionary *FacebookOptions = @{ACFacebookAppIdKey: @"102056553472710", ACFacebookPermissionsKey: @[@"public_profile",@"email",@"user_friends"],ACFacebookAudienceKey:ACFacebookAudienceFriends};
    //Request access to the account with the options that we established before
    [store requestAccessToAccountsWithType:facebookAccount options:FacebookOptions completion:^(BOOL granted, NSError *error) {
        //Check if everything inside our app that we created at facebook developer is valid
        if (granted)
        {
            NSArray *accounts = [store accountsWithAccountType:facebookAccount];
            //Get the accounts linked to facebook in the device
            if ([accounts count]>0) {
                ACAccount *facebookAccount = [accounts lastObject];
                
                //Set the parameters that we require for our friend list
                NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"picture.width(1000).height(1000),name,link",@"fields", nil];
                //Generate the facebook request to the graph api, we'll call the taggle friends api, that will give us the details from our list of friends
                SLRequest *facebookRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/v2.0/me/taggable_friends"] parameters:param];
//                SLRequest *facebookRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/USER_ID/friends?format=json&limit=25&offset=25&__after_id=LAST_ID"] parameters:param];
//                
                //Set the parameters and request to the FB account
                [facebookRequest setAccount:facebookAccount];
                
                [facebookRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    // Read the returned response
                    if(!error){
                        self.success = success;
                        //Read the response in a JSON format
                        id json =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                        //NSLog(@"Dictionary contains data: %@", json );
                        if([json objectForKey:@"error"]!=nil)
                        {
                        }
                        //Get the data inside of the json in an array
                        NSArray *allFriends = [json objectForKey:@"data"];
                        //Prepare the array that we will send
                        friendsArray = [[NSMutableArray alloc]init];
                        //NSLog(@" allFriends Count is : %li", [allFriends count]);
                        //NSLog(@"UserName & id is : ");
                        for (NSDictionary *userInfo in allFriends)
                        {
                            
                            NSString *userName = [userInfo objectForKey:@"name"];
                            
                            NSString *userID = [userInfo objectForKey:@"id"];
                            
                            //NSLog(@"user_ID %@",userID);
                            //                            NSString *fb_id = (NSString *)[userInfo objectForKey:@"id"];
                            //                            [objDict setObject:fb_id forKey:@"id"];
                            //                            //NSLog(@"%@",fb_id);
                            NSDictionary *pictureData = [[userInfo objectForKey:@"picture"] objectForKey:@"data"];
                            NSString *imageUrl = [pictureData objectForKey:@"url"];
                            //Save all the user information in a dictionary that will contain the basic info that we need
                            friendCollection = [[NSDictionary alloc]initWithObjects:@[userName, imageUrl] forKeys:@[@"username", @"picURL"]];
                            //Store each dictionary inside the array that we created
                            [friendsArray addObject:friendCollection];
                            
                        }
                        //NSLog(@" The total no. of friends is : %li",[friendsArray count]);
                        //Send the array that we created to a success call
                        success(friendsArray);
                        //NSLog(@" Friends Array is %@",friendsArray);
                        //NSLog(@" Data Source is %@",dataSource);
                        //[self printArrayValues];
                    }
                    
                    //NSLog(@"URL %@", urlResponse);
                    //NSLog(@"%@", [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
                }];
            }
        }else{
            //If there was an error, show in console the code number
            NSLog(@"ERROR: %@", error);
            self.error = inError;
        }
        
    }];
}

- (void) printArrayValues
{
    for (int i =0; i<25; i++) {
        NSDictionary * dict = [friendsArray objectAtIndex:i];
        NSLog(@" Name %i is %@",i, [dict objectForKey:@"username"]);
        NSLog(@" image url is %@",[dict objectForKey:@"picURL"]);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    //NSLog(@"numberOfSectionsInTableView");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
//    return [dataSource count];
    //NSLog(@"numberOfRowsInSection with count is %li ",[friendsArray count]);
    //return [friendsArray count];
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //NSLog(@" in cellForRowAtIndexPath start ");
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    //Contact * objContact = [dataSource objectAtIndex:indexPath.row];
    //NSLog(@"friendsArray size is %li",[friendsArray count]);
    NSDictionary * dict = [friendsArray objectAtIndex:indexPath.row];
    UIImage *image;
    //Get the image from the url received
    NSURL *picUrl = [NSURL URLWithString:[dict objectForKey:@"picURL"]];
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:picUrl]];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //Hide the activity indicator
    [cell.imageView setNeedsLayout];
    
    cell.textLabel.text = [dict objectForKey:@"username"];
    cell.detailTextLabel.text = @"F.B_ID";
    cell.imageView.image = image;
    
     //NSLog(@" in cellForRowAtIndexPath end ");
    return cell;
   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;
{
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
