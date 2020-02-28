//
//  ImageCenterTest.swift
//
//  Created by David Casserly on 18/11/2015.
//  Copyright © 2015 DevedUp Ltd. All rights reserved.
//

import XCTest
@testable import NoThrillsImageLoading

class ImageCenterTest: XCTestCase {
	
	override func tearDown() {
		let cache = DefaultDiskCache()
		cache.clearCache()
		
		super.tearDown()
	}
    
    func testImageCaching() {
        let waitForImageLoad = expectation(description: "Expecting an image load")
		
        ImageCenter.debug = true
        
		let imageURL = URL(string:"https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png")!
		let imageOp = ImageCenter.imageForURL(imageURL) { (image, url, error) -> Void in
			
			// Should have an image loaded now
			XCTAssertNotNil(image)
			
			// Try again, but it should now be in the cache
			let _ = ImageCenter.imageForURL(imageURL, onImageLoad: { (image, url, error) -> Void in
                XCTAssertNotNil(image)
            })
			
			// Let the test end
			waitForImageLoad.fulfill()
		}
	
        // Image not in cache, so an operation should have started
        XCTAssertNotNil(imageOp)
		
		// If you want to cancel it you can use:
		//imageOp?.cancel()
		
		// Wait for image to load from network
        waitForExpectations(timeout:10.0, handler:nil)
    }

	
	func testImageCachingCancellingTheRequest() {
		let imageOne = URL(string:"https://media2.giphy.com/media/wzXlcBruMmzf2/200_s.gif")!
		let imageTwo = URL(string:"http://www.accrete.com/3dtextures/More3djayTextures/trees/got3d-tree23.png")!
		let imageThree = URL(string:"https://www.sapere.com/ckeditor_assets/pictures/35/content_oak_tree.png")!
		
		// The queue only runs 3, so four and five should be cancelled on time
		let one = ImageCenter.imageForURL(imageOne, onImageLoad: {_,_,_  in })
		let two = ImageCenter.imageForURL(imageTwo, onImageLoad: {_,_,_  in })
        let three = ImageCenter.imageForURL(imageThree) { (image, url, error) in
            XCTFail()
        }
		
		one.cancel()
		two.cancel()
		three.cancel()
		
	}
	
	func testURLReturned() {
        let waitForImageLoad = expectation(description:"Expecting an image load")
		
		let imageURL = URL(string:"http://www.accrete.com/3dtextures/More3djayTextures/trees/got3d-tree23.png")!
		ImageCenter.imageForURL(imageURL) { (image, url, error) -> Void in
			XCTAssertEqual(imageURL, url)
			// Let the test end
			waitForImageLoad.fulfill()
		}

		// Wait for image to load from network
        waitForExpectations(timeout: 10.0, handler:nil)
		
	}
	
	
}
