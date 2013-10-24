//
//  ServiceViewController.m
//  TestProject
//
//  Created by Денис Аверин on 2013-10-24
//  Copyright (c) 2013 Denis Averin. All rights reserved.
//

#import "ServiceViewController.h"
#import "HtmlWriter.h"

@interface ServiceViewController () <NSURLConnectionDelegate>
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) HtmlWriter *writer;
@property (nonatomic) NSInteger httpStatusCode;
@end

@implementation ServiceViewController

static NSString *kDocumentUrl = @"http://bash.zennexgroup.com/service/ru/get.php?type=last";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Service", @"Service");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startDownload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.activityIndicator.frame = self.view.bounds;
}

#pragma mark - My Code

- (void)showLoadingIndicator
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityIndicator startAnimating];
}

- (void)hideLoadingIndicator
{
    [self.activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) showError:(NSString *) errorString
{
    NSString *str = [NSString stringWithFormat:@"<html><body><h1>%@</h1>%@</body></html>", errorString, kDocumentUrl];
    NSLog(@"ERROR: %@", str);
    [self.webView loadHTMLString: str baseURL:nil];
}

- (void)startDownload
{
    NSURL *url = [NSURL URLWithString: kDocumentUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        self.receivedData = [NSMutableData data];
        [self showLoadingIndicator];
    } else {
        [self showError: NSLocalizedString (@"Network Error", @"Network Error")];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass: [NSHTTPURLResponse class]]) {
        self.httpStatusCode = [(NSHTTPURLResponse*) response statusCode];
        if (self.httpStatusCode == 200) {
            self.receivedData.Length = 0;
        }
    } else {
        [self showError:NSLocalizedString(@"Unknown network error", @"Unknown network error")];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideLoadingIndicator];

    if (self.httpStatusCode != 200) {
        NSString *html = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
        [self.webView loadHTMLString:html baseURL:nil];
        [html release];
        return;
    }

    self.writer = [[[HtmlWriter alloc] initWithCapacity:self.receivedData.length] autorelease];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.receivedData];
    parser.delegate = self.writer;
    [parser parse];
//    NSLog(@"HTML:\n%@", self.writer.htmlString);
    [self.webView loadHTMLString:self.writer.htmlString baseURL:nil];

    [parser release];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self hideLoadingIndicator];
    // release the connection, and the data object
    [connection release];

    [self showError:[error localizedDescription]];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [error userInfo][NSURLErrorFailingURLStringErrorKey]);
}

#pragma mark - dealloc
- (void)dealloc {
    [_receivedData release];
    [_writer release];
    [_webView release];
    [_activityIndicator release];
    [super dealloc];
}
@end
