/// Copyright (c) 2021. Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
import Mussel

class BullsEyeUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  func testDeepLink() {
    let universalLinkTester = MusselUniversalLinkTester(targetAppBundleId: "com.raywenderlich.BullsEye")
    universalLinkTester.open("bullseye://example/content?id=2")
    
    let mainScreenScreenshot = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: mainScreenScreenshot)
            attachment.lifetime = .keepAlways
            add(attachment)
    
    let slideLabel = app.staticTexts["Get as close as you can to: "]
    // XCTAssert(slideLabel.waitForExistence(timeout: 5))
    XCTAssertTrue(slideLabel.exists)
  }
  
  func testDeepLinkWithSafari() {
    let app = XCUIApplication()
    app.launch()
    
    // Launch Safari and deeplink back to our app
    openFromSafari("bullseye://example/content?id=2")
    // Make sure Safari properly switched back to our app before asserting
    XCTAssert(app.wait(for: .runningForeground, timeout: 5))
    
    let slideLabel = app.staticTexts["Get as close as you can to: "]
    XCTAssert(slideLabel.waitForExistence(timeout: 5))
  }
  
  private func openFromSafari(_ urlString: String) {
      let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
      safari.launch()
      // Make sure Safari is really running before asserting
      XCTAssert(safari.wait(for: .runningForeground, timeout: 5))
      // Type the deeplink and execute it
      let firstLaunchContinueButton = safari.buttons["Continue"]
      if firstLaunchContinueButton.exists {
          firstLaunchContinueButton.tap()
      }
      safari.buttons["Go"].tap()
      let keyboardTutorialButton = safari.buttons["Continue"]
      if keyboardTutorialButton.exists {
          keyboardTutorialButton.tap()
      }
      safari.typeText(urlString)
      safari.buttons["Go"].tap()
        
//      _ = confirmationButton.waitForExistence(timeout: 2)
//      if confirmationButton.exists {
//          confirmationButton.tap()
//      }
  }
  
  func testGameStyleSwitch() {
    // given
    let slideButton = app.segmentedControls.buttons["Slide"]
    let typeButton = app.segmentedControls.buttons["Type"]
    let slideLabel = app.staticTexts["Get as close as you can to: "]
    let typeLabel = app.staticTexts["Guess where the slider is: "]
    
    // then
    if slideButton.isSelected {
      XCTAssertTrue(slideLabel.exists)
      XCTAssertFalse(typeLabel.exists)

      typeButton.tap()
      XCTAssertTrue(typeLabel.exists)
      XCTAssertFalse(slideLabel.exists)
    } else if typeButton.isSelected {
      XCTAssertTrue(typeLabel.exists)
      XCTAssertFalse(slideLabel.exists)

      slideButton.tap()
      XCTAssertTrue(slideLabel.exists)
      XCTAssertFalse(typeLabel.exists)
    }
  }
}
