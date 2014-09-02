#import <QuickLook/QuickLook.h>
#import "font_renderer.h"


NYX_EXTERN_C_BEGIN
OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);


OSStatus GeneratePreviewForURL(__unused void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, __unused CFDictionaryRef options)
{
	CGImageRef imgRef = create_image_for_font_at_url([(__bridge NSURL*)url path]);
	if (imgRef != NULL)
	{
		const CGFloat width = (CGFloat)CGImageGetWidth(imgRef);
		const CGFloat height = (CGFloat)CGImageGetHeight(imgRef);
		CGContextRef ctx = QLPreviewRequestCreateContext(preview, (CGSize){.width = width, .height = height}, true, NULL);
		CGContextDrawImage(ctx, (CGRect){.origin = CGPointZero, .size.width = width, .size.height = height}, imgRef);
		QLPreviewRequestFlushContext(preview, ctx);
		CGContextRelease(ctx);
		CGImageRelease(imgRef);
	}
	else
	{
		// Fail to create image
		QLPreviewRequestSetURLRepresentation(preview, url, contentTypeUTI, NULL);
	}

	return kQLReturnNoError;
}

void CancelPreviewGeneration(__unused void *thisInterface, __unused QLPreviewRequestRef preview)
{
}

NYX_EXTERN_C_END
