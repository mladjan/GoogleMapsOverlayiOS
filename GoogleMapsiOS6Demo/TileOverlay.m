//     File: TileOverlay.m
// Abstract: 
//     MKOverlay model class representing a tiled raster map overlay described by a directory hierarchy of tile images.
//   
//  Version: 1.0
// 
// Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
// Inc. ("Apple") in consideration of your agreement to the following
// terms, and your use, installation, modification or redistribution of
// this Apple software constitutes acceptance of these terms.  If you do
// not agree with these terms, please do not use, install, modify or
// redistribute this Apple software.
// 
// In consideration of your agreement to abide by the following terms, and
// subject to these terms, Apple grants you a personal, non-exclusive
// license, under Apple's copyrights in this original Apple software (the
// "Apple Software"), to use, reproduce, modify and redistribute the Apple
// Software, with or without modifications, in source and/or binary forms;
// provided that if you redistribute the Apple Software in its entirety and
// without modifications, you must retain this notice and the following
// text and disclaimers in all such redistributions of the Apple Software.
// Neither the name, trademarks, service marks or logos of Apple Inc. may
// be used to endorse or promote products derived from the Apple Software
// without specific prior written permission from Apple.  Except as
// expressly stated in this notice, no other rights or licenses, express or
// implied, are granted by Apple herein, including but not limited to any
// patent rights that may be infringed by your derivative works or by other
// works in which the Apple Software may be incorporated.
// 
// The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
// MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
// THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
// OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
// 
// IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
// MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
// AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
// STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
// 
// Copyright (C) 2010 Apple Inc. All Rights Reserved.
// 

#import "TileOverlay.h"

#define TILE_SIZE 256.0

@interface ImageTile (FileInternal)
- (id)initWithFrame:(MKMapRect)f path:(NSString *)p;
@end

@implementation ImageTile

@synthesize frame, imagePath;

- (id)initWithFrame:(MKMapRect)f path:(NSString *)p
{
    if (self = [super init]) {
        imagePath = [p retain];
        frame = f;
    }
    return self;
}

- (void)dealloc
{
    [imagePath release];
    [super dealloc];
}

@end

// Convert an MKZoomScale to a zoom level where level 0 contains 4 256px square tiles,
// which is the convention used by gdal2tiles.py.
static NSInteger zoomScaleToZoomLevel(MKZoomScale scale) {
    double numTilesAt1_0 = MKMapSizeWorld.width / TILE_SIZE;
    NSInteger zoomLevelAt1_0 = log2(numTilesAt1_0);  // add 1 because the convention skips a virtual level with 1 tile.
    NSInteger zoomLevel = MAX(0, zoomLevelAt1_0 + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

@implementation TileOverlay

- (id)initOverlay
{
    if (self = [super init]) {
        boundingMapRect = MKMapRectMake(-180, -90, MKMapSizeWorld.width, MKMapSizeWorld.height);
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMidX(boundingMapRect),
                                                  MKMapRectGetMidY(boundingMapRect)));
}

- (MKMapRect)boundingMapRect
{
    return boundingMapRect;
}

- (void)dealloc
{
    [tilePaths release];
    [super dealloc];
}

- (NSArray *)tilesInMapRect:(MKMapRect)rect zoomScale:(MKZoomScale)scale
{
    NSInteger z = zoomScaleToZoomLevel(scale);
    
    NSInteger minX = floor((MKMapRectGetMinX(rect) * scale) / TILE_SIZE);
    NSInteger maxX = floor((MKMapRectGetMaxX(rect) * scale) / TILE_SIZE);
    NSInteger minY = floor((MKMapRectGetMinY(rect) * scale) / TILE_SIZE);
    NSInteger maxY = floor((MKMapRectGetMaxY(rect) * scale) / TILE_SIZE);
    
    NSMutableArray *tiles = nil;
    
    for (NSInteger x = minX; x < maxX; x++) {
        for (NSInteger y = minY; y < maxY; y++) {
            // OSM
            //NSString *tileKey = [[NSString alloc] initWithFormat:@"%d/%d/%d", z, x, y]; // was flippedY
            
            // Google maps
            NSString *tileKey = [[NSString alloc] initWithFormat:@"x=%d&y=%d&z=%d", x, y, z];
            if (!tiles) {
                tiles = [NSMutableArray array];
            }
            
            MKMapRect frame = MKMapRectMake((double)(x * TILE_SIZE) / scale,
                                            (double)(y * TILE_SIZE) / scale,
                                            TILE_SIZE / scale,
                                            TILE_SIZE / scale);
            
            ImageTile *tile = [[ImageTile alloc] initWithFrame:frame path:tileKey];
            [tiles addObject:tile];
            [tile release];
            [tileKey release];
        }
    }
    return tiles;
}

@end