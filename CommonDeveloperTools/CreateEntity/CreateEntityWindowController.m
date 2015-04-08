//
//  CreateEntityWindowController.m
//  i3-platform-sdk
//
//  Created by Yu Sun on 13-3-21.
//  Copyright (c) 2013年 careers. All rights reserved.
//

#import "CreateEntityWindowController.h"
#import "JSONKit.h"
#import "NSString+Extension.h"
@interface CreateEntityWindowController ()
- (NSString *)sqliteTpyeName2OcTypeName:(NSString *)sqliteTypeName;
@end

@implementation CreateEntityWindowController
static NSMutableArray *generateClassArray = nil;

@synthesize mainContentTestView;
@synthesize classNameField;



- (void)dealloc
{
    [mainContentTestView release];
    [classNameField release];
    [array release];
    [rawVariablesMDic release];
    [_dataTypeConfigDictionary release];
    [propertyWindowController release];
    [super dealloc];
}


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    array = [[NSArrayController alloc] init];
    
    rawVariablesMDic = [[NSMutableDictionary alloc] init];
    
    _dataTypeConfigDictionary = [[NSDictionary alloc]initWithContentsOfFile:[_bundle pathForResource:@"ObjectType" ofType:@"plist"]];

}

/**
 *  带有注释
 *
 *  @param name          类名
 *  @param varsInfoArray 属性 数组
 */
- (void)generateClass:(NSString *)name andVarsInfo:(NSMutableArray *)varsInfoArray
{
    NSString *temStr = @"";
	NSError *error;
    
    //准备模板
    NSMutableString *templateH =[[NSMutableString alloc] initWithContentsOfFile:[_bundle pathForResource:@"templateH" ofType:nil]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:&error];

    NSMutableString *templateM =[[NSMutableString alloc] initWithContentsOfFile:[_bundle pathForResource:@"templateM" ofType:nil]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];


    //.h
    //name
    //property
    NSMutableString *propertyString   = [NSMutableString string];
    NSMutableString *synthesizeString = [NSMutableString string];
    NSMutableString *variabls         = [NSMutableString string];
    NSMutableString *import           = [NSMutableString string];
	NSMutableString *defineString     = [NSMutableString string];

    
    for(NSString *varInfoString in varsInfoArray)
    {
		NSArray *temArray = [varInfoString componentsSeparatedByString:@"$"];
		
		NSString *type = [temArray objectAtIndex:1];
		NSString *key = [temArray objectAtIndex:0];
		NSString *description = [temArray objectAtIndex:2];
		
		NSString *attrib = nil;
		if ([type containsString:@"*"])
		{
			if ([type containsString:@"NSString"])
			{
				attrib = @"copy";
			}
			else
			{
				attrib = @"retain";
			}
		}
		else
		{
			attrib = @"assign";
		}

        [propertyString appendFormat:@"/**\n   %@\n*/\n@property (nonatomic,%@) %@%@;\n", description, attrib, type, key];
        [variabls appendFormat:@"   %@%@;\n", type, key];
        [synthesizeString appendFormat:@"@synthesize %@;\n", key];
        [defineString appendFormat:@"#define %@ \t@\"%@\"\n", [self defineKey:name varName:key], key];

		
		
    }
    
    
    
    [templateH replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#import#"
                               withString:import
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
//    [templateH replaceOccurrencesOfString:@"#variable#"
//                               withString:variabls
//                                  options:NSCaseInsensitiveSearch
//                                    range:NSMakeRange(0, templateH.length)];
	
	[templateH replaceOccurrencesOfString:@"#define#"
                               withString:defineString
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
	
    [templateH replaceOccurrencesOfString:@"#property#"
                               withString:propertyString
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    //.m
    //NSCoding
    //name
    [templateM replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];

//    [templateM replaceOccurrencesOfString:@"#synthesize#"
//                               withString:synthesizeString
//                                  options:NSCaseInsensitiveSearch
//                                    range:NSMakeRange(0, templateM.length)];
    
    
	
    NSMutableString *description = [NSMutableString string];
    
    NSMutableString *initWithDictionaryString = [NSMutableString string];
	
	NSMutableString *encodeWithCoderString = [NSMutableString string];
	
	NSMutableString *initWithCoderString = [NSMutableString string];
	
    NSMutableString *generateDictionaryString = [NSMutableString string];
	
    NSMutableString *deallocString = [NSMutableString string];
	
	
    NSDictionary *list = [NSDictionary dictionaryWithObjectsAndKeys:description, @"description",
						  generateDictionaryString, @"dictionaryWithNameAndValue",
						  deallocString,@"dealloc",
						  initWithDictionaryString,@"initWithDictionary",
						  initWithCoderString,@"initWithCoder",
						  encodeWithCoderString,@"encodeWithCoder",nil];
    
    
    for(NSString *varInfoString in varsInfoArray)
    {
		NSArray *temArray = [varInfoString componentsSeparatedByString:@"$"];
		
		NSString *type = [temArray objectAtIndex:1];
		NSString *key = [temArray objectAtIndex:0];
		
        if ([type rangeOfString:@"*"].length > 0)
		{
			[initWithDictionaryString appendFormat:@"            self.%@ = [dictionary objectForKey:%@];\n ",  key,[self defineKey:name varName:key]];
            [generateDictionaryString appendFormat:@"    [mutableDictionary setObject:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];
            [description appendFormat:@"    result = [result stringByAppendingFormat:@\"%@ : %%@\\n\",self.%@];\n",key,key];
            [deallocString appendFormat:@"    if(_%@)\n        [_%@ release];\n",key,key];
			
			[initWithCoderString appendFormat:@"            self.%@ = [coder decodeObjectForKey:%@];\n",  key,[self defineKey:name varName:key]];
			[encodeWithCoderString appendFormat:@"    [coder encodeObject:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];


		}
        else if([[temStr lowercaseString] rangeOfString:@"int"].length > 0)
        {
			[initWithDictionaryString appendFormat:@"            self.%@  = [[dictionary objectForKey:%@]intValue];\n ",  key,[self defineKey:name varName:key]];
            [description appendFormat:@"    result = [result stringByAppendingFormat:@\"%@ : %%d\\n\",self.%@];\n",key,key];
            [generateDictionaryString appendFormat:@"    [mutableDictionary setObject:[NSNumber numberWithInt:self.%@] forKey:%@];\n",  key,[self defineKey:name varName:key]];
			
			[initWithCoderString appendFormat:@"            self.%@ = [coder decodeIntForKey:%@];\n",  key,[self defineKey:name varName:key]];
			[encodeWithCoderString appendFormat:@"    [coder encodeInt:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];

			
        }
        else if([[temStr lowercaseString] rangeOfString:@"float"].length > 0)
        {
			[initWithDictionaryString appendFormat:@"            self.%@  = [[dictionary objectForKey:%@]floatValue];\n ",  key,[self defineKey:name varName:key]];
            [generateDictionaryString appendFormat:@"    [mutableDictionary setObject:[NSNumber numberWithFloat:self.%@] forKey:%@];\n",  key,[self defineKey:name varName:key]];
            [description appendFormat:@"    result = [result stringByAppendingFormat:@\"%@ : %%f\\n\",self.%@];\n",key,key];
			
			[initWithCoderString appendFormat:@"            self.%@ = [coder decodeFloatForKey:%@];\n",  key,[self defineKey:name varName:key]];
			[encodeWithCoderString appendFormat:@"    [coder encodeFloat:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];

        }
		
        
    }
    
    //修改模板
    for(NSString *key in [list allKeys])
    {
        [templateM replaceOccurrencesOfString:[NSString stringWithFormat:@"#%@#",key]
                                   withString:[list objectForKey:key]
                                      options:NSCaseInsensitiveSearch
                                        range:NSMakeRange(0, templateM.length)];
    }
    
    
    //写文件
    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@.h", _fileSavePath, name]);
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h", _fileSavePath, name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m", _fileSavePath, name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];


    [templateH release];
    [templateM release];
}




- (void)generateClass:(NSString *)name forDic:(NSDictionary *)variablesDic
{
    NSString *temStr = @"";
    
    
    //准备模板
    NSMutableString *templateH =[[NSMutableString alloc] initWithContentsOfFile:[_bundle pathForResource:@"templateH" ofType:nil]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];
    NSMutableString *templateM =[[NSMutableString alloc] initWithContentsOfFile:[_bundle pathForResource:@"templateM" ofType:nil]
                                                                       encoding:NSUTF8StringEncoding
                                                                          error:nil];


    //.h
    //name
    //property
    NSMutableString *propertyString = [NSMutableString string];
    NSMutableString *synthesizeString = [NSMutableString string];
    NSMutableString *variabls = [NSMutableString string];
    NSMutableString *import = [NSMutableString string];

    NSMutableString *defineString = [NSMutableString string];
	
	NSMutableString *setteString = [NSMutableString string];



    for(NSString *key in [variablesDic allKeys])
    {
        temStr = [variablesDic objectForKey:key];
		
		NSString *attrib = @"";
		if ([temStr containsString:@"*"])
		{
			if ([temStr containsString:@"NSString"])
			{
				attrib = @"copy";
			}
			else
			{
				attrib = @"retain";
			}
		}
		else
		{
			attrib = @"assign";
		}
        [propertyString appendFormat:@"@property (nonatomic,%@) %@%@;\n", attrib, temStr, key];
        [variabls appendFormat:@"   %@%@;\n",temStr,key];
        [synthesizeString appendFormat:@"@synthesize %@;\n", key];
        [defineString appendFormat:@"#define %@ @\"%@\"\n",[self defineKey:name varName:key],key];

		
		NSString *className1 = [self uppercaseFirstChar:key];
        if ([temStr containsString:@"Array"] &&[generateClassArray containsObject:className1])
        {
			[setteString appendFormat:@"- (void)set%@:(NSArray *)array\n"
			 "{\n"
				"	NSMutableArray *temArray = [[NSMutableArray alloc] initWithCapacity:[array count]];\n"
				"	for (NSDictionary *dic in array)\n"
				"	{\n"
			 "		%@ *item = [[[%@ alloc]initWithDictionary:dic] autorelease];\n"
			 "		[array addObject:item];\n"
				"	}\n"
				"	[_%@ release];\n"
				"	_%@ = temArray;\n"
			 "}\n\n",className1,className1,className1,key,key];
			
			[import appendFormat:@"#import \"%@.h\"\n",className1];

		}
		
        
        NSString *className = [[temStr componentsSeparatedByString:@" "] objectAtIndex:0];
		if (className && [className length] > 0)
		{
			Class class = NSClassFromString(className);
			if (!class && [temStr containsString:@"*"])
			{
				[import appendFormat:@"#import \"%@.h\"",className];
			}
			
		}

    }
    
    
    
    [templateH replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#import#"
                               withString:import
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];

    [templateH replaceOccurrencesOfString:@"#define#"
                               withString:defineString
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
//    [templateH replaceOccurrencesOfString:@"#variable#"
//                               withString:variabls
//                                  options:NSCaseInsensitiveSearch
//                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#property#"
                               withString:propertyString
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    //.m
    //NSCoding
    //name
    [templateM replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
//    [templateM replaceOccurrencesOfString:@"#synthesize#"
//                               withString:synthesizeString
//                                  options:NSCaseInsensitiveSearch
//                                    range:NSMakeRange(0, templateM.length)];
    
    

    NSMutableString *description = [NSMutableString string];
    
    NSMutableString *initWithDictionaryString = [NSMutableString string];
	
	NSMutableString *encodeWithCoderString = [NSMutableString string];

	NSMutableString *initWithCoderString = [NSMutableString string];

    NSMutableString *generateDictionaryString = [NSMutableString string];

    NSMutableString *deallocString = [NSMutableString string];


    NSDictionary *list = [NSDictionary dictionaryWithObjectsAndKeys:description, @"description",
						  generateDictionaryString, @"dictionaryWithNameAndValue",
						  deallocString,@"dealloc",
						  initWithDictionaryString,@"initWithDictionary",
						  initWithCoderString,@"initWithCoder",
						  encodeWithCoderString,@"encodeWithCoder",
						  setteString,@"setter",nil];
    
    
    
    for(NSString *key in [variablesDic allKeys])
    {

        temStr = [variablesDic objectForKey:key];
        if ([temStr rangeOfString:@"*"].length > 0)
        {
            [initWithDictionaryString appendFormat:@"            self.%@ = [dictionary objectForKey:%@];\n ",  key,[self defineKey:name varName:key]];
            [generateDictionaryString appendFormat:@"    [mutableDictionary setObject:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];
            [description appendFormat:@"    result = [result stringByAppendingFormat:@\"%@ : %%@\\n\",self.%@];\n",key,key];
            [deallocString appendFormat:@"    if(_%@)\n        [_%@ release];\n",key,key];
			
			[initWithCoderString appendFormat:@"            self.%@ = [coder decodeObjectForKey:%@];\n",  key,[self defineKey:name varName:key]];
			[encodeWithCoderString appendFormat:@"    [coder encodeObject:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];
        }
        else if([[temStr lowercaseString] rangeOfString:@"int"].length > 0)
        {
            [initWithDictionaryString appendFormat:@"            self.%@  = [[dictionary objectForKey:%@]intValue];\n ",  key,[self defineKey:name varName:key]];
            [description appendFormat:@"    result = [result stringByAppendingFormat:@\"%@ : %%d\\n\",self.%@];\n",key,key];
            [generateDictionaryString appendFormat:@"    [mutableDictionary setObject:[NSNumber numberWithInt:self.%@] forKey:%@];\n",  key,[self defineKey:name varName:key]];
			
			[initWithCoderString appendFormat:@"            self.%@ = [coder decodeIntForKey:%@];\n",  key,[self defineKey:name varName:key]];
			[encodeWithCoderString appendFormat:@"    [coder encodeInt:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];

        }
        else if([[temStr lowercaseString] rangeOfString:@"float"].length > 0)
        {
            [initWithDictionaryString appendFormat:@"            self.%@  = [[dictionary objectForKey:%@]floatValue];\n ",  key,[self defineKey:name varName:key]];
            [generateDictionaryString appendFormat:@"    [mutableDictionary setObject:[NSNumber numberWithFloat:self.%@] forKey:%@];\n",  key,[self defineKey:name varName:key]];
            [description appendFormat:@"    result = [result stringByAppendingFormat:@\"%@ : %%f\\n\",self.%@];\n",key,key];
			
			[initWithCoderString appendFormat:@"            self.%@ = [coder decodeFloatForKey:%@];\n",  key,[self defineKey:name varName:key]];
			[encodeWithCoderString appendFormat:@"    [coder encodeFloat:self.%@ forKey:%@];\n",  key,[self defineKey:name varName:key]];
        }
		


    }
    
    //修改模板
    for(NSString *key in [list allKeys])
    {
        [templateM replaceOccurrencesOfString:[NSString stringWithFormat:@"#%@#",key]
                                   withString:[list objectForKey:key]
                                      options:NSCaseInsensitiveSearch
                                        range:NSMakeRange(0, templateM.length)];
    }


    //写文件
    NSLog(@"%@", [NSString stringWithFormat:@"%@/%@.h", _fileSavePath, name]);
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h", _fileSavePath, name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m", _fileSavePath, name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];


    [templateH release];
    [templateM release];
    
}





-(void)generateProperty:(NSDictionary *)variablesDir  withName:(NSString *)className;
{
    for(NSString *key in [variablesDir allKeys])
    {
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%@",key],@"classKey",
                             [variablesDir objectForKey:key],@"classType",
                             className,@"className",
                             nil];
        [array addObject:dic];
    }
}

-(NSString *)uppercaseFirstChar:(NSString *)str
{
    return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString],[str substringWithRange:NSMakeRange(1, str.length-1)]];
}
-(NSString *)lowercaseFirstChar:(NSString *)str
{
    return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] lowercaseString],[str substringWithRange:NSMakeRange(1, str.length-1)]];
}

-(void)showPropertys:(NSDictionary *)variablesDir
{
    array = nil;
    array = [[NSArrayController alloc] init];
    
    [self generateProperty:variablesDir  withName:classNameField.stringValue];
    
    
    if (!propertyWindowController)
    {
        propertyWindowController = [[EntityPropertyWindowController alloc] initWithWindowNibName:@"EntityPropertyWindowController"];

    }
    propertyWindowController.arrayController = array;
    [propertyWindowController.window makeKeyAndOrderFront:nil];
    
}

- (void)generateClassByJsonDic:(NSDictionary *)dictionary className:(NSString *)className
{
	
	if (!generateClassArray)
    {
		generateClassArray = [[NSMutableArray alloc] init];
	}
	[generateClassArray addObject:className];

	NSMutableDictionary *variablesDir = [[NSMutableDictionary alloc] init];

	for(NSString *key in [dictionary allKeys])
	{
		id objet = [dictionary objectForKey:key];
		
		NSString *type = NSStringFromClass([objet class]);
		if ([type containsString:@"String"])
		{
			[variablesDir setObject:@"NSString *" forKey:key];
		}
		else if ([type containsString:@"Number"])
		{
			[variablesDir setObject:@"NSNumber *" forKey:key];
		}
		else if ([type containsString:@"Dictionary"])
		{
			NSString *name = [NSString stringWithFormat:@"%@ *",[self uppercaseFirstChar:key]];
			[variablesDir setObject:name forKey:key];
			[self generateClassByJsonDic:objet className:[self uppercaseFirstChar:key]];
			
		}
		else if ([type containsString:@"Array"] )
		{
            NSArray *temArray = (NSArray *)objet;
            
            if ([temArray count] > 0 )
            {
                id newObject = [temArray firstObject];
                if ([newObject isKindOfClass:[NSDictionary class]])
                {
                    NSString *subClassName = [self uppercaseFirstChar:key];
                    [self generateClassByJsonDic:newObject
                                       className:subClassName];
					
                }
            }
            
			[variablesDir setObject:@"NSArray *" forKey:key];
		}
		NSLog(@"%@",NSStringFromClass([objet class]));
		
	}
	
	[self generateClass:className forDic:variablesDir];

    [variablesDir release];
}


- (IBAction)generateClass:(id)sender 
{

	
	NSMutableDictionary *variablesDir = [[NSMutableDictionary alloc] init];

	NSMutableArray *varsInfoArray = [NSMutableArray array];
    NSString *keyStr = @"";
    NSString *valueStr = @"";
    NSArray *temArr1;
	
	
	NSDictionary *dict = [mainContentTestView.string objectFromJSONString];

	NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
	if (dict)
	{
		[panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) 
		 {
			 
			 if(result == 0) 
				 return ;
			 _fileSavePath = [panel.URL path];

			 [self generateClassByJsonDic:dict className:classNameField.stringValue];
			 
		 }];
		
		
		return;
	}
	else
	{
		NSArray *tempArr =[[mainContentTestView.string stringByReplacingOccurrencesOfString:@"$" withString:@" "]componentsSeparatedByString:@"\n"];
		
		if (!_checkBtn.state)
		{
			for (int i = 0 ; i< [tempArr count] -1; i = i + 2 )
			{
				keyStr = [tempArr objectAtIndex:i+1];
				keyStr = [self sqliteTpyeName2OcTypeName:keyStr];
				
				valueStr = [tempArr objectAtIndex:i];
				
				if ([valueStr rangeOfString:@"_"].length > 0) {
					temArr1 = [valueStr componentsSeparatedByString:@"_"];
					for (int j = 0; j < [temArr1 count]; j++)
					{
						if (j == 0)
						{
							valueStr = [[temArr1 objectAtIndex:j] lowercaseString];
						}
						else
						{
							valueStr = [NSString stringWithFormat:@"%@%@",valueStr,[self uppercaseFirstChar:[temArr1 objectAtIndex:j]]];
						}
					}
				}
				[variablesDir setObject:keyStr forKey:valueStr];
			}
			
		}
		else
		{
			NSString *type = @"";
			NSString *name = @"";
			NSString *description = @"";
			for (int i = 0;i < [tempArr count] - 1; i = i + 3 )
			{
				NSString *varInfoString = @"";
				
				type = [tempArr objectAtIndex:i+1];
				type = [self sqliteTpyeName2OcTypeName:type];
				name = [tempArr objectAtIndex:i];
				description = [tempArr objectAtIndex:i + 2];
				
				if ([name rangeOfString:@"_"].length > 0) 
				{
					temArr1 = [name componentsSeparatedByString:@"_"];
					for (int j = 0; j < [temArr1 count]; j++)
					{
						if (j == 0) 
						{
							name = [[temArr1 objectAtIndex:j] lowercaseString];
						}
						else
						{
							name = [NSString stringWithFormat:@"%@%@",name,[self uppercaseFirstChar:[temArr1 objectAtIndex:j]]];
						}
						
					}
				}
				
				varInfoString = [NSString stringWithFormat:@"%@$%@$%@",name,type,description];
				[varsInfoArray addObject:varInfoString];
			}
			
			NSLog(@"%@",varsInfoArray);
			
			
			
		}
		

		[panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) 
		 {
			 
			 if(result == 0) 
				 return ;

			 _fileSavePath = [panel.URL path];

			 if (!_checkBtn.state)
			 {

				 [self generateClass:classNameField.stringValue forDic:variablesDir];
				 
			 }
			 else
			 {
				 [self generateClass:classNameField.stringValue andVarsInfo:varsInfoArray];
				 
			 }
			 
		 }];
		
	}

}

- (IBAction)checkProperty:(id)sender
{
    
    NSMutableDictionary *variablesDir = [[NSMutableDictionary alloc] init];
    NSArray *tempArr =[mainContentTestView.string componentsSeparatedByString:@"\n"];
    NSString *keyStr = @"";
    NSString *valueStr = @"";
    NSArray *temArr1;
    
    for (int i = 0 ; i< [tempArr count] -1; i = i + 2 )
    {
        keyStr = [tempArr objectAtIndex:i+1];
        keyStr = [self sqliteTpyeName2OcTypeName:keyStr];
        
        valueStr = [tempArr objectAtIndex:i];
        
        if ([valueStr rangeOfString:@"_"].length > 0)
        {
            temArr1 = [valueStr componentsSeparatedByString:@"_"];
            for (int j = 0; j < [temArr1 count]; j++)
            {
                if (j == 0) {
                    valueStr = [[temArr1 objectAtIndex:j] lowercaseString];
                }
                else
                    valueStr = [NSString stringWithFormat:@"%@%@",valueStr,[self uppercaseFirstChar:[temArr1 objectAtIndex:j]]];
            }
        }
        [variablesDir setObject:keyStr forKey:valueStr];
    }
    
    
    [self showPropertys:variablesDir];
    [variablesDir release];
}

- (IBAction)clearMainContent:(id)sender
{
    
    self.mainContentTestView.string = @"";
    
}




- (NSString *)sqliteTpyeName2OcTypeName:(NSString *)typeName
{
    NSString *resultStr = @"";
    if (!typeName ||[typeName length] == 0 )
    {
        NSLog(@"sqliteTypeName must be not null!");
    }
    else
    {
        resultStr = [_dataTypeConfigDictionary objectForKey:[typeName uppercaseString]];
        if (resultStr == nil) 
        {
            resultStr = @"NSObjetc *";
        }
    }
    return resultStr;
}

- (NSString *)defineKey:(NSString *)className varName:(NSString *)varName
{
	NSMutableString *result = [NSMutableString string];
	if (className && [className notEmpty])
	{
		[result appendFormat:@"%@_",[className uppercaseString]];
	}
	
	if (varName && [varName notEmpty])
	{
		[result appendFormat:@"%@_KEY",[varName uppercaseString]];

	}
	else
	{
		return @"";
	}
	
	return result;
	
}


@end
