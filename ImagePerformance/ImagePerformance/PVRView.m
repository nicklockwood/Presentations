//
//  PVRView.m
//  ImagePerformance
//
//  Created by Nick Lockwood on 03/05/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "PVRView.h"
#import <OpenGLES/ES2/gl.h>


@interface PVRView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) GLKBaseEffect *effect;
@property (nonatomic, strong) GLKTextureInfo *textureInfo;
@property (nonatomic, assign) CGFloat previousScale;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGPoint previousOffset;
@property (nonatomic, assign) CGPoint offset;

@end


@implementation PVRView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        //create context
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:self.context];
        self.layer.opaque = NO;

        //load texture
        glActiveTexture(GL_TEXTURE0);
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"Untitled" ofType:@"pvr" inDirectory:@"PVR"];
        self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:imageFile options:nil error:NULL];
        
        //create texture
        GLKEffectPropertyTexture *texture = [[GLKEffectPropertyTexture alloc] init];
        texture.enabled = YES;
        texture.envMode = GLKTextureEnvModeDecal;
        texture.name = self.textureInfo.name;
        
        //set up base effect
        self.effect = [[GLKBaseEffect alloc] init];
        self.effect.texture2d0.name = texture.name;
        
        //set up transform
        _scale = 0.5;
        _previousScale = _scale;
        [self updateTransform];
    }
    return self;
}

- (void)updateTransform
{
    self.effect.transform.modelviewMatrix = GLKMatrix4Translate(GLKMatrix4MakeScale(self.scale, self.scale, 1), self.offset.x, self.offset.y, 0);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return gestureRecognizer.view == self && otherGestureRecognizer.view == self;
}

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)pinchGesture
{
    switch (pinchGesture.state)
    {
        case UIGestureRecognizerStateChanged:
        {
            self.scale = self.previousScale * pinchGesture.scale;
            [self updateTransform];
            [self setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.previousScale = self.scale;
            break;
        }
        default:
        {
            //do nothing
        }
    }
}

- (IBAction)panGesture:(UIPanGestureRecognizer *)panGesture
{
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateChanged:
        {
            CGPoint offset = [panGesture translationInView:panGesture.view];
            offset.x /= self.bounds.size.width;
            offset.y /= self.bounds.size.height;
            offset.y *= -1;
            offset.x += self.previousOffset.x;
            offset.y += self.previousOffset.y;
            self.offset = offset;
            
            [self updateTransform];
            [self setNeedsDisplay];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            self.previousOffset = self.offset;
            break;
        }
        default:
        {
            //do nothing
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    //bind shader program
    [self.effect prepareToDraw];

    //clear the screen
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0.0, 0.0, 0.0, 0.0);
    
    //set up vertices
    GLfloat vertices[] =
    {
        -1.0f, -1.0f,
        -1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, -1.0f
    };
    
    //set up colors
    GLfloat texCoords[] =
    {
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
        1.0f, 1.0f
    };
    
    //draw triangle
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}

@end
