//
//  UIImage.swift
//  ScottLydon
//
//  Created by Scott Lydon on 10/2/19.
//  Copyright © 2019 ElevatedUnderdogs. All rights reserved.
//


import Foundation
import UIKit
import Vision

public typealias SuccessAction = (Bool) -> Void
public typealias IntAction = (Int) -> Void

public extension UIImage {
    
    @available(iOS 11.0, *)
    func hasFace(hasFaceCompletion: @escaping SuccessAction) {
        faceCount { count in
            hasFaceCompletion(count >= 1)
        }
    }
    
   @available(iOS 11.0, *)
    func faceCount(faceCountAction: @escaping IntAction) {
        let request = VNDetectFaceRectanglesRequest { request, err in
            if let err = err {
                print("Error: Failed to perform request:", err)
                return
            }
            var faceCount = 0
            request.results?.forEach { res in
                guard res is VNFaceObservation else { return }
                faceCount.increment()
            }
            faceCountAction(faceCount)
        }
        guard let cgImage = self.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch let reqError {
            print("Error: failed to perform request:", reqError)
        }
    }
}
