//
//  CollageView.swift
//  CollageMaker
//
//  Created by Shaheryar Malik on 29/07/2023.
//

import UIKit

class CollageView: UIView {
    
    private var lineColor: UIColor = .black
    private var borderColor: UIColor = .black
    private var borderWidth: CGFloat = 2.0
    private var firstImage: UIImage?
    private var secondImage: UIImage?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Draw the separation line between the images using UIBezierPath
        lineColor.setStroke()
        
        let width = bounds.width
        let height = bounds.height
        
        // Define the path for the separation line (horizontal line)
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: self.frame.width/2 + 60, y: 0.0))
        linePath.addLine(to: CGPoint(x:self.frame.width/2 - 60 , y: self.frame.size.height))
        linePath.lineWidth = 1
        UIColor.gray.setStroke()
        linePath.stroke()
        
        // Draw the border around the collage view
        borderColor.setStroke()
        let borderPath = UIBezierPath(rect: bounds)
        borderPath.lineWidth = borderWidth
        borderPath.stroke()
        
        let x1 = self.frame.width/2 + 60
        let y1 = 0.0
        let x2 = self.frame.width/2 - 60
        let y2 = self.frame.size.height
        
        let lineSlope = (y2 - y1) / (x2 - x1)
        
        // Draw the images within the collage view and clip them based on the line's slope
        clipAndDrawImage(firstImage, in: leftImageRect(), slope: lineSlope)
        clipAndDrawImage(secondImage, in: rightImageRect(), slope: lineSlope)
    }
    
    private func leftImageRect() -> CGRect {
        let separationX: CGFloat = bounds.width / 2
        let height: CGFloat = bounds.height
        // Calculate the width of the left image rectangle based on the line's slope
        let leftWidth = separationX - 60
        
        return CGRect(x: 0, y: 0, width: leftWidth, height: height)
    }
    
    private func rightImageRect() -> CGRect {
        let separationX: CGFloat = bounds.width / 2
        let height: CGFloat = bounds.height
        // Calculate the width of the right image rectangle based on the line's slope
        let rightWidth = separationX - 60
        
        return CGRect(x: separationX + 60, y: 0, width: rightWidth, height: height)
    }
    
    private func clipAndDrawImage(_ image: UIImage?, in rect: CGRect, slope: CGFloat){
        
        guard let image = image else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Calculate the scaling factor to fit the image inside the rect while maintaining aspect ratio
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = rect.width / image.size.width
        } else {
            scale = rect.height / image.size.height
        }
        
        // Calculate the size of the scaled image
        let scaledSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        // Calculate the position to center the scaled image within the rect
        let imageOrigin = CGPoint(x: rect.midX - scaledSize.width / 2, y: rect.midY - scaledSize.height / 2)
        
        // Create a UIBezierPath to use as the image mask
        let maskPath = UIBezierPath(rect: rect)
        
        // Save the current graphics state before applying the clipping path
        context.saveGState()
        
        // Add the clipping path to the context
        maskPath.addClip()
        
        // Draw the image within the clipped area
        image.draw(in: CGRect(origin: imageOrigin, size: scaledSize))
        
        // Restore the previous graphics state, removing the clipping path
        context.restoreGState()
    }
    
    
    
    // MARK: - Image Selection
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        // Get the touch location
        let touchLocation = gestureRecognizer.location(in: self)
        
        let x1 = self.frame.width/2 + 60
        let y1 = 0.0
        let x2 = self.frame.width/2 - 60
        let y2 = self.frame.size.height
        
        let lineSlope = (y2 - y1) / (x2 - x1)
        
        // Calculate the x value corresponding to the touch y value on the line
        let xOnLine = (touchLocation.y - 0) / lineSlope + (self.frame.width / 2 + 60)
        
        if touchLocation.x > xOnLine {
            // Touch is on the right side of the tilted line
            print("Right side of the line.")
            secondImage = UIImage(named: "img")
            // Handle right side touch here
        } else {
            // Touch is on the left side of the tilted line
            print("Left side of the line.")
            firstImage = UIImage(named: "img")
            // Handle left side touch here
        }
        
        // Redraw the collage view to display the selected image
        setNeedsDisplay()
    }
}




