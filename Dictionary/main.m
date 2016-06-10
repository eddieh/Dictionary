//
//  main.m
//  Dictionary
//
//  Created by Eddie Hillenbrand on 6/2/16.
//

#import <Foundation/Foundation.h>

extern CFArrayRef DCSCopyAvailableDictionaries();
extern CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
extern CFStringRef DCSDictionaryGetShortName(DCSDictionaryRef dictionary);
extern DCSDictionaryRef DCSDictionaryCreate(CFURLRef url);
extern CFStringRef DCSDictionaryGetName(DCSDictionaryRef dictionary);
extern CFArrayRef DCSCopyRecordsForSearchString(
    DCSDictionaryRef dictionary, CFStringRef string, void *, void *);

extern CFDictionaryRef DCSCopyDefinitionMarkup(DCSDictionaryRef dictionary, CFStringRef record);
extern CFStringRef DCSRecordCopyData(CFTypeRef record);
extern CFStringRef DCSRecordCopyDataURL(CFTypeRef record);
extern CFStringRef DCSRecordGetAnchor(CFTypeRef record);
extern CFStringRef DCSRecordGetAssociatedObj(CFTypeRef record);
extern CFStringRef DCSRecordGetHeadword(CFTypeRef record);
extern CFStringRef DCSRecordGetRawHeadword(CFTypeRef record);
extern CFStringRef DCSRecordGetString(CFTypeRef record);
extern CFStringRef DCSRecordGetTitle(CFTypeRef record);
extern DCSDictionaryRef DCSRecordGetSubDictionary(CFTypeRef record);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        unsigned widx = 1;
        if (argc < 2)
            exit(1);

        if (strcmp(argv[1], "--html") == 0) {
            if (argc < 3)
                exit(1);
            widx++;
        }

        const char *cword = argv[widx];
        CFStringRef word = CFStringCreateWithCString(NULL, cword, kCFStringEncodingUTF8);
        NSUInteger len = [(__bridge NSString *)word length];

        CFStringRef def = NULL;

        // if not html
        if (widx == 1)
            def = DCSCopyTextDefinition(NULL, word, CFRangeMake(0, len));

        // if html
        if (widx == 2) {
            NSArray *dictionaries = (__bridge_transfer NSArray *)DCSCopyAvailableDictionaries();
            id dictionary = NULL;

            for (dictionary in dictionaries) {
                 CFStringRef shortname = DCSDictionaryGetShortName((__bridge DCSDictionaryRef)dictionary);
                 if (CFStringCompare(shortname, CFSTR("Dictionary"), 0) == kCFCompareEqualTo)
                     break;
                 dictionary = NULL;
            }

            if (!dictionary)
                exit(3);

            NSArray *records =
                (__bridge_transfer NSArray *)DCSCopyRecordsForSearchString((__bridge DCSDictionaryRef)dictionary, word, NULL, NULL);
            for (id record in records) {
                CFStringRef headword = DCSRecordGetHeadword((__bridge CFTypeRef)record);
                if (CFStringCompare(word, headword, 0) != kCFCompareEqualTo)
                    continue;
                def = DCSRecordCopyData((__bridge CFTypeRef)record);
            }
        }

        if (!def)
            exit(2);

        const char *cdef = [(__bridge NSString *)def UTF8String];

        fprintf(stdout, "%s\n", cdef);
    }
    return 0;
}
