//
//  JFMapAnnotation.h
//  JFMapViewExample
//
//  Created by Jonathan Field on 15/09/2013.
//  Copyright (c) 2013 Jonathan Field. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) NSString * productName;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSData * productImage;
@property int tag;

@end
