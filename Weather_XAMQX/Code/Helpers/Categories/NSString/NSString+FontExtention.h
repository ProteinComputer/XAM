//
//  NSString+FontExtention.h
//  GZCengongQX
//
//  Copyright © 2016年 [德云丰科技·DYF.INC]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (FontExtention)

/**
 *  返回字符串的SIZE
 */

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (CGSize)sizeWithFont:(UIFont*)font MaxX:(CGFloat)maxx;

- (CGSize)sizeWithAttributedFontName:(UIFont*)font;

- (NSInteger)Filesize;

@end
