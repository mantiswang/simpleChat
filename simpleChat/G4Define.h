//
//  G4Define.h
//  simpleChat
//
//  Created by wangyue on 14-9-14.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#ifndef simpleChat_G4Define_h
#define simpleChat_G4Define_h

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#endif
