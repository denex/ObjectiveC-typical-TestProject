//
//  HtmlWriter.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "HtmlWriter.h"

@interface HtmlWriter ()
@property (nonatomic, strong, getter = tagBegin) NSDictionary *tagBegin;
@property (nonatomic, strong, getter = tagEnd) NSDictionary *tagEnd;
@end

@implementation HtmlWriter {
    NSMutableString *_mutableHtml;
}

+ (NSString *) htmlEscapeString:(NSString *)string
{
    return [[[[string stringByReplacingOccurrencesOfString: @"&"  withString: @"&amp;"]
              stringByReplacingOccurrencesOfString: @"\"" withString: @"&quot;"]
             stringByReplacingOccurrencesOfString: @">"  withString: @"&gt;"]
            stringByReplacingOccurrencesOfString: @"<"  withString: @"&lt;"];
}

static NSString *htmlHead = @"<!DOCTYPE html>\n"
@"<html>\n"
@"<head>\n"
@"  <meta charset=\"utf-8\">\n"
@"  <title>Bash.im</title>\n"
@"    <style media=\"screen\" type=\"text/css\">\n"
@"        body {\n"
@"            font-family: 'Helvetica Neue';\n"
@"        }\n"
@"        .quote {\n"
@"            margin-top: 20px;\n"
@"        }\n"
@"        .id {\n"
@"            position: absolute;\n"
@"            right: 8px;\n"
@"        }\n"
@"        .header {\n"
@"            font-size: 12px;\n"
@"        }\n"
@"        .text {\n"
@"            background-color: rgb(243, 243, 243);\n"
@"            padding-bottom: 5px;\n"
@"            padding-left: 8px;\n"
@"            padding-right: 8px;\n"
@"            padding-top: 7px;\n"
@"        }\n"
@"    </style>\n"
@"</head>\n";

- (instancetype) init
{
    return [self initWithCapacity:(1<<15)-1];
}

- (instancetype) initWithCapacity:(NSInteger)capacity
{
    self = [super init];
    if (self) {
        _mutableHtml = [NSMutableString stringWithCapacity:capacity];
    }
    return self;
}

- (NSString *)htmlString
{
    return [[_mutableHtml copy] autorelease];
}

- (NSDictionary *)tagBegin
{
    if (!_tagBegin) {
        self.tagBegin = @{
                          @"totalPages": @"<!-- total=",
                          @"result"    : @"<body>",
                          @"quotes"    : @"<div class=\"quotes\">",
                          @"quote"     : @"<div class=\"quote\">",
                          @"id"        : @"<div class=\"id header\">",
                          @"date"      : @"<div class=\"date header\">",
                          @"text"      : @"<div class=\"text\">",
                          };
    }
    return _tagBegin;
}

- (NSDictionary *)tagEnd
{
    if (!_tagEnd) {
        self.tagEnd = @{
                        @"totalPages": @"-->",
                        @"result"    : @"</body>",
                        @"quotes"    : @"</div>",
                        @"quote"     : @"</div>",
                        @"id"        : @"</div>",
                        @"date"      : @"</div>",
                        @"text"      : @"</div>",
                        };
    }
    return _tagEnd;
}

- (NSString *)getStartTagForElement:(NSString *)element
{
    NSString *value = [self.tagBegin valueForKey:element];
    if (value != nil) {
        return value;
    }
    NSLog(@"Start not found for <%@>", element);
    return @"";
}

- (NSString *)getEndTagForElement:(NSString *)element
{
    NSString *value = [self.tagEnd valueForKey:element];
    if (value != nil) {
        return value;
    }
    NSLog(@"End not found for <%@>", element);
    return @"";
}

#pragma mark - NSXMLParserDelegate

// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    [_mutableHtml appendString:htmlHead];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_mutableHtml appendString:@"\n</html>"];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [_mutableHtml appendString:[self getStartTagForElement:elementName]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [_mutableHtml appendString:[self getEndTagForElement:elementName]];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_mutableHtml appendString:string];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    NSString *escapedString = [HtmlWriter htmlEscapeString:str];
    [str release];
    [_mutableHtml appendString:[escapedString stringByReplacingOccurrencesOfString:@"\n" withString:@"\n<br>\n"]];
}

#pragma mark - dealloc
- (void)dealloc
{
    [_tagBegin release];
    [_tagEnd release];
    [super dealloc];
}

@end
