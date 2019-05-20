//
//  AGLKView.m
//  
//

#import "AGLKView.h"
#import <QuartzCore/QuartzCore.h>


@interface AGLKView ()

@property (nonatomic, assign) NSInteger			time;

@end

@implementation AGLKView

@synthesize delegate;
@synthesize context;
@synthesize drawableDepthFormat;

/////////////////////////////////////////////////////////////////
// This method returns the CALayer subclass to be used by  
// CoreAnimation with this view
/// 设置 View layer 类型
+ (Class)layerClass {
   return [CAEAGLLayer class];
}


/////////////////////////////////////////////////////////////////
// This method is designated initializer for the class 
- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext {
	
   if ((self = [super initWithFrame:frame])) {
	   
      CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
      
      eaglLayer.drawableProperties = 
         [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:NO], 
             kEAGLDrawablePropertyRetainedBacking, 
             kEAGLColorFormatRGBA8, 
             kEAGLDrawablePropertyColorFormat, 
             nil];
      
      self.context = aContext;
   }
   
   return self;
}


/////////////////////////////////////////////////////////////////
// This method is called automatically to initialize each Cocoa
// Touch object as the object is unarchived from an 
// Interface Builder .xib or .storyboard file.
- (id)initWithCoder:(NSCoder*)coder {
	
   if ((self = [super initWithCoder:coder])) {
	   
      CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
      
      eaglLayer.drawableProperties = 
         [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:NO], 
             kEAGLDrawablePropertyRetainedBacking, 
             kEAGLColorFormatRGBA8, 
             kEAGLDrawablePropertyColorFormat, 
             nil];          
   }
   
   return self;
}


/////////////////////////////////////////////////////////////////
// This method sets the receiver's OpenGL ES Context. If the 
// receiver already has a different Context, this method deletes
// OpenGL ES Frame Buffer resources in the old Context and the 
// recreates them in the new Context.
- (void)setContext:(EAGLContext *)aContext {
	
	// Delete any buffers previously created in old Context
   	if(context != aContext) {
		/// 设置上下文
      	[EAGLContext setCurrentContext:context];
		
		/// 删除帧缓冲对象
      	if (0 != defaultFrameBuffer) {
         	glDeleteFramebuffers(1, &defaultFrameBuffer); // Step 7
         	defaultFrameBuffer = 0;
      	}
		
		/// 删除由数组renderbuffers的元素命名的n个renderbuffer对象。 删除renderbuffer对象后，它没有内容，其名称可以被复用
      	if (0 != colorRenderBuffer) {
         	glDeleteRenderbuffers(1, &colorRenderBuffer); // Step 7
         	colorRenderBuffer = 0;
      	}
      	///
      	if (0 != depthRenderBuffer) {
         	glDeleteRenderbuffers(1, &depthRenderBuffer); // Step 7
         	depthRenderBuffer = 0;
      	}
      
      	context = aContext;
		
		// Configure the new Context with required buffers
      	if(nil != context) {

         	context = aContext;
         	[EAGLContext setCurrentContext:context];
			/// 创建一个帧染缓冲区对象
         	glGenFramebuffers(1, &defaultFrameBuffer);    // Step 1
			/// 将该帧染缓冲区对象绑定到管线上
         	glBindFramebuffer(                            // Step 2
            	GL_FRAMEBUFFER,
            	defaultFrameBuffer);

			/// 创建一个渲染缓冲区对象
         	glGenRenderbuffers(1, &colorRenderBuffer);    // Step 1
			/// 将该渲染缓冲区对象绑定到管线上
         	glBindRenderbuffer(                           // Step 2
            				GL_RENDERBUFFER,
            				colorRenderBuffer);
         
         	// Attach color render buffer to bound Frame Buffer
			/// 将创建的渲染缓冲区绑定到帧缓冲区上，并使用颜色填充
         	glFramebufferRenderbuffer(
            	GL_FRAMEBUFFER,
            	GL_COLOR_ATTACHMENT0,
            	GL_RENDERBUFFER,
            	colorRenderBuffer);

         	// Create any additional render buffers based on the
         	// drawable size of defaultFrameBuffer
         	[self layoutSubviews];
      }
   }
}


/////////////////////////////////////////////////////////////////
// This method returns the receiver's OpenGL ES Context
- (EAGLContext *)context {
   return context;
}


/////////////////////////////////////////////////////////////////
// Calling this method tells the receiver to redraw the contents 
// of its associated OpenGL ES Frame Buffer. This method 
// configures OpenGL ES and then calls -drawRect:
- (void)display {
	
	/// 设置上下文
   	[EAGLContext setCurrentContext:self.context];
	///
	
	if (self.time % 2 == 0) {
		glViewport(0, 0, (GLint)self.drawableWidth * 0.5, (GLint)self.drawableHeight * 0.5);
	} else {
		glViewport(0, 0, (GLint)self.drawableWidth, (GLint)self.drawableHeight);
	}
   	[self drawRect:[self bounds]];
   
   	[self.context presentRenderbuffer:GL_RENDERBUFFER];
	
	
//	self.time++;
}


/////////////////////////////////////////////////////////////////
// This method is called automatically whenever the receiver
// needs to redraw the contents of its associated OpenGL ES
// Frame Buffer. This method should not be called directly. Call
// -display instead which configures OpenGL ES before calling
// -drawRect:
- (void)drawRect:(CGRect)rect {
   if(delegate) {
      [self.delegate glkView:self drawInRect:[self bounds]];
   }
}


/////////////////////////////////////////////////////////////////
// This method is called automatically whenever a UIView is 
// resized including just after the view is added to a UIWindow.
/// 界面发生大小的时候调用
- (void)layoutSubviews {

   CAEAGLLayer 	*eaglLayer = (CAEAGLLayer *)self.layer;
   
   // Make sure our context is current
   [EAGLContext setCurrentContext:self.context];

   // Initialize the current Frame Buffer’s pixel color buffer 
   // so that it shares the corresponding Core Animation Layer’s
   // pixel color storage.
   [self.context renderbufferStorage:GL_RENDERBUFFER 
						fromDrawable:eaglLayer];
      
   
   if (0 != depthRenderBuffer) {
      glDeleteRenderbuffers(1, &depthRenderBuffer); // Step 7
      depthRenderBuffer = 0;
   }
   
   GLint currentDrawableWidth = (GLint)self.drawableWidth;
   GLint currentDrawableHeight = (GLint)self.drawableHeight;
   
   if(self.drawableDepthFormat !=  AGLKViewDrawableDepthFormatNone
	  		&& 0 < currentDrawableWidth && 0 < currentDrawableHeight) {

      glGenRenderbuffers(1, &depthRenderBuffer); // Step 1
      glBindRenderbuffer(GL_RENDERBUFFER,        // Step 2
         depthRenderBuffer);
      glRenderbufferStorage(GL_RENDERBUFFER,     // Step 3 
         GL_DEPTH_COMPONENT16, 
         currentDrawableWidth, 
         currentDrawableHeight);
      glFramebufferRenderbuffer(GL_FRAMEBUFFER,  // Step 4 
         GL_DEPTH_ATTACHMENT, 
         GL_RENDERBUFFER, 
         depthRenderBuffer);
   }
   
   // Check for any errors configuring the render buffer   
   GLenum status = glCheckFramebufferStatus(
      GL_FRAMEBUFFER) ;
     
   if(status != GL_FRAMEBUFFER_COMPLETE) {
       NSLog(@"failed to make complete frame buffer object %x", status);
   }

   // Make the Color Render Buffer the current buffer for display
   glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
}


/////////////////////////////////////////////////////////////////
// This method returns the width in pixels of current context's
// Pixel Color Render Buffer
/// 绘制宽度
- (NSInteger)drawableWidth {
	
   GLint          backingWidth;
   glGetRenderbufferParameteriv(
      GL_RENDERBUFFER, 
      GL_RENDERBUFFER_WIDTH, 
      &backingWidth);

   return (NSInteger)backingWidth;
}

/////////////////////////////////////////////////////////////////
// This method returns the height in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableHeight {
   	GLint          backingHeight;

	/// https://blog.csdn.net/flycatdeng/article/details/82667195
   	glGetRenderbufferParameteriv(
								 GL_RENDERBUFFER,
								 GL_RENDERBUFFER_HEIGHT,
								 &backingHeight);
      
   	return (NSInteger)backingHeight;
}

/////////////////////////////////////////////////////////////////
// This method is called automatically when the reference count 
// for a Cocoa Touch object reaches zero.
/// 释放 view 释放上下文
- (void)dealloc {
   	// Make sure the receiver's OpenGL ES Context is not current
   	if ([EAGLContext currentContext] == context) {
		[EAGLContext setCurrentContext:nil];
   	}
   	// Deletes the receiver's OpenGL ES Context
   	context = nil;
}

@end
