//
//  native.h
//  kk
//
//  Created by zhanghailong on 2018/10/26.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef native_ui_h
#define native_ui_h

#include <kk/kk.h>

namespace native {

    namespace ui {
    
        typedef kk::Float Float;
        
        struct Point {
            Float x,y;
        };
        
        struct Size {
            Float width,height;
        };
        
        struct Rect {
            Point origin;
            Size size;
        };
        
        struct Color {
            Float r,g,b,a;
        };
        
        enum FontStyle {
            FontStyleNormal,FontStyleItalic
        };
        
        enum FontWeight {
            FontWeightNormal,FontWeightBold
        };
        
        struct Font {
            kk::String fimlay;
            Float size;
            FontStyle style;
            FontWeight weight;
        };
        
        struct Transform {
            Float a, b, c, d;
            Float tx, ty;
        };
        
        class Image : public Object {
        public:
            virtual kk::Uint width() = 0;
            virtual kk::Uint height() = 0;
        };
        
        class View : public Object {
        public:
            virtual void set(kk::CString name,kk::CString value) = 0;
            virtual void setFrame(Rect & frame) = 0;
            virtual void setContentSize(Size & size) = 0;
            virtual void setContentOffset(Point & offset) = 0;
            virtual Point contentOffset() = 0;
        };
        
        
        struct Span {
            kk::String text;
            Font font;
            Color color;
        };
        
    }
    
}

#endif /* native_h */
