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
// #import "LGMutableOrdinalNumber.h"
#include <stdio.h>

NSString *LGRead(NSString *question, const int length) {
    fprintf(stdout, "%s: ", [question cStringUsingEncoding:NSUTF8StringEncoding]);
    char response[length];
    char *success = fgets(response, length, stdin);
    if (success != NULL) return [[NSString stringWithCString:response encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    else @throw [NSException exceptionWithName:@"LGfgetsError" reason:@"" userInfo:nil];
}

void LGWrite(NSString *statement) {
    fprintf(stdout, "%s\n", [statement cStringUsingEncoding:NSUTF8StringEncoding]);
}

int main(int argc, const char *argv[]) {

    @autoreleasepool {
        
        if (argc != 2) { // invalid args
            fprintf(stderr, "Benutzung: csvToD83 <Name der CSV Datei>");
            return 1;
        }
        
        // Read from ...
        NSString *csvPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        if ([csvPath length] < 5 || ![[csvPath substringWithRange:NSMakeRange([csvPath length] - 4, 4)] isCaseInsensitiveLike:@".csv"]) csvPath = [csvPath stringByAppendingString:@".csv"]; // add extension if needed
        
        LGWrite([NSString stringWithFormat:@"CSV Datei %@ wird eingelesen ...", csvPath]);
        
        NSError *readFileError;
        NSString *csvString = [NSString stringWithContentsOfFile:csvPath encoding:NSUTF8StringEncoding error:&readFileError];
        if (!csvString) {
            LGWrite(@""); NSLog(@"%@\n\nFehler beim lesen der Datei!", readFileError);
            return 1;
        }
        LGServiceDirectory *sd = [LGServiceDirectory serviceDirectoryWithCSVString:csvString];
        LGWrite(@"Datei erfolgreich eingelesen, im Folgenden können Sie das LV mit weiteren Informationen ergänzen.");
        
        // Modify:
        [sd setClient:LGRead(@"Auftraggeber", 60)];
        [sd setProject:LGRead(@"Projekt", 60)];
        [sd setDescription:LGRead(@"Titel des Leistungsverzeichnisses", 40)];
        [sd setDate:[NSDate date]];
        
        // Save to ...
        NSMutableString *d83Path = [NSMutableString stringWithString:csvPath];
        [d83Path replaceCharactersInRange:NSMakeRange([d83Path length] - 4, 4) withString:@".d83"]; // change file extension by replacing last 4 chars by ".d83"
        NSMutableString *inputD83Path = [NSMutableString stringWithString:LGRead([NSString stringWithFormat:@"Name der D83 Datei [%@]", d83Path], 64)];
        if ([inputD83Path length]) { // if input
            if ([inputD83Path length] < 5 || ![[inputD83Path substringWithRange:NSMakeRange([inputD83Path length] - 4, 4)] isCaseInsensitiveLike:@".d83"]) [inputD83Path appendString:@".d83"]; // add extension if needed
            d83Path = inputD83Path; // change path to input
        }
        
        // Save:
        LGWrite([NSString stringWithFormat:@"Datei wird im D83-Format unter %@ gespeichert ...", d83Path]);
        NSError *saveFileError;
        if (![[sd d83String] writeToFile:d83Path atomically:NO encoding:NSASCIIStringEncoding error:&saveFileError]) {
            LGWrite(@""); NSLog(@"%@\n\nFehler beim speichern der D83 Datei!", saveFileError);
            return 1;
        }
        LGWrite(@"Datei wurde erfolgreich gespeichert.");
        
    }
    return 0;
}

