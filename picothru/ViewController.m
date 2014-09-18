//
//  ViewController.m
//  picothru
//
//  Created by Masaru Iwasa on 2014/09/10.
//  Copyright (c) 2014年 Masaru. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "ConTableViewController.h"
#import "Entity.h"

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    UIView *_highlightView;
    UILabel *_label;
    UIButton *_button;
}
@end

@implementation ViewController
NSMutableArray *items;
NSArray *prodactname;
NSMutableArray *prodactprice;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];
    
	// スキャン履歴表示ラベル
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 120, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"(none)";
    [self.view addSubview:_label];
	
    // 会計終了ボタン
    _button = [[UIButton alloc] init];
    _button.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80);
    _button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _button.backgroundColor = [UIColor greenColor];
    [ _button setTitleColor:[ UIColor whiteColor ] forState:UIControlStateNormal ];
    [ _button setTitle:@"確認&決済" forState:UIControlStateNormal ];
    _button.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_button addTarget:self action:@selector(hoge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    
    
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
    
    NSString *url=[NSString stringWithFormat:@"http://54.64.69.224/api/v0/product?store_id=1&barcode_id=4903326112852"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    Scanitems *scanitems = [Scanitems MR_createEntity];
//	[array arrayByAddingObject:@"1"];
    NSLog(@"array = %@",array);
	scanitems.number = 3;
    scanitems.prodacts = response;
	NSLog(@"scanitems.number = %@",scanitems.number);
    scanitems.names = [array valueForKeyPath:@"name"];
    scanitems.prices = [array valueForKeyPath:@"price"];
//    _label.text = [array valueForKeyPath:@"name"];
//    _label.text = [[array valueForKeyPath:@"price"] stringValue];
//	_label.text = [[array valueForKeyPath:@"number"] stringValue];
	_label.text = [NSString stringWithFormat:@"%@ %@円",[array valueForKeyPath:@"name"],[[array valueForKeyPath:@"price"] stringValue]];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            NSString *url=[NSString stringWithFormat:@"http://54.64.69.224/api/v0/product?store_id=1&barcode_id=%@", detectionString];
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            NSData * response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
            Scanitems *scanitems = [Scanitems MR_createEntity];
            scanitems.prodacts = response;
            scanitems.names = [array valueForKeyPath:@"name"];
            scanitems.prices = [array valueForKeyPath:@"price"];
            _label.text = [array valueForKeyPath:@"name"];
            break;
        }
        else
            _label.text = @"(none)";
    }
    
    _highlightView.frame = highlightViewRect;
}

-(void)hoge:(UIButton*)button{
    //Scanitems* scanitems = [Scanitems MR_createEntity];
    //NSData *itemsData = [NSKeyedArchiver archivedDataWithRootObject:items];
    //NSData *nameData = [NSKeyedArchiver archivedDataWithRootObject:prodactname];
    //NSData *priceData = [NSKeyedArchiver archivedDataWithRootObject:prodactprice];
    //scanitems.prodacts = itemsData;
    //scanitems.names = nameData;
    //scanitems.prices = priceData;
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveNestedContexts];
    
    ConTableViewController *conTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ctv"];
    [self presentViewController:conTableViewController animated:YES completion:nil];
}


@end
