//
//  InterfaceController.m
//  MapShapes WatchKit Extension
//
//  Created by Jon Vogel on 2/5/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import "InterfaceController.h"
#import "WatchTableViewCell.h"
#import <WatchKit/WatchKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceTable *myTable;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
//Set up Location manager
  CLLocationManager *myLocationManager = [[CLLocationManager alloc]init];
  NSSet *setOfRegions = myLocationManager.monitoredRegions;
  NSArray *arrayOfRegions = setOfRegions.allObjects;
  
  
  [self.myTable setNumberOfRows:arrayOfRegions.count withRowType:@"annotationCell"];
  
  //[self.myTable setNumberOfRows:5 withRowType:@"annotationCell"];
  
  for (int i = 0; i < arrayOfRegions.count; i++) {
    WatchTableViewCell *cell = [self.myTable rowControllerAtIndex:i];
    
    
//    zoomLocation.latitude = 47.6204;
//    zoomLocation.longitude = -122.3491;
    MKCoordinateSpan mySpan;
    mySpan.latitudeDelta = .2;
    mySpan.longitudeDelta = .2;
//    MKCoordinateRegion myLocation = MKCoordinateRegionMake(zoomLocation, mySpan);
    CLCircularRegion *theRegion = [arrayOfRegions objectAtIndex:i];
    CLLocationCoordinate2D zoomLocation = theRegion.center;
    MKCoordinateRegion region = MKCoordinateRegionMake(zoomLocation, mySpan);
    //MKCircle *circleToOverlay = [MKCircle circleWithCenterCoordinate:theRegion.center radius:theRegion.radius];
    [cell.myMapView setRegion:region];
    
    MKPointAnnotation *theAnnotation = [[MKPointAnnotation alloc]init];
    theAnnotation.title = theRegion.identifier;
    [cell.myMapView addAnnotation:zoomLocation withPinColor:WKInterfaceMapPinColorRed];
    
  }
  
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



