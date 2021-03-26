//
//  ImageSelectorViewModelTests.swift
//  ImageSelectorTests
//
//  Created by Munachimso Ugorji on 26/03/2021.
//

import XCTest
@testable import ImageSelector

class ImageSelectorViewModelTests: XCTestCase {
    let imageStrings = [
        "https://www.iconhot.com/icon/png/emoji/200/emoji-6.png",
        "https://d30y9cdsu7xlg0.cloudfront.net/png/65350-200.png",
        "https://d30y9cdsu7xlg0.cloudfront.net/png/177723-200.png"
    ]
        
    let viewModel = ImageSelectorViewModel(with: nil)
    
    func testGetImageStringsCount() {
        viewModel.updateImageStrings(with: imageStrings)
        XCTAssertEqual(viewModel.getImageStringsCount(), 3)
    }
    
    func testGetImageStringsCountWithEmptyArray() {
        viewModel.updateImageStrings(with: [String]())
        XCTAssertEqual(viewModel.getImageStringsCount(), 0)
    }
    
    func testGetImageCellViewModel() {
        viewModel.updateImageStrings(with: imageStrings)
        let cellViewModel = viewModel.getImageCellViewModel(index: 1)
        XCTAssertEqual(cellViewModel.imageString, imageStrings[1])
    }
    
    func testGetSingleImageString() {
        viewModel.updateImageStrings(with: imageStrings)
        XCTAssertEqual(viewModel.getSingleImageString(index: 2), imageStrings[2])
    }
    
    func testGetLastImageIndexWithoutUpdating() {
        viewModel.updateImageStrings(with: imageStrings)
        XCTAssertNil(viewModel.getLastImageIndex())
    }
    
    func testGetLastImageIndexWithUpdate() {
        viewModel.updateImageStrings(with: imageStrings)
        viewModel.updateSelectedIndex(index: 1)
        
        if let index = viewModel.getLastImageIndex() {
            XCTAssertNotNil(index)
            XCTAssertEqual(index, 1)
        }
    }
    
    func testGetPreviousImageIndexWithoutUpdating() {
        viewModel.updateImageStrings(with: imageStrings)
        XCTAssertNil(viewModel.getPreviousImageIndex())
    }
    
    func testGetPreviousImageIndexWithJustOneUpdate() {
        viewModel.updateImageStrings(with: imageStrings)
        viewModel.updateSelectedIndex(index: 1)
        XCTAssertNil(viewModel.getPreviousImageIndex())
    }
    
    func testGetPreviousImageIndexWithUpdate() {
        viewModel.updateImageStrings(with: imageStrings)
        viewModel.updateSelectedIndex(index: 1)
        viewModel.updateSelectedIndex(index: 0)
        
        if let index = viewModel.getPreviousImageIndex() {
            XCTAssertNotNil(index)
            XCTAssertEqual(index, 1)
        }
    }
    
}
