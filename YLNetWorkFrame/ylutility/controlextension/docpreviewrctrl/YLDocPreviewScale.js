//
//  YLDocPreviewScaleScript.h
//  YLAppUtility
//
//  Created by zhangyilong on 16/9/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

function increaseMaxZoomFactor() {
    
    var element = document.createElement_x('meta');
    
    element.name = "viewport";
    
    element.content = "maximum-scale=10";
    
    var head = document.getElementsByTagName_r('head')[0];
    
    head.appendChild(element);
    
}
