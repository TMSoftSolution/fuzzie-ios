//
//  GiftCollectionViewLayout.m
//  Fuzzie
//
//  Created by Nur Iman Izam Othman on 23/11/16.
//  Copyright © 2016 Nur Iman Izam. All rights reserved.
//

#import "GiftCollectionViewLayout.h"
#import "FZGiftPricesLayoutAttributes.h"

static CGFloat const kFZGiftPricesMargin = 10.0f;

static CGFloat const kFZGiftPricesCellWidth = 80.0f;
static CGFloat const kFZGiftPricesCellHeight = 43.0f;
static CGFloat const kFZGiftPricesCollectionViewHeight = 60.0f;

static CGFloat const kFZGiftPricesZoomFactor = 0.2f;

@implementation GiftCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(kFZGiftPricesCellWidth, kFZGiftPricesCellHeight);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGFloat leftInset = CGRectGetWidth(self.collectionView.frame) / 2 - ((1 + kFZGiftPricesZoomFactor) * kFZGiftPricesCellWidth / 2);
    CGFloat rightInset = CGRectGetWidth(self.collectionView.frame) / 2 + (kFZGiftPricesCellWidth / 2);
    
    self.sectionInset = UIEdgeInsetsMake(0.0, leftInset, 0.0, rightInset);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    __block CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    __block CGRect previousFrame = CGRectMake(0.0, 0.0, 0.0, 0.0);
    __block BOOL prev = NO;
    
    // Copy attributes
    NSMutableArray * results = @[].mutableCopy;
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if(CGRectIntersectsRect(rect, attributes.frame)){
            UICollectionViewLayoutAttributes * att = [attributes copy];
            [results addObject:att];
        }
    }
    
    // Modify
    [results enumerateObjectsUsingBlock:^(FZGiftPricesLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / kFZGiftPricesCellWidth;
            attributes.isActiveCell = NO;
            attributes.zoom = 1;
            if (ABS(distance) < kFZGiftPricesCellWidth) {
                CGFloat zoom = 1 + kFZGiftPricesZoomFactor * (1 - ABS(normalizedDistance));
                
                CGRect cellFrame = attributes.frame;
                cellFrame.size.width = kFZGiftPricesCellWidth * zoom;
                cellFrame.size.height = kFZGiftPricesCellHeight * zoom;
                cellFrame.origin.y = (kFZGiftPricesCollectionViewHeight - cellFrame.size.height) / 2;
                
                if (idx == 0) {
                    CGFloat inset = CGRectGetWidth(self.collectionView.frame) / 2 - (zoom *kFZGiftPricesCellWidth / 2);
                    cellFrame.origin.x = inset;
                } else {
                    cellFrame.origin.x = CGRectGetMaxX(previousFrame) + kFZGiftPricesMargin;
                }
                
                attributes.frame = cellFrame;
                attributes.zIndex = 1;
                attributes.zoom = zoom;
                
                prev = true;
            }
            else if(prev) {
                CGRect cellFrame = attributes.frame;
                cellFrame.origin.x = CGRectGetMaxX(previousFrame) + kFZGiftPricesMargin;
                cellFrame.size = CGSizeMake(kFZGiftPricesCellWidth, kFZGiftPricesCellHeight);
                attributes.frame = cellFrame;
            }
            previousFrame = attributes.frame;
        }
    }];
    
    [self setActivatedCellInArray:results];
    
    return results;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment + ((kFZGiftPricesZoomFactor * kFZGiftPricesCellWidth) / 2.0) - 1, proposedContentOffset.y);
}

+ (Class)layoutAttributesClass
{
    return [FZGiftPricesLayoutAttributes class];
}

/**************************************************************************************************/
#pragma mark - Utils

- (void)setActivatedCellInArray:(NSArray*)array
{
    __block FZGiftPricesLayoutAttributes *selectedObject = nil;
    
    __block NSInteger maxZoom = -MAXFLOAT;
    
    [array enumerateObjectsUsingBlock:^(FZGiftPricesLayoutAttributes *attr, NSUInteger idx, BOOL *stop) {
        
        CGFloat zoom = attr.zoom;
        if (zoom > 1.0) {
            maxZoom = zoom;
            selectedObject = attr;
        }
    }];
    
    if (selectedObject) {
        selectedObject.isActiveCell = YES;
    }
}


@end
