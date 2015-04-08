//
//  CommonDeveloperTools.m
//  CommonDeveloperTools
//
//  Created by SunYu-Mac on 14-4-8.
//    Copyright (c) 2014年 CTTC. All rights reserved.
//

#import "CommonDeveloperTools.h"
#import "CreateEntityWindowController.h"
#import "HandleARCWindowController.h"
@interface CommonDeveloperTools()
{
	CreateEntityWindowController *createEntityWindowController;
    HandleARCWindowController *arcWindowContrller;
    
}
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, retain) NSMapTable *projectsByWorkspace;

@end

@implementation CommonDeveloperTools

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^
		{
            sharedPlugin = [[self alloc] initWithBundle:plugin];
        });
    }
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource acccess
        self.bundle = plugin;
        
        // Create menu items, initialize UI, etc.
        // Sample Menu Item:
        _projectsByWorkspace = [[NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                                     valueOptions:NSPointerFunctionsStrongMemory] retain];
		newMenu  = [[NSMenu allocWithZone:[NSMenu menuZone]]
					initWithTitle:@"开发工具"];


        NSMenuItem *menuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
								initWithTitle:@"开发工具" action:NULL keyEquivalent:@""];

		[menuItem setSubmenu:newMenu];
		[[NSApp mainMenu] addItem:menuItem];

        if (menuItem)
		{

			NSMenuItem *createEntity = [[[NSMenuItem alloc] initWithTitle:@"创建实体"
																   action:@selector(showCreateEntityView)
															keyEquivalent:@""] autorelease];
			[createEntity setTarget:self];
			[newMenu addItem:createEntity];
            
            NSMenuItem * autoAddARCConfig = [[[NSMenuItem alloc] initWithTitle:@"ARC支持"
                                                                        action:@selector(addARCConfig)
                                                                 keyEquivalent:@""] autorelease];
            
            [autoAddARCConfig setTarget:self];
            [newMenu addItem:autoAddARCConfig];
            
            NSMenuItem * autoAddARCConfigForThirdPart = [[[NSMenuItem alloc] initWithTitle:@"第三方ARC支持"
                                                                        action:@selector(addARCConfigForThirdPart)
                                                                 keyEquivalent:@""] autorelease];
            
            [autoAddARCConfigForThirdPart setTarget:self];
            [newMenu addItem:autoAddARCConfigForThirdPart];

			//add splitter
			[newMenu addItem:[NSMenuItem separatorItem]];


			NSMenuItem * author = [[[NSMenuItem alloc] initWithTitle:@"关于"
																   action:@selector(showAuthor)
															keyEquivalent:@""] autorelease];

			[author setTarget:self];
			[newMenu addItem:author];
            
 



        }
		[newMenu release];
		[menuItem release];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(applicationDidFinishLaunching:)
//                                                     name:NSApplicationDidFinishLaunchingNotification
//                                                   object:nil];

    }
    return self;
}

- (void) applicationDidFinishLaunching: (NSNotification*) noti {
    NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"%@",noti]
                                     defaultButton:nil
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    [alert runModal];

}


- (NSMutableArray *)projectsInCurrentWorkspace {
    NSMutableArray *projects = [_projectsByWorkspace objectForKey:[self currentWorkspace]];
    if (!projects) {
        projects = [NSMutableArray array];
        [_projectsByWorkspace setObject:projects forKey:[self currentWorkspace]];
    }
    
    return projects;
}

- (NSString *)currentWorkspace {
    return @"workspace";
    // this code below is not working if tried a few moments after opening xcode
    //    NSString *workspacePath = [MHXcodeDocumentNavigator currentWorkspacePath];
    //    return workspacePath;
}
 
- (void)showCreateEntityView
{

	if (!createEntityWindowController)
    {
        createEntityWindowController = [[CreateEntityWindowController alloc] initWithWindowNibName:@"CreateEntityWindowController"];
		createEntityWindowController.bundle = [NSBundle bundleForClass:[self class]];
    }

    [[createEntityWindowController window] makeKeyAndOrderFront:nil];

}

- (void)addARCConfig
{
    if (!arcWindowContrller)
    {
        arcWindowContrller = [[HandleARCWindowController alloc] initWithWindowNibName:@"HandleARCWindowController"];
        createEntityWindowController.bundle = [NSBundle bundleForClass:[self class]];
    }

    [[arcWindowContrller window] makeKeyAndOrderFront:nil];
}


- (void)addARCConfigForThirdPart
{
    
}

- (void)showAuthor
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"非常感谢您使用此插件，祝工作愉快！\n 作者：孙宇" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
}

- (void)dealloc
{
	if (createEntityWindowController)
	{
		[createEntityWindowController release];
	}
    
    if (arcWindowContrller)
    {
        [arcWindowContrller release];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
