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
        
        enum SubviewPosition {
            SubviewPositionFront,SubviewPositionBack
        };
        
        class View : public EventEmitter {
        public:
            virtual void set(kk::CString name,kk::CString value) = 0;
            virtual void setFrame(Rect & frame) = 0;
            virtual void setContentSize(Size & size) = 0;
            virtual void setContentOffset(Point & offset) = 0;
            virtual Point contentOffset() = 0;
            virtual void createCanvas(std::function<void(Canvas *)> && func,DispatchQueue * queue) = 0;
            virtual void addSubview(View * view,SubviewPosition position) = 0;
            virtual void removeView() = 0;
            virtual kk::Strong<View> obtainView(kk::CString reuse);
            virtual void recycleView(View * view,kk::CString reuse);
            virtual void removeRecycleViews();
            
            KK_CLASS(View, EventEmitter, "UIView");
            
            static void Openlib();
        protected:
            std::map<kk::String,std::list<kk::Strong<View>>> _obtainViews;
        };
        
        
        kk::Strong<View> createView(kk::CString name);
        
    }
    
    
}

#endif /* view_h */
