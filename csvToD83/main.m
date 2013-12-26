//
//  main.m
//  csvToD83
//
//  Created by Luis Gerhorst on 16.12.13.
/*
 The MIT License (MIT)
 
 Copyright (c) 2013 Luis Gerhorst
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "LGServiceDirectory.h"
#import "LGMutableOrdinalNumber.h"
#include <stdio.h>

NSString *LGRead(char *question, const int length) {
	fprintf(stdout, "%s: ", question);
	char response[length];
	char *success = fgets(response, length, stdin);
	if (success != NULL) {
		return [[NSString stringWithCString:response encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	} else @throw [NSException exceptionWithName:@"LGfgetsError" reason:@"" userInfo:nil];
}

void LGWrite(const char *statement) {
	fprintf(stdout, "%s\n", statement);
}

int main(int argc, const char *argv[]) {

	@autoreleasepool {
		
		if (argc != 2) { // invalid args
			fprintf(stderr, "Benutzung: csvToD83 <Name der CSV Datei mit Dateiendung>");
			return 1;
		}
		
		LGWrite("CSV Datei wird eingelesen ...");
		
		// convert:
		NSString *csvPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
		LGServiceDirectory *sd = [LGServiceDirectory serviceDirectoryWithContentsOfCSVFile:csvPath];
		
		LGWrite("Datei erfolgreich eingelesen, bitte füllen Sie die folgenden Felder aus:");
		
		// modify:
		[sd setClient:LGRead("Auftraggeber", 60)];
		[sd setProject:LGRead("Projekt", 60)];
		[sd setDescription:LGRead("Titel des Leistungsverzeichnisses", 40)];
		[sd setDate:[NSDate date]];
		
		// save:
		LGWrite("Datei wird im D83-Format gespeichert ...");
		
		NSMutableString *d83Path = [NSMutableString stringWithString:csvPath];
		[d83Path replaceCharactersInRange:NSMakeRange([d83Path length] - 3, 3) withString:@"d83"]; // change file extension by replacing last 3 chars by "d83"
		
		NSError *error;
		if (![sd writeToD83File:d83Path error:&error]) NSLog(@"write to file error %@", error); // write
		
		LGWrite("Datei wurde erfolgreich gespeichert.");
	    
	}
    return 0;
}

