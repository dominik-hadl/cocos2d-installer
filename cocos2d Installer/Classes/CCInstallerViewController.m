//
//  CCInstallerViewController.m
//  cocos2d Installer
//
//  Created by Dominik Hadl on 16/12/13.
//  Copyright (c) 2013 Dominik Hadl. All rights reserved.
// -----------------------------------------------------------
#import "CCInstallerViewController.h"
#import "CCBlogTableCell.h"
// -----------------------------------------------------------

@implementation CCInstallerViewController

// -----------------------------------------------------------
#pragma mark - Class Methods -
// -----------------------------------------------------------

+ (instancetype)setupController
{
    return [[CCInstallerViewController alloc] initWithNibName: @"CCInstallerViewController"
                                                       bundle: [NSBundle mainBundle]];
}

// -----------------------------------------------------------
#pragma mark - Init & Dealloc -
// -----------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    NSAssert(self, @"Couldn't initialise CCInstallerViewController.");
    
    
    _installer = [[CCTemplateInstaller alloc] init];
    _installer.delegate = self;
    [self.view addSubview:_introView];
    [_introView playIntroAnimation];
    
    _reachability = [Reachability reachabilityWithHostname:@"github.com"];
    //[self parseBlogPosts];
    
    return self;
}

- (void)parseBlogPosts
{
    _blogPosts = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^()
    {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://www.cocos2d-iphone.org/feed"]];
        parser.delegate = self;
        [parser parse];
    });
}

// -----------------------------------------------------------
#pragma mark - Button Callbacks -
// -----------------------------------------------------------

- (void)buttonPressed:(NSButton *)sender
{
    switch (sender.tag)
    {
        case CCInstallerButtonContinue:
        {
            [_installView setAlphaValue:0.0f];
            
            [[NSAnimationContext currentContext] setDuration:1.0f];
            [[_introView animator] setAlphaValue:0.0f];
            
            [[NSAnimationContext currentContext] setCompletionHandler:^(){
                [[NSAnimationContext currentContext] setDuration:1.0f];
                [self.view replaceSubview:_introView with:_installView];
                [[_installView animator] setAlphaValue:1.0f];
            }];
            
            break;
        }
        case CCInstallerButtonInstall:
            
            if (_installer.installationStatus == CCInstallationStatusInstalling) return;
            
            _installer.shouldInstallDocumentation = (_installView.documentationCheckbox.state == NSOnState);
            if ([_reachability isReachable])
            {
                [_installer install];
                [_installView playInstallingAnimation];
            }
            else
            {
                NSAlert *alert = [[NSAlert alloc] init];
                [alert setAlertStyle:NSInformationalAlertStyle];
                [alert setMessageText:NSLocalizedString(@"NO_INTERNET_TITLE", @"No Internet Connection")];
                [alert setInformativeText:NSLocalizedString(@"NO_INTERNET", @"No Internet Connection Description")];
                [alert beginSheetModalForWindow:self.view.window completionHandler:nil];
            }
            
            break;
        case CCInstallerButtonBack:
            if ([self.view.subviews containsObject:_installView])
            {
                [_introView setAlphaValue:0.0f];
                
                [[NSAnimationContext currentContext] setDuration:1.0f];
                [[_installView animator] setAlphaValue:0.0f];
                
                [[NSAnimationContext currentContext] setCompletionHandler:^(){
                    [[NSAnimationContext currentContext] setDuration:1.0f];
                    [self.view replaceSubview:_installView with:_introView];
                    [[_introView animator] setAlphaValue:1.0f];
                }];
            }
            else if ([self.view.subviews containsObject:_resultView])
            {
                [self.view replaceSubview:_resultView with:_installView];
            }
            break;
        case CCInstallerButtonClose:
            [_installer quit];
            [[NSApplication sharedApplication] terminate:nil];
    }
}

// -----------------------------------------------------------
#pragma mark - CCTemplateInstaller Delegate -
// -----------------------------------------------------------

- (void)installer:(CCTemplateInstaller *)installer didFinishDownloadingWithSuccess:(bool)success
{
    [_installView.progressIndicator setIndeterminate:YES];
    if (success)
    {
        // Downloading succeeded
    }
    else
    {
        // Downloading failed
    }
}

- (void)installer:(CCTemplateInstaller *)installer didFinishInstallingWithSuccess:(bool)success
{
    if (success)
    {
        // Install succeeded
    }
    else
    {
        // Install failed
        [_resultView installFailed];
        _resultView.detailText.stringValue = @""; //_installer.progressString;
        // TODO: Display correct string!
    }
    [_resultView setAlphaValue:0.0f];
    
    [[NSAnimationContext currentContext] setDuration:1.0f];
    [[_installView animator] setAlphaValue:0.0f];
    
    [[NSAnimationContext currentContext] setCompletionHandler:^(){
        [[NSAnimationContext currentContext] setDuration:1.0f];
        [self.view replaceSubview:_installView with:_resultView];
        [[_resultView animator] setAlphaValue:1.0f];
    }];
}

- (void)installer:(CCTemplateInstaller *)installer progressValueDidChange:(float)newValue
{
    [_installView.progressIndicator setDoubleValue:newValue];
}

- (void)installer:(CCTemplateInstaller *)installer progressStringDidChange:(NSString *)newString
{
    [_installView.statusText setStringValue:newString];
}

- (void)installerDidBeginDownloading:(CCTemplateInstaller *)installer
{
    [_installView.progressIndicator setIndeterminate:NO];
    [_installView.progressIndicator setMaxValue:100.0f];
    [_installView.progressIndicator setDoubleValue:0.0f];
}

- (void)installerDidBeginInstalling:(CCTemplateInstaller *)installer
{
    
}

// -----------------------------------------------------------
#pragma mark - NSXMLParser Delegate -
// -----------------------------------------------------------

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"])
    {
        _currentPost = [[CCBlogPost alloc] init];
    }
    if (_currentPost)
    {
        if ([elementName isEqualToString:@"title"] ||
            [elementName isEqualToString:@"pubDate"] ||
            [elementName isEqualToString:@"link"])
            _currentString = [[NSMutableString alloc] init];
    }
}

// -----------------------------------------------------------

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        if (_blogPosts.count >= 10)
        {
            [parser abortParsing];
        }
        
        [_blogPosts addObject:_currentPost];
        _currentPost = nil;
        _currentString = nil;
    
    }
    if (_currentPost)
    {
        if ([elementName isEqualToString:@"title"])
        {
            _currentPost.title = _currentString;
            _currentString = nil;
        }
        if ([elementName isEqualToString:@"pubDate"])
        {
            [_currentPost setDateFromString:_currentString];
            _currentString = nil;
        }
        if ([elementName isEqualToString:@"link"])
        {
            _currentPost.link = [NSURL URLWithString:_currentString];
            _currentString = nil;
        }
    }
}

// -----------------------------------------------------------

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (_currentString)
    {
        [_currentString appendString:string];
    }
}

// -----------------------------------------------------------

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    parser.delegate = nil;
    [_introView.blogTable reloadData];
}

// -----------------------------------------------------------
#pragma mark - NSTableView Delegate -
// -----------------------------------------------------------

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _blogPosts.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [_blogPosts objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    CCBlogPost *post = [_blogPosts objectAtIndex:row];
    CCBlogTableCell *customCell = (CCBlogTableCell *)cell;
    
    [customCell setTitle:post.title];
    [customCell setDate:post.date];
    [customCell setLink:post.link];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
//    NSURL *url = ((CCBlogPost *)[_blogPosts objectAtIndex:[_introView.blogTable selectedRow]]).link;
//    [[NSWorkspace sharedWorkspace] openURL:url];
}

// -----------------------------------------------------------
@end
// -----------------------------------------------------------