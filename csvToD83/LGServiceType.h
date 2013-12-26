//
//  LGServiceType.h
//  csvToD83
//
//  Created by Luis Gerhorst on 20.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LGServiceType_KIND1) { // POSART1
    LGServiceType_KIND1_N, // N - Normalposition
    LGServiceType_KIND1_G, // G
    LGServiceType_KIND1_A, // A
	LGServiceType_KIND1_S // S - Stundenlohnarbeiten
};

typedef NS_ENUM(NSInteger, LGServiceType_KIND2) { // POSART2
    LGServiceType_KIND2_N, // N - Normalposition
    LGServiceType_KIND2_E, // E - Bedarfsposition ohne Gesamtbetrag
    LGServiceType_KIND2_M // M - Bedarfsposition mit Gesamtbetrag
};

typedef NS_ENUM(NSInteger, LGServiceType_TYPE) { // POSTYP
    LGServiceType_TYPE_N, // N - Normalposition
	LGServiceType_TYPE_L // L
};

@interface LGServiceType : NSObject {
	LGServiceType_KIND1 kind1; // for POSART1
	LGServiceType_KIND2 kind2; // for POSART2
	LGServiceType_TYPE type; // for POSTYP
}

- (id)initWithCSVString:(NSString *)kind2String forServiceWithUnit:(NSString *)unit;
- (NSString *)d83Data787980;

@end
