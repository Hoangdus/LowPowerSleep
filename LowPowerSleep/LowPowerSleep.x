#import "LowPowerSleep.h"

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	NSNumber * enabledValue = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enabled" inDomain:nsDomainString];
	enabled = (enabledValue)? [enabledValue boolValue] : YES;
}

%hook SBSleepWakeHardwareButtonInteraction
-(void)_playLockSound{
	%orig;	
	if (enabled){	
        if ([[%c(SBLockScreenManager)sharedInstance] isUILocked]){
			
		}else{
            if ([[NSProcessInfo processInfo]isLowPowerModeEnabled]){
                is_LPM_on_before = YES;
	        }else{
	            [[%c(_CDBatterySaver)batterySaver] setPowerMode:1 error:nil];
				is_LPM_on_before = NO;
		    }
		}	
	}else{

	}
}				
%end

%hook SBCoverSheetPrimarySlidingViewController
-(void)viewWillDisappear:(BOOL)arg1{
	%orig;
	if (enabled){
        if ([[%c(SBCoverSheetPresentationManager)sharedInstance] hasBeenDismissedSinceKeybagLock]){

		}else{
			if (is_LPM_on_before == YES){	

			}else{
		        [[%c(_CDBatterySaver)batterySaver] setPowerMode:0 error:nil];
		    }
		}
	}else{
	}
}	
%end

%ctor {
	// Set variables on start up
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	// Register for 'PostNotification' notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
}