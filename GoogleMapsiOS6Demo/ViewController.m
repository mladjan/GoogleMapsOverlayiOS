//
//  ViewController.m
//  GoogleMapsiOS6Demo
//
//  Created by Mladjan Antic on 9/13/12.
//  Copyright (c) 2012 Imperio. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize overlay, mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // OSM
    overlay = [[TileOverlay alloc] initOverlay];
    [mapView addOverlay:overlay];
    MKMapRect visibleRect = [mapView mapRectThatFits:overlay.boundingMapRect];
    visibleRect.size.width /= 2;
    visibleRect.size.height /= 2;
    visibleRect.origin.x += visibleRect.size.width / 2;
    visibleRect.origin.y += visibleRect.size.height / 2;
    mapView.visibleMapRect = visibleRect;
    // END OSM

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)ovl
{
    TileOverlayView *view = [[TileOverlayView alloc] initWithOverlay:ovl];
    view.tileAlpha = 1.0; // e.g. 0.6 alpha for semi-transparent overlay
    return view;
}


@end
