//
//  main.m
//  Dictionary
//
//  Created by Eddie Hillenbrand on 6/2/16.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            exit(1);
        }
        
        const char *cword = argv[1];
        CFStringRef word = CFStringCreateWithCString(NULL, cword, kCFStringEncodingUTF8);
        NSUInteger length = [(__bridge NSString *)word length];
        
        CFStringRef def = DCSCopyTextDefinition(NULL, word, CFRangeMake(0, length));
        if (!def) {
            exit(2);
        }
        
        const char *cdef = [(__bridge NSString *)def UTF8String];
        
        fprintf(stdout, "%s\n", cdef);
    }
    return 0;
}
