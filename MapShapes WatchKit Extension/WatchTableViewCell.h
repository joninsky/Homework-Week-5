//
//  WatchTableView.h
//  MapShapes
//
//  Created by Jon Vogel on 2/5/15.
//  Copyright (c) 2015 Jon Vogel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>
#import <MapKit/MapKit.h>

@interface WatchTableViewCell : NSObject //<MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet WKInterfaceMap *myMapView;



@end
