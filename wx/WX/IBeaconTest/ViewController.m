//
//  ViewController.m
//  IBeaconTest
//
//  Created by zuowu on 2018/12/5.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//

#import "ViewController.h"


#define UUID @"5D7B50B0-CFBA-4BF8-999B-93F6DA0F4356"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel * statusLabel;
@property (strong, nonatomic) CLBeaconRegion * myBeaconRegion;
@property (strong, nonatomic) NSDictionary * myBeaconData;
@property (strong, nonatomic) CBPeripheralManager * peripheralManager;
@property (strong, nonatomic) CBCentralManager * centralManager;
@end

@implementation ViewController



-(IBAction)btnAction:(id)sender{
    // Get the beacon data to advertise
    self.myBeaconData = [self.myBeaconRegion peripheralDataWithMeasuredPower:nil];
    
    
    // Start the peripheral manager
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    
    // Initialize the Beacon Region
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:1
                                                                  minor:1
                                                             identifier:@"WX"];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager*)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn)
    {
        // Bluetooth is on
        
        // Update our status label
        self.statusLabel.text = @"Broadcasting...";
        
        // Start broadcasting
        [self.peripheralManager startAdvertising:self.myBeaconData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff)
    {
        // Update our status label
        self.statusLabel.text = @"Stopped";
        
    }
    
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
}

@end
