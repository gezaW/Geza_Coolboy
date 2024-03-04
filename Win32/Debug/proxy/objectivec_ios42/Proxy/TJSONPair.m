//*******************************************************
//
//               Delphi DataSnap Framework
//
// Copyright(c) 1995-2020 Embarcadero Technologies, Inc.
//
//*******************************************************

#import "TJSONPair.h"



@implementation TJSONPair
@synthesize name,value;

-(id) initWithName:(NSString* )aName andValue:(TJSONValue*)aValue{
	self = [self init];
	if (self) {
		self.name = aName;
		self.value = aValue;
	}
	return self;

}
-(void) dealloc{
	[name release];
	[value release];
	[super dealloc];
}



@end


@implementation TJSONPair(JSONPairCreation)
+(id) JSONPairWithName:(NSString* )aName andValue:(TJSONValue*)aValue{
	return [[[TJSONPair alloc]initWithName:aName andValue:aValue]autorelease];

}
@end