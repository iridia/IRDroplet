#	IRDroplet

A Dropbox SDK fork, recently updated against the 1.1 source release (against Dropbox API v.2), with emphasis on usability and higher-level operations.

##	Philosophy

*	Endpoint interfacing code in the SDK must be preserved, *including quirks;* modifying any bit of them causes the author to take responsibiltiy of maintaining a branched version.

*	Changes can be introduced, but thru *addition* of surrounding code, unless it’s an obvious bug that should be fixed from the source.


##	Bootstrapping IRDroplet within your app

*	This is how you wire up Dropbox linking in your app, possibly from the app delegate, because you need to present an auth view controller accordingly:

		NSParameterAssert([DBSession sharedSession]);	//	Configure the shared session before you carry on

		void (^continueInitializing)() = ^ {
		
			//	Do your own work here
		
		};
	
		if ([[DBSession sharedSession] isLinked]) {
			
			continueInitializing();
			
		} else {
		
			__block IRDropletLinkAccountViewController *linkVC = [IRDropletLinkAccountViewController controllerWithCompletion: ^ (BOOL didAuthenticate, NSError *error) {
			
				if (didAuthenticate)
					continueInitializing();
			
				if (!didAuthenticate)
					NSLog(@"Error authenticating: %@", error);
			
				[linkVC dismissModalViewControllerAnimated:YES];
			
			}];
		
			UINavigationController *navC = [linkVC wrappingNavigationController];
			navC.modalPresentationStyle = UIModalPresentationFormSheet;
		
			[self.window.rootViewController presentModalViewController:navC animated:YES];
		
		}

*	Ideally, the login controller will take care of the rest, and call your code in the completion block when done.  It will automatically do appropriate things with `DBSession`, and with its underlying credential store as well.  Then, your app continues doing what it should be doing.

*	If you’re having URI scheme problems, check your `Info.plist`, preferably right click on the item in the Project Navigator, then choose Open As → Source Code.  It should contain a section looking like this:

		<key>CFBundleURLTypes</key>
		<array>
			<dict>
				<key>CFBundleURLSchemes</key>
				<array>
					<string>db-a883fe0vdseq0we</string>
				</array>
			</dict>
		</array>
		
	The `db-a883fe0vdseq0we` part is your app key.  If changed thru the Info pane in the Target editor (with editor role), it does not seem to work.
