//
//  MapViewController.m
//  testAddress
//
//  Created by ndolgopolov on 12.05.17.
//  Copyright © 2017 ndolgopolov. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.googleMapView.settings.scrollGestures = YES;
    self.googleMapView.settings.zoomGestures = YES;
    self.googleMapView.settings.compassButton = YES;
    self.googleMapView.delegate = (id)self;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_selectedAddr.coordinate.latitude
                                                            longitude:_selectedAddr.coordinate.longitude
                                                                 zoom:18];
    
    [self addMarker];
    [self.googleMapView setCamera:camera];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addMarker{

    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker"]];
    CGPoint markerCenter = self.googleMapView.center;
    markerCenter.y = markerCenter.y - img.bounds.size.height*2;
    img.center = markerCenter;
    [self.googleMapView addSubview:img];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)mapView:(GMSMapView *)MapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
    
        CLLocationCoordinate2D newCoords = CLLocationCoordinate2DMake(position.target.latitude,
                                                                      position.target.longitude);
  
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:newCoords completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newAddress" object:result];
        }
    }];
    
}

- (IBAction)continueBtn:(id)sender {
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"printAddress" object:nil];
}
@end
