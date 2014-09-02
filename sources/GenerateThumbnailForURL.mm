#import <QuickLook/QuickLook.h>
#import "font_renderer.h"


NYX_EXTERN_C_BEGIN
OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);


OSStatus GenerateThumbnailForURL(__unused void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, __unused CFDictionaryRef options, __unused CGSize maxSize)
{
	CGImageRef imgRef = create_image_for_font_at_url([(__bridge NSURL*)url path]);
	if (imgRef)
	{
		QLThumbnailRequestSetImage(thumbnail, imgRef, NULL);
		CGImageRelease(imgRef);
	}
	else
	{
		// Fail to create image
		QLThumbnailRequestSetThumbnailWithURLRepresentation(thumbnail, url, contentTypeUTI, NULL, NULL);
	}

    return kQLReturnNoError;
}

void CancelThumbnailGeneration(__unused void *thisInterface, __unused QLThumbnailRequestRef thumbnail)
{
}

NYX_EXTERN_C_END
