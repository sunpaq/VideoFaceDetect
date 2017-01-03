/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	View controller for camera interface.
*/

#import "AVCamCameraViewController.h"
#import "AVCamVideoCaptureDelegate.h"
#import "TXQcloudFrSDK.h"
#import "Auth.h"
#import "Conf.h"

static void * SessionRunningContext = &SessionRunningContext;

@implementation AVCaptureDeviceDiscoverySession (Utilities)

- (NSInteger)uniqueDevicePositionsCount
{
	NSMutableArray<NSNumber *> *uniqueDevicePositions = [NSMutableArray array];
	
	for ( AVCaptureDevice *device in self.devices ) {
		if ( ! [uniqueDevicePositions containsObject:@(device.position)] ) {
			[uniqueDevicePositions addObject:@(device.position)];
		}
	}
	
	return uniqueDevicePositions.count;
}

@end

@interface AVCamCameraViewController ()
@property (nonatomic, strong) AVCamVideoCaptureDelegate* sampleBufferDelegate;
@property (nonatomic, strong) TXQcloudFrSDK *sdk;
@end

@implementation AVCamCameraViewController

#pragma mark View Controller Life Cycle

//- (CGRect) previewFrame
//{
//    CGPoint center = self.previewView.center;
//    CGSize  size   = self.previewView.frame.size;
//    return CGRectMake(center.x - size.width / 2.0,
//                      center.y - size.height / 2.0,
//                      size.width,
//                      size.height);
//}


//[dict setValue:@"true" forKey:@"hasSmile"];
//[dict setValue:[NSNumber numberWithInt:f.trackingID] forKey:@"trackingID"];
//[dict setValue:[NSNumber numberWithInt:f.trackingFrameCount] forKey:@"trackingFrameCount"];
//[dict setValue:[NSValue valueWithCGPoint:f.leftEyePosition] forKey:@"leftEyePosition"];
//[dict setValue:[NSValue valueWithCGPoint:f.rightEyePosition] forKey:@"rightEyePosition"];
//[dict setValue:[NSValue valueWithCGPoint:f.mouthPosition] forKey:@"mouthPosition"];
//[dict setValue:[NSNumber numberWithFloat:f.faceAngle] forKey:@"faceAngle"];

static int count = 0;
static bool detected = false;

- (void) updateFaceLabelFrameInUIThread:(CGRect)frame WithData:(NSDictionary*)data
{
    //self.data = data;


    dispatch_async(dispatch_get_main_queue(), ^{
        
        count++;
        if (self.faceImage) {
            count = 0;
            //UIImage* test = [UIImage imageNamed:@"face.jpg"];
            
            NSData* pngdata = UIImageJPEGRepresentation(self.faceImage, 1.0);
            UIImage* face = [UIImage imageWithData:pngdata];
            if (face) {
                self.faceView.image = face;
            }
            
            [self.sdk detectFace:face successBlock:^(id responseObject) {
                NSDictionary* dict = (NSDictionary*)responseObject;
                NSArray* faces = [dict objectForKey:@"face"];
                if ([faces count] > 0) {
                    NSDictionary* face = [faces objectAtIndex:0];
                    NSString* beauty = [face objectForKey:@"beauty"];
                    NSString* age = [face objectForKey:@"age"];
                    NSString* gender = [face objectForKey:@"gender"];
                    int genscore = [gender intValue];
                    NSString* sex = @"女";
                    self.faceLabel.backgroundColor = [UIColor redColor];
                    self.faceLabel.alpha = 0.1;
                    if (genscore > 50) {
                        sex = @"男";
                        self.faceLabel.backgroundColor = [UIColor blueColor];
                        self.faceLabel.alpha = 0.1;
                    }
                    //self.faceLabel.text = [NSString stringWithFormat:@"颜值:%@ 年龄:%@ 性别:%@", beauty, age, sex];
                    self.navigationItem.title = [NSString stringWithFormat:@"颜值:%@ 年龄:%@ 性别:%@", beauty, age, sex];
                    NSLog(@"responseObject: %@", [face description]);
                    detected = true;
                    
                }

            }failureBlock:^(NSError *error) {
                //NSLog(@"error: %@\n", error.description);
            }];
            
        }
        else {
            //NSLog(@"error: image is nil");
        }
        
        
        
        CGRect scaleFrame = frame;
        CGRect viewFrame  = _previewView.frame;
        
        CGRect frame = CGRectMake(viewFrame.origin.x + viewFrame.size.width * scaleFrame.origin.x,
                                  viewFrame.origin.y + viewFrame.size.height * scaleFrame.origin.y,
                                  viewFrame.size.width * scaleFrame.size.width,
                                  viewFrame.size.height * (scaleFrame.size.height + 0.05));
        
        //NSNumber* tid = [self.data objectForKey:@"trackingFrameCount"];
        //[self.faceLabel setText:[NSString stringWithFormat:@"%d", tid.intValue]];
        
        [_faceLabel setFrame:frame];
        [_faceLabel setNeedsLayout];
        [_faceLabel setNeedsDisplay];
        [self.view layoutIfNeeded];
    });
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    NSString *auth = [Auth appSign:1000000 userId:nil];
    self.sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId authorization:auth endPoint:[Conf instance].API_END_POINT];
    
    self.faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.faceLabel.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:0.25];
    self.faceLabel.text = @"";
    self.faceLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    self.faceLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.faceLabel];
    
    //full of the view
    self.previewView.frame = self.view.frame;
    
    self.sampleBufferDelegate = [[AVCamVideoCaptureDelegate alloc] initWithCameraViewController:self];
    //self.faceFrame.hidden = YES;
	
	// Disable UI. The UI is enabled if and only if the session starts running.
	self.cameraButton.enabled = NO;
	self.recordButton.enabled = NO;
	self.photoButton.enabled = NO;
	//self.livePhotoModeButton.enabled = NO;
	self.captureModeControl.enabled = NO;
	
	// Create the AVCaptureSession.
	self.session = [[AVCaptureSession alloc] init];
	
	// Create a device discovery session.
	NSArray<AVCaptureDeviceType> *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, AVCaptureDeviceTypeBuiltInDuoCamera];
	self.videoDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionUnspecified];
	
	// Set up the preview view.
	self.previewView.session = self.session;
	
	// Communicate with the session and other session objects on this queue.
	self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
	
	self.setupResult = AVCamSetupResultSuccess;
	
	/*
		Check video authorization status. Video access is required and audio
		access is optional. If audio access is denied, audio is not recorded
		during movie recording.
	*/
	switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
	{
		case AVAuthorizationStatusAuthorized:
		{
			// The user has previously granted access to the camera.
			break;
		}
		case AVAuthorizationStatusNotDetermined:
		{
			/*
				The user has not yet been presented with the option to grant
				video access. We suspend the session queue to delay session
				setup until the access request has completed.
				
				Note that audio access will be implicitly requested when we
				create an AVCaptureDeviceInput for audio during session setup.
			*/
			dispatch_suspend( self.sessionQueue );
			[AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
				if ( ! granted ) {
					self.setupResult = AVCamSetupResultCameraNotAuthorized;
				}
				dispatch_resume( self.sessionQueue );
			}];
			break;
		}
		default:
		{
			// The user has previously denied access.
			self.setupResult = AVCamSetupResultCameraNotAuthorized;
			break;
		}
	}
	
	/*
		Setup the capture session.
		In general it is not safe to mutate an AVCaptureSession or any of its
		inputs, outputs, or connections from multiple threads at the same time.
		
		Why not do all of this on the main queue?
		Because -[AVCaptureSession startRunning] is a blocking call which can
		take a long time. We dispatch session setup to the sessionQueue so
		that the main queue isn't blocked, which keeps the UI responsive.
	*/
	dispatch_async( self.sessionQueue, ^{
		[self configureSession];
	} );
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	dispatch_async( self.sessionQueue, ^{
		switch ( self.setupResult )
		{
			case AVCamSetupResultSuccess:
			{
				// Only setup observers and start the session running if setup succeeded.
				[self addObservers];
				[self.session startRunning];
				self.sessionRunning = self.session.isRunning;
				break;
			}
			case AVCamSetupResultCameraNotAuthorized:
			{
				dispatch_async( dispatch_get_main_queue(), ^{
					NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
					[alertController addAction:cancelAction];
					// Provide quick access to Settings.
					UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
					}];
					[alertController addAction:settingsAction];
					[self presentViewController:alertController animated:YES completion:nil];
				} );
				break;
			}
			case AVCamSetupResultSessionConfigurationFailed:
			{
				dispatch_async( dispatch_get_main_queue(), ^{
					NSString *message = NSLocalizedString( @"Unable to capture media", @"Alert message when something goes wrong during capture session configuration" );
					UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
					[alertController addAction:cancelAction];
					[self presentViewController:alertController animated:YES completion:nil];
				} );
				break;
			}
		}
	} );
}

- (void)viewDidDisappear:(BOOL)animated
{
	dispatch_async( self.sessionQueue, ^{
		if ( self.setupResult == AVCamSetupResultSuccess ) {
			[self.session stopRunning];
			[self removeObservers];
		}
	} );
	
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate
{
	// Disable autorotation of the interface when recording is in progress.
	return ! self.movieFileOutput.isRecording;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskAll;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	
	UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
	
	if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
		self.previewView.videoPreviewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
	}
}

#pragma mark Session Management


// Call this on the session queue.
- (void)configureSession
{
	if ( self.setupResult != AVCamSetupResultSuccess ) {
		return;
	}
	
	NSError *error = nil;
	
	[self.session beginConfiguration];
	
	/*
		We do not create an AVCaptureMovieFileOutput when setting up the session because the
		AVCaptureMovieFileOutput does not support movie recording with AVCaptureSessionPresetPhoto.
	*/
	self.session.sessionPreset = AVCaptureSessionPresetPhoto;
	
	// Add video input.
	
	// Choose the back dual camera if available, otherwise default to a wide angle camera.
	AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInDuoCamera
                                                                      mediaType:AVMediaTypeVideo
                                                                       position:AVCaptureDevicePositionBack];
	if ( ! videoDevice ) {
		// If the back dual camera is not available, default to the back wide angle camera.
		videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                         mediaType:AVMediaTypeVideo
                                                          position:AVCaptureDevicePositionFront];
		
		// In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
		if ( ! videoDevice ) {
			videoDevice = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                             mediaType:AVMediaTypeVideo
                                                              position:AVCaptureDevicePositionBack];
		}
	}
	AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice
                                                                                   error:&error];
	if ( ! videoDeviceInput ) {
		NSLog( @"Could not create video device input: %@", error );
		self.setupResult = AVCamSetupResultSessionConfigurationFailed;
		[self.session commitConfiguration];
		return;
	}
	if ( [self.session canAddInput:videoDeviceInput] ) {
		[self.session addInput:videoDeviceInput];
		self.videoDeviceInput = videoDeviceInput;
		
		dispatch_async( dispatch_get_main_queue(), ^{
			/*
				Why are we dispatching this to the main queue?
				Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView
				can only be manipulated on the main thread.
				Note: As an exception to the above rule, it is not necessary to serialize video orientation changes
				on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
				
				Use the status bar orientation as the initial video orientation. Subsequent orientation changes are
				handled by -[AVCamCameraViewController viewWillTransitionToSize:withTransitionCoordinator:].
			*/
			UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
			AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
			if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
				initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
			}
			
            self.previewView.videoPreviewLayer.connection.videoOrientation = initialVideoOrientation;
		} );
	}
	else {
		NSLog( @"Could not add video device input to the session" );
		self.setupResult = AVCamSetupResultSessionConfigurationFailed;
		[self.session commitConfiguration];
		return;
	}
    
    // Add video output
    dispatch_queue_t sampleBufferQueue = dispatch_queue_create("sampleBufferQueue", DISPATCH_QUEUE_SERIAL);
    AVCaptureVideoDataOutput* videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoOutput setSampleBufferDelegate:self.sampleBufferDelegate queue:sampleBufferQueue];
    
    if ([self.session canAddOutput:videoOutput]) {
        [self.session addOutput:videoOutput];
    }
    
	// Add audio input.
	AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
	AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
	if ( ! audioDeviceInput ) {
		NSLog( @"Could not create audio device input: %@", error );
	}
	if ( [self.session canAddInput:audioDeviceInput] ) {
		[self.session addInput:audioDeviceInput];
	}
	else {
		NSLog( @"Could not add audio device input to the session" );
	}
	
	// Add photo output.
	AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
	if ( [self.session canAddOutput:photoOutput] ) {
		[self.session addOutput:photoOutput];
		self.photoOutput = photoOutput;
		
		self.photoOutput.highResolutionCaptureEnabled = YES;
		self.photoOutput.livePhotoCaptureEnabled = self.photoOutput.livePhotoCaptureSupported;
	}
	else {
		NSLog( @"Could not add photo output to the session" );
		self.setupResult = AVCamSetupResultSessionConfigurationFailed;
		[self.session commitConfiguration];
		return;
	}
	
	self.backgroundRecordingID = UIBackgroundTaskInvalid;
	
	[self.session commitConfiguration];
}

- (IBAction)resumeInterruptedSession:(id)sender
{
	dispatch_async( self.sessionQueue, ^{
		/*
			The session might fail to start running, e.g., if a phone or FaceTime call is still
			using audio or video. A failure to start the session running will be communicated via
			a session runtime error notification. To avoid repeatedly failing to start the session
			running, we only try to restart the session running in the session runtime error handler
			if we aren't trying to resume the session running.
		*/
		[self.session startRunning];
		self.sessionRunning = self.session.isRunning;
		if ( ! self.session.isRunning ) {
			dispatch_async( dispatch_get_main_queue(), ^{
				NSString *message = NSLocalizedString( @"Unable to resume", @"Alert message when unable to resume the session running" );
				UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
				[alertController addAction:cancelAction];
				[self presentViewController:alertController animated:YES completion:nil];
			} );
		}
		else {
			dispatch_async( dispatch_get_main_queue(), ^{
				self.resumeButton.hidden = YES;
			} );
		}
	} );
}

- (IBAction)toggleCaptureMode:(UISegmentedControl *)captureModeControl
{
	if ( captureModeControl.selectedSegmentIndex == AVCamCaptureModePhoto ) {
		self.recordButton.enabled = NO;
		
		dispatch_async( self.sessionQueue, ^{
			/*
				Remove the AVCaptureMovieFileOutput from the session because movie recording is
				not supported with AVCaptureSessionPresetPhoto. Additionally, Live Photo
				capture is not supported when an AVCaptureMovieFileOutput is connected to the session.
			*/
			[self.session beginConfiguration];
			[self.session removeOutput:self.movieFileOutput];
			self.session.sessionPreset = AVCaptureSessionPresetPhoto;
			[self.session commitConfiguration];
			
			self.movieFileOutput = nil;
			
			if ( self.photoOutput.livePhotoCaptureSupported ) {
				self.photoOutput.livePhotoCaptureEnabled = YES;
				
//				dispatch_async( dispatch_get_main_queue(), ^{
//					self.livePhotoModeButton.enabled = YES;
//					self.livePhotoModeButton.hidden = NO;
//				} );
			}
		} );
	}
	else if ( captureModeControl.selectedSegmentIndex == AVCamCaptureModeMovie ) {
		//self.livePhotoModeButton.hidden = YES;
		
		dispatch_async( self.sessionQueue, ^{
			AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
			
			if ( [self.session canAddOutput:movieFileOutput] )
			{
				[self.session beginConfiguration];
				[self.session addOutput:movieFileOutput];
				self.session.sessionPreset = AVCaptureSessionPresetHigh;
				AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
				if ( connection.isVideoStabilizationSupported ) {
					connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
				}
				[self.session commitConfiguration];
				
				self.movieFileOutput = movieFileOutput;
				
				dispatch_async( dispatch_get_main_queue(), ^{
					self.recordButton.enabled = YES;
				} );
			}
		} );
	}
}

#pragma mark Device Configuration

- (IBAction)changeCamera:(id)sender
{
	self.cameraButton.enabled = NO;
	self.recordButton.enabled = NO;
	self.photoButton.enabled = NO;
	//self.livePhotoModeButton.enabled = NO;
	self.captureModeControl.enabled = NO;
	
	dispatch_async( self.sessionQueue, ^{
		AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
		AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
		
		AVCaptureDevicePosition preferredPosition;
		AVCaptureDeviceType preferredDeviceType;
		
		switch ( currentPosition )
		{
			case AVCaptureDevicePositionUnspecified:
			case AVCaptureDevicePositionFront:
				preferredPosition = AVCaptureDevicePositionBack;
				preferredDeviceType = AVCaptureDeviceTypeBuiltInDuoCamera;
				break;
			case AVCaptureDevicePositionBack:
				preferredPosition = AVCaptureDevicePositionFront;
				preferredDeviceType = AVCaptureDeviceTypeBuiltInWideAngleCamera;
				break;
		}
		
		NSArray<AVCaptureDevice *> *devices = self.videoDeviceDiscoverySession.devices;
		AVCaptureDevice *newVideoDevice = nil;
		
		// First, look for a device with both the preferred position and device type.
		for ( AVCaptureDevice *device in devices ) {
			if ( device.position == preferredPosition && [device.deviceType isEqualToString:preferredDeviceType] ) {
				newVideoDevice = device;
				break;
			}
		}
		
		// Otherwise, look for a device with only the preferred position.
		if ( ! newVideoDevice ) {
			for ( AVCaptureDevice *device in devices ) {
				if ( device.position == preferredPosition ) {
					newVideoDevice = device;
					break;
				}
			}
		}
		
		if ( newVideoDevice ) {
			AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newVideoDevice error:NULL];
			
			[self.session beginConfiguration];
			
			// Remove the existing device input first, since using the front and back camera simultaneously is not supported.
			[self.session removeInput:self.videoDeviceInput];
			
			if ( [self.session canAddInput:videoDeviceInput] ) {
				[[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
				
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:newVideoDevice];
				
				[self.session addInput:videoDeviceInput];
				self.videoDeviceInput = videoDeviceInput;
			}
			else {
				[self.session addInput:self.videoDeviceInput];
			}
			
			AVCaptureConnection *movieFileOutputConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			if ( movieFileOutputConnection.isVideoStabilizationSupported ) {
				movieFileOutputConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
			}
			
			/*
				Set Live Photo capture enabled if it is supported. When changing cameras, the
				`livePhotoCaptureEnabled` property of the AVCapturePhotoOutput gets set to NO when
				a video device is disconnected from the session. After the new video device is
				added to the session, re-enable Live Photo capture on the AVCapturePhotoOutput if it is supported.
			 */
			self.photoOutput.livePhotoCaptureEnabled = self.photoOutput.livePhotoCaptureSupported;
			
			[self.session commitConfiguration];
		}
		
		dispatch_async( dispatch_get_main_queue(), ^{
			self.cameraButton.enabled = YES;
			self.recordButton.enabled = self.captureModeControl.selectedSegmentIndex == AVCamCaptureModeMovie;
			self.photoButton.enabled = YES;
			//self.livePhotoModeButton.enabled = YES;
			self.captureModeControl.enabled = YES;
		} );
	} );
}

- (IBAction)focusAndExposeTap:(UIGestureRecognizer *)gestureRecognizer
{
	CGPoint devicePoint = [self.previewView.videoPreviewLayer captureDevicePointOfInterestForPoint:[gestureRecognizer locationInView:gestureRecognizer.view]];
	[self focusWithMode:AVCaptureFocusModeAutoFocus exposeWithMode:AVCaptureExposureModeAutoExpose atDevicePoint:devicePoint monitorSubjectAreaChange:YES];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
	dispatch_async( self.sessionQueue, ^{
		AVCaptureDevice *device = self.videoDeviceInput.device;
		NSError *error = nil;
		if ( [device lockForConfiguration:&error] ) {
			/*
				Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
				Call set(Focus/Exposure)Mode() to apply the new point of interest.
			*/
			if ( device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
				device.focusPointOfInterest = point;
				device.focusMode = focusMode;
			}
			
			if ( device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
				device.exposurePointOfInterest = point;
				device.exposureMode = exposureMode;
			}
			
			device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
			[device unlockForConfiguration];
		}
		else {
			NSLog( @"Could not lock device for configuration: %@", error );
		}
	} );
}

#pragma mark Capturing Photos

- (IBAction)capturePhoto:(id)sender
{
	/*
		Retrieve the video preview layer's video orientation on the main queue before
		entering the session queue. We do this to ensure UI elements are accessed on
		the main thread and session configuration is done on the session queue.
	*/
	AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = self.previewView.videoPreviewLayer.connection.videoOrientation;

	dispatch_async( self.sessionQueue, ^{
		
		// Update the photo output's connection to match the video orientation of the video preview layer.
		AVCaptureConnection *photoOutputConnection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
		photoOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
		
		// Capture a JPEG photo with flash set to auto and high resolution photo enabled.
		AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettings];
		photoSettings.flashMode = AVCaptureFlashModeAuto;
		photoSettings.highResolutionPhotoEnabled = YES;
		if ( photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0 ) {
			photoSettings.previewPhotoFormat = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : photoSettings.availablePreviewPhotoPixelFormatTypes.firstObject };
		}
		
		// Use a separate object for the photo capture delegate to isolate each capture life cycle.
		AVCamPhotoCaptureDelegate *photoCaptureDelegate = [[AVCamPhotoCaptureDelegate alloc] initWithRequestedPhotoSettings:photoSettings willCapturePhotoAnimation:^{
			dispatch_async( dispatch_get_main_queue(), ^{
				self.previewView.videoPreviewLayer.opacity = 0.0;
				[UIView animateWithDuration:0.25 animations:^{
					self.previewView.videoPreviewLayer.opacity = 1.0;
				}];
			} );
		} capturingLivePhoto:^( BOOL capturing ) {
			/*
				Because Live Photo captures can overlap, we need to keep track of the
				number of in progress Live Photo captures to ensure that the
				Live Photo label stays visible during these captures.
			*/
		} completed:^( AVCamPhotoCaptureDelegate *photoCaptureDelegate ) {
			// When the capture is complete, remove a reference to the photo capture delegate so it can be deallocated.
		}];
		
		/*
			The Photo Output keeps a weak reference to the photo capture delegate so
			we store it in an array to maintain a strong reference to this object
			until the capture is completed.
		*/
		[self.photoOutput capturePhotoWithSettings:photoSettings delegate:photoCaptureDelegate];
	} );
}

#pragma mark Recording Movies

- (IBAction)toggleMovieRecording:(id)sender
{
	/*
		Disable the Camera button until recording finishes, and disable
		the Record button until recording starts or finishes.
		
		See the AVCaptureFileOutputRecordingDelegate methods.
	 */
	self.cameraButton.enabled = NO;
	self.recordButton.enabled = NO;
	self.captureModeControl.enabled = NO;
	
	/*
		Retrieve the video preview layer's video orientation on the main queue
		before entering the session queue. We do this to ensure UI elements are
		accessed on the main thread and session configuration is done on the session queue.
	*/
	AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = self.previewView.videoPreviewLayer.connection.videoOrientation;
	
	dispatch_async( self.sessionQueue, ^{
		if ( ! self.movieFileOutput.isRecording ) {
			if ( [UIDevice currentDevice].isMultitaskingSupported ) {
				/*
					Setup background task.
					This is needed because the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
					callback is not received until AVCam returns to the foreground unless you request background execution time.
					This also ensures that there will be time to write the file to the photo library when AVCam is backgrounded.
					To conclude this background execution, -[endBackgroundTask:] is called in
					-[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
				*/
				self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
			}
			
			// Update the orientation on the movie file output video connection before starting recording.
			AVCaptureConnection *movieFileOutputConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
			movieFileOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
			
			// Start recording to a temporary file.
			NSString *outputFileName = [NSUUID UUID].UUIDString;
			NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
            
			[self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self.sampleBufferDelegate];
		}
		else {
			[self.movieFileOutput stopRecording];
		}
	} );
}

#pragma mark KVO and Notifications

- (void)addObservers
{
	[self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];
	
	/*
		A session can only run when the app is full screen. It will be interrupted
		in a multi-app layout, introduced in iOS 9, see also the documentation of
		AVCaptureSessionInterruptionReason. Add observers to handle these session
		interruptions and show a preview is paused message. See the documentation
		of AVCaptureSessionWasInterruptedNotification for other interruption reasons.
	*/
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
}

- (void)removeObservers
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ( context == SessionRunningContext ) {
		BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
		//BOOL livePhotoCaptureSupported = self.photoOutput.livePhotoCaptureSupported;
		//BOOL livePhotoCaptureEnabled = self.photoOutput.livePhotoCaptureEnabled;
		
		dispatch_async( dispatch_get_main_queue(), ^{
			// Only enable the ability to change camera if the device has more than one camera.
			self.cameraButton.enabled = isSessionRunning && ( self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1 );
			self.recordButton.enabled = isSessionRunning && ( self.captureModeControl.selectedSegmentIndex == AVCamCaptureModeMovie );
			self.photoButton.enabled = isSessionRunning;
			self.captureModeControl.enabled = isSessionRunning;
			//self.livePhotoModeButton.enabled = isSessionRunning && livePhotoCaptureEnabled;
			//self.livePhotoModeButton.hidden = ! ( isSessionRunning && livePhotoCaptureSupported );
		} );
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)subjectAreaDidChange:(NSNotification *)notification
{
	CGPoint devicePoint = CGPointMake( 0.5, 0.5 );
	[self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

- (void)sessionRuntimeError:(NSNotification *)notification
{
	NSError *error = notification.userInfo[AVCaptureSessionErrorKey];
	NSLog( @"Capture session runtime error: %@", error );
	
	/*
		Automatically try to restart the session running if media services were
		reset and the last start running succeeded. Otherwise, enable the user
		to try to resume the session running.
	*/
	if ( error.code == AVErrorMediaServicesWereReset ) {
		dispatch_async( self.sessionQueue, ^{
			if ( self.isSessionRunning ) {
				[self.session startRunning];
				self.sessionRunning = self.session.isRunning;
			}
			else {
				dispatch_async( dispatch_get_main_queue(), ^{
					self.resumeButton.hidden = NO;
				} );
			}
		} );
	}
	else {
		self.resumeButton.hidden = NO;
	}
}

- (void)sessionWasInterrupted:(NSNotification *)notification
{
	/*
		In some scenarios we want to enable the user to resume the session running.
		For example, if music playback is initiated via control center while
		using AVCam, then the user can let AVCam resume
		the session running, which will stop music playback. Note that stopping
		music playback in control center will not automatically resume the session
		running. Also note that it is not always possible to resume, see -[resumeInterruptedSession:].
	*/
	BOOL showResumeButton = NO;
	
	AVCaptureSessionInterruptionReason reason = [notification.userInfo[AVCaptureSessionInterruptionReasonKey] integerValue];
	NSLog( @"Capture session was interrupted with reason %ld", (long)reason );
	
	if ( reason == AVCaptureSessionInterruptionReasonAudioDeviceInUseByAnotherClient ||
		reason == AVCaptureSessionInterruptionReasonVideoDeviceInUseByAnotherClient ) {
		showResumeButton = YES;
	}
	else if ( reason == AVCaptureSessionInterruptionReasonVideoDeviceNotAvailableWithMultipleForegroundApps ) {
		// Simply fade-in a label to inform the user that the camera is unavailable.
		self.cameraUnavailableLabel.alpha = 0.0;
		self.cameraUnavailableLabel.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			self.cameraUnavailableLabel.alpha = 1.0;
		}];
	}
	
	if ( showResumeButton ) {
		// Simply fade-in a button to enable the user to try to resume the session running.
		self.resumeButton.alpha = 0.0;
		self.resumeButton.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			self.resumeButton.alpha = 1.0;
		}];
	}
}

- (void)sessionInterruptionEnded:(NSNotification *)notification
{
	NSLog( @"Capture session interruption ended" );
	
	if ( ! self.resumeButton.hidden ) {
		[UIView animateWithDuration:0.25 animations:^{
			self.resumeButton.alpha = 0.0;
		} completion:^( BOOL finished ) {
			self.resumeButton.hidden = YES;
		}];
	}
	if ( ! self.cameraUnavailableLabel.hidden ) {
		[UIView animateWithDuration:0.25 animations:^{
			self.cameraUnavailableLabel.alpha = 0.0;
		} completion:^( BOOL finished ) {
			self.cameraUnavailableLabel.hidden = YES;
		}];
	}
}

@end
