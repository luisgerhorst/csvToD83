//
//  LGServiceType.m
//  csvToD83
//
//  Created by Luis Gerhorst on 20.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import "LGServiceType.h"

@implementation LGServiceType

- (id)init
{
	@throw [NSException exceptionWithName:@"LGServiceTypeInitialization" reason:@"Use initWithCSVString:forServiceWithUnit:, not init" userInfo:nil];
}

/*
 * kind2String: unmodified string read from a CSV file where it would in the colummn "Art"
 * unit: the unit from the CSV file (indicates if service is measured in hours)
 */
- (id)initWithCSVString:(NSString *)kind2String forServiceWithUnit:(NSString *)unit
{
	
	self = [super init];
	
	// For enums see LGServiceType.h
	
	BOOL kind1IsS = [unit isEqualToString:@"h"];
	if (kind1IsS) kind1 = LGServiceType_KIND1_S; // measured in hours
	else kind1 = LGServiceType_KIND1_N;
	
	// todo: maybe remove whitespaces before compare
	// if kind1 is S kind2 must be N
	if ([kind2String isEqualToString:@"BE"]) kind2 = LGServiceType_KIND2_E;
	else if ([kind2String isEqualToString:@"BG"]) kind2 = LGServiceType_KIND2_M;
	else kind2 = LGServiceType_KIND2_N;
	
	type = LGServiceType_TYPE_N;
	
	if (![self valid]) @throw [NSException exceptionWithName:@"LGServiceTypeInitialization" reason:@"The resulting combination of POSART1, POSART2 and POSTYP is invalid" userInfo:nil];
	
	return self;
	
}

/*
 * Validates that combination of attributes is correct
 */
- (BOOL)valid
{
	LGServiceType_KIND1 k1 = kind1;
	LGServiceType_KIND2 k2 = kind2;
	LGServiceType_TYPE t = type;
	// See valid combinations of POSART1 (kind1), POSART2 (kind2) and POSTYP (type)
	if (k1 == LGServiceType_KIND1_N && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_N) return YES; // NNN
	if (k1 == LGServiceType_KIND1_N && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_L) return YES; // NNL
	if (k1 == LGServiceType_KIND1_N && k2 == LGServiceType_KIND2_E && t == LGServiceType_TYPE_N) return YES; // ...
	if (k1 == LGServiceType_KIND1_N && k2 == LGServiceType_KIND2_E && t == LGServiceType_TYPE_L) return YES;
	if (k1 == LGServiceType_KIND1_N && k2 == LGServiceType_KIND2_M && t == LGServiceType_TYPE_N) return YES;
	if (k1 == LGServiceType_KIND1_N && k2 == LGServiceType_KIND2_M && t == LGServiceType_TYPE_L) return YES;
	if (k1 == LGServiceType_KIND1_A && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_N) return YES;
	if (k1 == LGServiceType_KIND1_A && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_L) return YES;
	if (k1 == LGServiceType_KIND1_G && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_N) return YES;
	if (k1 == LGServiceType_KIND1_G && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_L) return YES;
	if (k1 == LGServiceType_KIND1_A && k2 == LGServiceType_KIND2_E && t == LGServiceType_TYPE_N) return YES;
	if (k1 == LGServiceType_KIND1_A && k2 == LGServiceType_KIND2_E && t == LGServiceType_TYPE_L) return YES;
	if (k1 == LGServiceType_KIND1_G && k2 == LGServiceType_KIND2_M && t == LGServiceType_TYPE_N) return YES;
	if (k1 == LGServiceType_KIND1_G && k2 == LGServiceType_KIND2_M && t == LGServiceType_TYPE_L) return YES;
	if (k1 == LGServiceType_KIND1_S && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_N) return YES;
	if (k1 == LGServiceType_KIND1_S && k2 == LGServiceType_KIND2_N && t == LGServiceType_TYPE_L) return YES; // SNL
	return NO;
}

- (NSString *)d83Data787980 // POSART1 + POSART2 + POSTYP string
{
	NSString *k1S; // kind1String
	switch (kind1) {
		case LGServiceType_KIND1_N:
			k1S = @"N";
			break;
		case LGServiceType_KIND1_G:
			k1S = @"G";
			break;
		case LGServiceType_KIND1_A:
			k1S = @"A";
			break;
		case LGServiceType_KIND1_S:
			k1S = @"S";
			break;
	}
	NSString *k2S; // kind2String
	switch (kind2) {
		case LGServiceType_KIND2_N:
			k2S = @"N";
			break;
		case LGServiceType_KIND2_E:
			k2S = @"E";
			break;
		case LGServiceType_KIND2_M:
			k2S = @"M";
			break;
	}
	NSString *tS; // typeString
	switch (type) {
		case LGServiceType_TYPE_N:
			tS = @"N";
			break;
		case LGServiceType_TYPE_L:
			tS = @"L";
			break;
	}
	NSMutableString *combination = [[NSMutableString alloc] initWithString:k1S];
	[combination appendString:k2S];
	[combination appendString:tS];
	return combination;
}

// todo: remove duplicated code
- (NSString *)description
{
	
	NSString *k1S; // kind1String
	switch (kind1) {
		case LGServiceType_KIND1_N:
			k1S = @"N";
			break;
		case LGServiceType_KIND1_G:
			k1S = @"G";
			break;
		case LGServiceType_KIND1_A:
			k1S = @"A";
			break;
		case LGServiceType_KIND1_S:
			k1S = @"S";
			break;
		default:
			break;
	}
	
	NSString *k2S; // kind2String
	switch (kind2) {
		case LGServiceType_KIND2_N:
			k2S = @"N";
			break;
		case LGServiceType_KIND2_E:
			k2S = @"E";
			break;
		case LGServiceType_KIND2_M:
			k2S = @"M";
			break;
		default:
			break;
	}
	
	NSString *tS; // typeString
	switch (type) {
		case LGServiceType_TYPE_N:
			tS = @"N";
			break;
		case LGServiceType_TYPE_L:
			tS = @"L";
			break;
		default:
			break;
	}
	
	NSMutableString *combination = [[NSMutableString alloc] initWithString:k1S];
	[combination appendString:k2S];
	[combination appendString:tS];
	
	return combination;
	
}

@end
