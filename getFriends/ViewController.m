//
//  ViewController.m
//  getFriends
//
//  Created by Gopal Rao on 6/26/15.
//  Copyright (c) 2015 Gopal Rao. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import "showingFriendsViewController.h"


@interface ViewController ()
{
    NSMutableArray *friendsArray, * dataSource;
    
    NSMutableDictionary * objDict;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Showing Friends List";
    objDict = [[NSMutableDictionary alloc]init];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    UIButton * getFriends = [[UIButton alloc] initWithFrame:CGRectMake(80, 400, 200, 45)];
    [getFriends setTitle:@"Get My Friends List" forState:UIControlStateNormal];
    [getFriends setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [getFriends addTarget:self action:@selector(getMyFriendsList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getFriends];
    
    
    
}

//- (void) printArrayValues
//{
//    for (int i =0; i<25; i++) {
//        NSDictionary * dict = [friendsArray objectAtIndex:i];
//        NSLog(@" Name %i is %@",i, [dict objectForKey:@"username"]);
//        NSLog(@" image url is %@",[dict objectForKey:@"picURL"]);
//    }
//}

- (void) getMyFriendsList : (UIButton *) btn;
{
    
    showingFriendsViewController * showNavCont = [[showingFriendsViewController alloc] init];
    //[self presentViewController:showNavCont animated:YES completion:nil ];
    [self.navigationController pushViewController:showNavCont animated:YES];
    //NSLog(@" Get My Friends ");
//    [self getFacebookFriends:^(NSArray *successArray) {
//        //Receive the array that is generated after success
//        self.theFriendsArray = successArray;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //Execute the segue on the main queue so the UI doesn't get affected
//            //[self performSegueWithIdentifier:@"showFriendsSegue" sender:self];
//            //[self showViewController:@"showFriendsSegue" sender:self];
//            //Once the method is completed stop the animation of the activity indicator and remove the shadow view.
//        });
//    } error:^(NSString *errorString) {
//    }];
    
}


//-(void)getFacebookFriends: (FriendsCallbackSuccess)success error:(FriendsCallbackError)inError
//{
//    //NSLog(@"getFacebookFriends");
//    ACAccountStore *store = [[ACAccountStore alloc]init];
//    //Specify the account that we're going to use, in this case Facebook
//    ACAccountType *facebookAccount = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    //Give the app ID (the one we copied before in our FB application at developer's site), permission keys and the audience that can see what we do (in case we do a POST)
//    NSDictionary *FacebookOptions = @{ACFacebookAppIdKey: @"102056553472710", ACFacebookPermissionsKey: @[@"public_profile",@"email",@"user_friends"],ACFacebookAudienceKey:ACFacebookAudienceFriends};
//    //Request access to the account with the options that we established before
//    [store requestAccessToAccountsWithType:facebookAccount options:FacebookOptions completion:^(BOOL granted, NSError *error) {
//        //Check if everything inside our app that we created at facebook developer is valid
//        if (granted)
//        {
//            NSArray *accounts = [store accountsWithAccountType:facebookAccount];
//            //Get the accounts linked to facebook in the device
//            if ([accounts count]>0) {
//                ACAccount *facebookAccount = [accounts lastObject];
//                
//                //Set the parameters that we require for our friend list
//                NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:@"picture.width(1000).height(1000),name,link",@"fields", nil];
//                //Generate the facebook request to the graph api, we'll call the taggle friends api, that will give us the details from our list of friends
//                SLRequest *facebookRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://graph.facebook.com/v2.0/me/taggable_friends"] parameters:param];
//                //Set the parameters and request to the FB account
//                [facebookRequest setAccount:facebookAccount];
//                
//                [facebookRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//                    // Read the returned response
//                    if(!error){
//                        self.success = success;
//                        //Read the response in a JSON format
//                        id json =[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
//                        //NSLog(@"Dictionary contains data: %@", json );
//                        if([json objectForKey:@"error"]!=nil)
//                        {
//                        }
//                        //Get the data inside of the json in an array
//                        NSArray *allFriends = [json objectForKey:@"data"];
//                        //Prepare the array that we will send
//                        friendsArray = [[NSMutableArray alloc]init];
//                        //NSLog(@" allFriends Count is : %li", [allFriends count]);
//                        //NSLog(@"UserName & id is : ");
//                        for (NSDictionary *userInfo in allFriends)
//                        {
//                            
//                            NSString *userName = [userInfo objectForKey:@"name"];
//                            //NSLog(@"%@\t",userName);
//                            [objDict setObject:userName forKey:@"name"];
////                            NSString *fb_id = (NSString *)[userInfo objectForKey:@"id"];
////                            [objDict setObject:fb_id forKey:@"id"];
////                            //NSLog(@"%@",fb_id);
//                            NSDictionary *pictureData = [[userInfo objectForKey:@"picture"] objectForKey:@"data"];
//                            NSString *imageUrl = [pictureData objectForKey:@"url"];
//                            //Save all the user information in a dictionary that will contain the basic info that we need
//                            [objDict setObject:imageUrl forKey:@"imageUrl"];
//                            NSDictionary *friendCollection = [[NSDictionary alloc]initWithObjects:@[userName, imageUrl] forKeys:@[@"username", @"picURL"]];
//                            //Store each dictionary inside the array that we created
//                            [friendsArray addObject:friendCollection];
//                            [dataSource addObject:objDict];
//                            
//                        }
//                        //NSLog(@" The total no. of friends is : %li",[friendsArray count]);
//                        //Send the array that we created to a success call
//                        success(friendsArray);
//                        //NSLog(@" Friends Array is %@",friendsArray);
//                        //NSLog(@" Data Source is %@",dataSource);
//                        [self printArrayValues];
//                    }
//                    
//                    //NSLog(@"URL %@", urlResponse);
//                    //NSLog(@"%@", [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
//                }];
//            }
//        }else{
//            //If there was an error, show in console the code number
//            NSLog(@"ERROR: %@", error);
//            self.error = inError;
//        }
//        
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
