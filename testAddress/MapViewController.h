//
//  MapViewController.h
//  testAddress
//
//  Created by ndolgopolov on 12.05.17.
//  Copyright © 2017 ndolgopolov. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
@import GooglePlaces;
@interface MapViewController : UIViewController<GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property GMSAddress *selectedAddr;;
- (IBAction)continueBtn:(id)sender;

@end
