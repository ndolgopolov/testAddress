//
//  ViewController.h
//  testAddress
//
//  Created by ndolgopolov on 11.05.17.
//  Copyright © 2017 ndolgopolov. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GooglePlaces;
@import GooglePlacePicker;
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *houseField;
@property (weak, nonatomic) IBOutlet UITableView *resultsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalViewHeight;
@property (weak, nonatomic) IBOutlet UIView *additionalView;
- (IBAction)goToMap:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toMap;



@end

