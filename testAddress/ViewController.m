//
//  ViewController.m
//  testAddress
//
//  Created by ndolgopolov on 11.05.17.
//  Copyright © 2017 ndolgopolov. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"
@interface ViewController (){

    GMSAutocompleteTableDataSource *_tableDataSource;

    GMSPlace *_selectedPlace;
    GMSAddress *_selectedAddr;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _additionalViewHeight.constant = 0;
    
    _tableDataSource = [[GMSAutocompleteTableDataSource alloc] init];
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    CLLocationCoordinate2D farLeft = CLLocationCoordinate2DMake(55.904082, 37.364986); //координаты очень примерные и конкретно для Москвы такой способ не оптимален, см. комментарии ниже.
    CLLocationCoordinate2D nearRight = CLLocationCoordinate2DMake(55.569079, 37.861217);
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:farLeft
                                                                       coordinate:nearRight];

    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
   
    [_tableDataSource setAutocompleteFilter:filter];
    [_tableDataSource setAutocompleteBounds:bounds];
    /////////////////////////////////////////////////////////////////////////////////////////////////
    _tableDataSource.delegate = (id)self;
    
    _resultsView.delegate = _tableDataSource;
    _resultsView.dataSource = _tableDataSource;

    [_streetField addTarget:self
                     action:@selector(streetFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    [_houseField addTarget:self
                     action:@selector(houseFieldDidChange:)
           forControlEvents:UIControlEventEditingChanged];
    _streetField.delegate = (id)self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetNewAddr:)
                                                 name:@"newAddress"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(printAddressInView)
                                                 name:@"printAddress"
                                               object:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didGetNewAddr:(NSNotification*)notification {
    NSLog(@"%@", [notification object]);
    _selectedAddr = [notification object];
    [self setFields];
    [self updateUI];
}

- (void)streetFieldDidChange:(UITextField *)textField {
    

   [_tableDataSource sourceTextHasChanged:textField.text];
    //Также можно убрать autocompleteBounds и осуществлять вот такой запрос
    //[_tableDataSource sourceTextHasChanged:[NSString stringWithFormat:@"г. Москва, %@", textField.text]];
    
    [_resultsView setHidden:[textField.text isEqualToString:@""]];
    _additionalViewHeight.constant = 0;
    [_additionalView setNeedsUpdateConstraints];
    [_additionalView setHidden:YES];
    
}

- (void)houseFieldDidChange:(UITextField *)textField {
    
    [_tableDataSource sourceTextHasChanged:[NSString stringWithFormat:@"%@, %@", _streetField.text, textField.text]];
    [_resultsView setHidden:NO];
    
}

- (void)setPlace:(GMSPlace *)newPlace{

    _selectedPlace = newPlace;
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:newPlace.coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
        
            _selectedAddr = result;
            [self setFields];
            [self updateUI];
            }
        }];
        
}

- (void)updateUI{

    [self.toMap setEnabled:YES];
    [_resultsView setHidden:YES];
    _additionalViewHeight.constant = 150;
    [_additionalView setNeedsUpdateConstraints];
    [_additionalView setHidden:NO];
    
}

- (void)setFields{

    _streetField.text = [[_selectedAddr.thoroughfare componentsSeparatedByString:@","] objectAtIndex:0];// честно говоря, такая реализация вызывает у меня сомнения
     if ([_selectedPlace.types[0] isEqualToString:@"street_address"]) {
    _houseField.text = [[[_selectedAddr.thoroughfare componentsSeparatedByString:@","] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     }
    
}

#pragma mark - GMSAutocompleteTableDataSourceDelegate

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didAutocompleteWithPlace:(GMSPlace *)place {
    [_streetField resignFirstResponder];
    _streetField.text = @"";
    [self setPlace:place];
}

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didFailAutocompleteWithError:(NSError *)error {
    [_streetField resignFirstResponder];
    _streetField.text = @"";
}

- (void)didRequestAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_resultsView reloadData];
}

- (void)didUpdateAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [_resultsView reloadData];
}




- (IBAction)goToMap:(id)sender {
    
    [self performSegueWithIdentifier:@"openMap" sender:nil];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"openMap"]) {
        MapViewController * map = [segue destinationViewController];
        
        map.selectedAddr = _selectedAddr;
    }
    

}
- (IBAction)printAddress:(id)sender {
    
    [self printAddressInView];

}

- (void)printAddressInView{

    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Выбран адрес" message:_selectedAddr.lines[0] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Выбран адрес" message:_selectedAddr.lines[0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }

}
@end
