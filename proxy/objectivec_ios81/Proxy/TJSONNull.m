//*******************************************************
//
//               Delphi DataSnap Framework
//
// Copyright(c) 1995-2020 Embarcadero Technologies, Inc.
//
//*******************************************************

#import "TJSONNull.h"


@implementation TJSONNull
-(NSString *) asJSONString{
	return @"null";
}
-(id) getInternalObject {
	return [NSNull null];
}
-(NSString *) toString{
	return [self asJSONString];
}
-(JSONValueType) getJSONValueType{
	return JSONNull;
}


@end
