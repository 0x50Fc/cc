//
//  WXBluetooth.h
//  WX
//
//  Created by zuowu on 2018/11/16.
//  Copyright © 2018 kkmofang.cn. All rights reserved.
//  传统蓝牙 bluetooth 2.0

/*
 （1）GameKit.framework 多用于游戏开发，仅限于ios设备之间的连接。
 （2）MultipeerConnectivity.framework 这个就是ios设备之间互相传文件用的。
 （3）ExternalAccessory.framework 这个框架可以用于和第三方蓝牙进行交互，但是必须是MFI（make for iphone，iPad，ipod。。。等等）设备，但是这种设备需要经过苹果的认证，而且比较困难，所以用的相当少。
 （4）CoreBluetooth.framework 这就是我们的主角了，主要用于和第三方蓝牙的交互，这个不需要苹果的认证，但是必须是蓝牙4.0以上的设备（现在基本都是了），蓝牙4.0也叫BLE（Bluetooth Low Energy）所以一般都称之为BlE开发，从iPhone4s及其以后的设备都是支持BLE的。
        所以说IOS的BLE开发其实就是CoreBluetooth.framework这个框架的使用，一般情况下现在所说的IOS蓝牙开发也都是BLE开发。我们现在所做的智能家居，智能手环，类似的这些东西基本都是使用的这种方式与iPhone连接的。
 */

#import <WX/WX.h>
#import <ExternalAccessory/ExternalAccessory.h>


@interface WX (WXBluetooth)

@end


