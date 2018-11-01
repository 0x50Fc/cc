//
//  view.h
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef ui_view_h
#define ui_view_h

#include <ui/ui.h>
#include <core/event.h>
#include <core/dispatch.h>

namespace kk {
    
    namespace ui {
        
        extern kk::CString kCanvasCGContext;
        extern kk::CString kCanvasWebGLContext;
        
        class Canvas : public EventEmitter {
        public:
            virtual Strong<Object> getContext(kk::CString name) = 0;
            virtual Uint width() = 0;
            virtual void setWidth(Uint v) = 0;
            virtual Uint height() = 0;
            virtual void setHeight(Uint v) = 0;
            virtual Strong<Image> toImage() = 0;
        };
        
        kk::Strong<Canvas> createCanvas();
        
        typedef kk::Uint SubviewPosition;
        
        enum {
            SubviewPositionFront,SubviewPositionBack
        };
        
        class View : public EventEmitter {
        public:
            virtual void set(kk::CString name,kk::CString value) = 0;
            virtual void setFrame(Rect & frame) = 0;
            virtual void setFrame(Float x,Float y,Float width,Float height);
            virtual void setContentSize(Size & size) = 0;
            virtual void setContentSize(Float width,Float height);
            virtual void setContentOffset(Point & offset) = 0;
            virtual Point contentOffset() = 0;
            virtual void createCanvas(std::function<void(Canvas *)> && func,DispatchQueue * queue) = 0;
            virtual void evaluateJavaScript(kk::CString code) = 0;
            virtual void addSubview(View * view,SubviewPosition position);
            virtual void removeView();
            virtual kk::Strong<View> obtainView(kk::CString reuse);
            virtual void recycleView(View * view,kk::CString reuse);
            virtual void removeRecycleViews();
            
            KK_CLASS(View, EventEmitter, "UIView");
            
            static void Openlib();
        protected:
            std::map<kk::String,std::list<kk::Strong<View>>> _obtainViews;
            std::map<View *,Strong<View>> _subviews;
            Weak<View> _parent;
        };
        
        
        kk::Strong<View> createView(kk::CString name);
        
    }
    
    
}

#endif /* view_h */
