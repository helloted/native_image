#import "NativeImagePlugin.h"
#import "GLRender.h"

@interface NativeImagePlugin()

@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *textures;

@end

@implementation NativeImagePlugin

- (instancetype) initWithTextures:(NSObject<FlutterTextureRegistry> *)textures {
    if (self = [super init]) {
        _textures = textures;
    }
    return self;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"native_image"
            binaryMessenger:[registrar messenger]];
  NativeImagePlugin* instance = [[NativeImagePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{

    if ([call.method isEqualToString:@"newTexture_1"]) {
  
        __block int64_t textureId = 0;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        __weak typeof(self) wself = self;

        GLRender *render = [[GLRender alloc] initWithFrameUpdateCallback:^{
//            [wself.textures textureFrameAvailable:textureId];
        }];
        
        [render startRenderWith:image];
        
        // 获取textureId
        textureId = [_textures registerTexture:render];
        NSLog(@"after===%lld",textureId);
        result(@(textureId));
    }
    
    if ([call.method isEqualToString:@"newTexture_2"]) {
  
        __block int64_t textureId = 0;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        
        __weak typeof(self) wself = self;
        GLRender *render = [[GLRender alloc] initWithFrameUpdateCallback:^{
//            [wself.textures textureFrameAvailable:textureId];
        }];
        
        

        
        // 获取textureId
        textureId = [_textures registerTexture:render];

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [render startRenderWith:image];
            [wself.textures textureFrameAvailable:textureId];
        });
        
        result(@(textureId));
    }
}

@end
