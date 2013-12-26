//
//  LGServiceDirectory.h
//  csvToD83
//
//  Created by Luis Gerhorst on 16.12.13.
//  Copyright (c) 2013 Luis Gerhorst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGNode.h"

@interface LGServiceDirectory : LGNode // Leistungsverzeichnis
{
	
	// Vertrag (optional)
	/*NSString *treaty; // langer Text, siehe Saetze T0, T1 & T9*/
	
	// 01 Informationen Leistungsverzeichnis
	NSString *description; // LVBEZ - Bezeichnung des Leistungsverzeichnisses
	NSDate *date; // LVDATUM - Datum des Leistungsverzeichnisses
	
	// 02 Informationen Projekt
	NSString *project; // PROBEZ - Bezeichnung des Projekts
	
	// 03 Informationen Auftraggeber
	NSString *client; // AGBEZ - Bezeichnung des Auftraggebers
	
	// 08 Kennzeichen für Währung (nur bei LVs mit Preisen)
	/*NSString *currencyID; // WAEKU
	NSString *currencyName; // WAEBEZ*/
	
}

+ (instancetype)serviceDirectoryWithContentsOfCSVFile:(NSString *)csvFilePath;

- (void)setProject:(NSString *)aProjectTitle;
- (void)setDescription:(NSString *)aServiceDirectoryDescription;
- (void)setClient:(NSString *)aClientName;
- (void)setDate:(NSDate *)aDate;

- (BOOL)writeToD83File:(NSString *)d83FilePath error:(NSError *__autoreleasing *)error;

@end
