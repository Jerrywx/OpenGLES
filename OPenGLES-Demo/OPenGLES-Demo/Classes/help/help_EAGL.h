//
//  help_EAGL.h
//  OPenGLES-Demo
//
//  Created by 王潇 on 2019/5/18.
//  Copyright © 2019 王潇. All rights reserved.
//

#ifndef help_EAGL_h
#define help_EAGL_h


#ifdef __cplusplus
#define EAGL_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define EAGL_EXTERN extern __attribute__((visibility ("default")))
#endif

#define EAGL_EXTERN_CLASS __attribute__((visibility("default")))

/************************************************************************/
/* EAGL API Version                                                     */
/************************************************************************/
#define EAGL_MAJOR_VERSION   1
#define EAGL_MINOR_VERSION   0


/************************************************************************/
/* EAGL Enumerated values                                               */
/************************************************************************/

/* EAGL rendering API */
typedef NS_ENUM(NSUInteger, EAGLRenderingAPI) {
	kEAGLRenderingAPIOpenGLES1 = 1,
	kEAGLRenderingAPIOpenGLES2 = 2,
	kEAGLRenderingAPIOpenGLES3 = 3,
};

NS_ASSUME_NONNULL_BEGIN

/************************************************************************/
/* EAGL Functions                                                       */
/************************************************************************/

EAGL_EXTERN void EAGLGetVersion(unsigned int* major, unsigned int* minor) OPENGLES_DEPRECATED(ios(2.0, 12.0), tvos(9.0, 12.0));

/************************************************************************/
/* EAGL Sharegroup                                                      */
/************************************************************************/

EAGL_EXTERN_CLASS
@interface EAGLSharegroup : NSObject
{
	@package
	struct _EAGLSharegroupPrivate *_private;
}

@property (nullable, copy, nonatomic) NSString* debugLabel NS_AVAILABLE_IOS(6_0);

@end

/************************************************************************/
/* EAGL Context                                                         */
/************************************************************************/

//// 
@interface EAGLContext : NSObject {
@public
	struct _EAGLContextPrivate *_private;
}

- (nullable instancetype) init NS_UNAVAILABLE;
- (nullable instancetype) initWithAPI:(EAGLRenderingAPI) api;
- (nullable instancetype) initWithAPI:(EAGLRenderingAPI) api sharegroup:(EAGLSharegroup*) sharegroup NS_DESIGNATED_INITIALIZER;

+ (BOOL)                     setCurrentContext:(nullable EAGLContext*) context;
+ (nullable EAGLContext*)    currentContext;

@property (readonly)          EAGLRenderingAPI   API;
@property (nonnull, readonly) EAGLSharegroup*    sharegroup;

@property (nullable, copy, nonatomic) NSString* debugLabel NS_AVAILABLE_IOS(6_0);
@property (getter=isMultiThreaded, nonatomic) BOOL multiThreaded NS_AVAILABLE_IOS(7_1);
@end

NS_ASSUME_NONNULL_END

#endif /* help_EAGL_h */
