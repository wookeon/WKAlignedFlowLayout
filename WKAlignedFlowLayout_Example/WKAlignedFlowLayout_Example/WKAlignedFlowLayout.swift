
import UIKit

/*
 MIT License

 Copyright (c) 2021 Seung Eon Lee

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

public class WKAlignedFlowLayout: UICollectionViewFlowLayout {
    
    enum HorizontalAlignment {
        case leading
        case center
        case trailing
    }
    
    private(set) var horizontalAlignment: HorizontalAlignment = .center
    private(set) var collectionViewWidth: CGFloat = UIScreen.main.bounds.width
    private(set) var isRTL: Bool = false
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(horizontalAlignment: HorizontalAlignment, collectionViewWidth: CGFloat) {
        super.init()
        
        self.horizontalAlignment = horizontalAlignment
        self.collectionViewWidth = collectionViewWidth
        self.isRTL = (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft) ? true : false
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesObjects = super.layoutAttributesForElements(in: rect) else { return [] }
        
        var yPosition: CGFloat = -1.0
        var attributes: [UICollectionViewLayoutAttributes] = []
        
        layoutAttributesObjects.enumerated().forEach { index, objects in
            if objects.representedElementCategory == .cell {
                if objects.frame.origin.y >= yPosition {
                    self.arrangeItems(&attributes)
                }
                
                attributes.append(objects)
                yPosition = max(objects.frame.maxY, yPosition)
                
                if (layoutAttributesObjects.count - 1) == index {
                    self.arrangeItems(&attributes)
                }
            }
        }
        
        return layoutAttributesObjects
    }
    
    private func arrangeItems(_ attributes: inout [UICollectionViewLayoutAttributes]) {
        var xPosition = self.xPosition(for: attributes)
        
        if self.isRTL {
            attributes.forEach { attribute in
                attribute.frame.origin.x = xPosition - attribute.frame.width
                xPosition -= (attribute.frame.width + self.minimumInteritemSpacing)
            }
        } else {
            attributes.forEach { attribute in
                attribute.frame.origin.x = xPosition
                xPosition += (attribute.frame.width + self.minimumInteritemSpacing)
            }
        }
        
        attributes.removeAll()
    }

    private func xPosition(for attributes: [UICollectionViewLayoutAttributes]) -> CGFloat {
        var sumAttributesWidth: CGFloat = 0.0
        attributes.forEach { attribute in
            sumAttributesWidth += attribute.frame.width
        }
        
        let neededWidth = sumAttributesWidth + (self.minimumInteritemSpacing * CGFloat(attributes.count - 1))
        
        switch self.horizontalAlignment {
        case .leading:
            if self.isRTL {
                return self.collectionViewWidth - self.sectionInset.right
            } else {
                return self.sectionInset.left
            }
        case .center:
            if self.isRTL {
                return self.collectionViewWidth - ((self.collectionViewWidth - neededWidth) / 2)
            } else {
                return (self.collectionViewWidth - neededWidth) / 2
            }
        case .trailing:
            if self.isRTL {
                return self.sectionInset.left + neededWidth
            } else {
                return self.collectionViewWidth - (self.sectionInset.right + neededWidth)
            }
        }
    }
}
