//
//  GTMIPhoneUnitTestDelegate.m
//
//  Copyright 2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#if UNIT_TEST
#import "GTMIPhoneUnitTestDelegate.h"

#import "GTMDefines.h"
#if !GTM_IPHONE_SDK
#error GTMIPhoneUnitTestDelegate for iPhone only
#endif
#import <objc/runtime.h>
#import <stdio.h>
#import <UIKit/UIKit.h>
#import "GTMSenTestCase.h"

@implementation GTMIPhoneUnitTestDelegate

+ (id)shared
{
	static GTMIPhoneUnitTestDelegate *mInstance = nil;
	if (mInstance == nil)
		mInstance = [GTMIPhoneUnitTestDelegate new];
		
	return mInstance;
}

// Run through all the registered classes and run test methods on any
// that are subclasses of SenTestCase. Terminate the application upon
// test completion.
- (void)applicationDidFinishLaunching:(UIApplication *)application {
  [self runTests];
  
  #if !DISABLE_TERMINATION
  if (!getenv("GTM_DISABLE_TERMINATION")) {
    // To help using xcodebuild, make the exit status 0/1 to signal the tests
    // success/failure.
    int exitStatus = (([self totalFailures] == 0U) ? 0 : 1);
    // Alternative to exit(status); so it cleanly terminates the UIApplication
    // and classes that depend on this signal to exit cleanly.
	/* The App Store reviewers will reject the app; _terminateWithStatus is a 
	 * private API
	 */
    if ([application respondsToSelector:@selector(_terminateWithStatus:)]) {
      [application performSelector:@selector(_terminateWithStatus:)
                        withObject:(id)exitStatus];
    } else {
      exit(exitStatus);
    }
  }
  #endif
}

// Run through all the registered classes and run test methods on any
// that are subclasses of SenTestCase. Print results and run time to
// the default output.
- (void)runTests {
  int count = objc_getClassList(NULL, 0);
  NSMutableData *classData
    = [NSMutableData dataWithLength:sizeof(Class) * count];
  Class *classes = (Class*)[classData mutableBytes];
  _GTMDevAssert(classes, @"Couldn't allocate class list");
  objc_getClassList(classes, count);
  totalFailures_ = 0;
  totalSuccesses_ = 0;
  NSString *suiteName = [[NSBundle mainBundle] bundlePath];
  NSDate *suiteStartDate = [NSDate date];
  NSString *suiteStartString
    = [NSString stringWithFormat:@"Test Suite '%@' started at %@\n",
                                 suiteName, suiteStartDate];
  fputs([suiteStartString UTF8String], stderr);
  fflush(stderr);
  for (int i = 0; i < count; ++i) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Class currClass = classes[i];
    if (class_respondsToSelector(currClass, @selector(conformsToProtocol:)) &&
        [currClass conformsToProtocol:@protocol(SenTestCase)]) {
      NSDate *fixtureStartDate = [NSDate date];
      NSString *fixtureName = NSStringFromClass(currClass);
      NSString *fixtureStartString
        = [NSString stringWithFormat:@"Test Suite '%@' started at %@\n",
                                     fixtureName, fixtureStartDate];
      int fixtureSuccesses = 0;
      int fixtureFailures = 0;
      fputs([fixtureStartString UTF8String], stderr);
      fflush(stderr);
      NSArray *invocations = [currClass testInvocations];
      if ([invocations count]) {
        NSInvocation *invocation;
        GTM_FOREACH_OBJECT(invocation, invocations) {
          GTMTestCase *testCase 
            = [[currClass alloc] initWithInvocation:invocation];
          BOOL failed = NO;
          NSDate *caseStartDate = [NSDate date];
          NSString *selectorName = NSStringFromSelector([invocation selector]);
          NSString *caseStartString
            = [NSString stringWithFormat:@"Test Case '-[%@ %@]' started.\n",
               fixtureName, selectorName];
          fputs([caseStartString UTF8String], stderr);
          fflush(stderr);
          @try {
            [testCase performTest];
          } @catch (NSException *exception) {
            failed = YES;
          }
          if (failed) {
            fixtureFailures += 1;
          } else {
            fixtureSuccesses += 1;
          }
          NSTimeInterval caseEndTime
            = [[NSDate date] timeIntervalSinceDate:caseStartDate];
          NSString *caseEndString
            = [NSString stringWithFormat:@"Test Case '-[%@ %@]' %@ (%0.3f "
               @"seconds).\n",
               fixtureName, selectorName,
               failed ? @"failed" : @"passed",
               caseEndTime];
          fputs([caseEndString UTF8String], stderr);
          fflush(stderr);
          [testCase release];
        }
      }
      NSDate *fixtureEndDate = [NSDate date];
      NSTimeInterval fixtureEndTime
        = [fixtureEndDate timeIntervalSinceDate:fixtureStartDate];
      NSString *fixtureEndString
        = [NSString stringWithFormat:@"Test Suite '%@' finished at %@.\n"
                                     @"Executed %d tests, with %d failures (%d "
                                     @"unexpected) in %0.3f (%0.3f) seconds\n\n",
                                     fixtureName, fixtureEndDate,
                                     fixtureSuccesses + fixtureFailures, 
                                     fixtureFailures, fixtureFailures,
                                     fixtureEndTime, fixtureEndTime];
      
      fputs([fixtureEndString UTF8String], stderr);
      fflush(stderr);
      totalSuccesses_ += fixtureSuccesses;
      totalFailures_ += fixtureFailures;      
    }
    [pool release];
  }
  NSDate *suiteEndDate = [NSDate date];
  NSTimeInterval suiteEndTime
    = [suiteEndDate timeIntervalSinceDate:suiteStartDate];
  NSString *suiteEndString
    = [NSString stringWithFormat:@"Test Suite '%@' finished at %@.\n"
                                 @"Executed %d tests, with %d failures (%d "
                                 @"unexpected) in %0.3f (%0.3f) seconds\n\n",
                                 suiteName, suiteEndDate,
                                 totalSuccesses_ + totalFailures_, 
                                 totalFailures_, totalFailures_,
                                 suiteEndTime, suiteEndTime];
  fputs([suiteEndString UTF8String], stderr);
  fflush(stderr);
}

- (NSUInteger)totalSuccesses {
  return totalSuccesses_;
}

- (NSUInteger)totalFailures {
  return totalFailures_;
}

@end
#endif