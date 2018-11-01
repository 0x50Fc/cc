//
//  ui.h
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#ifndef ui_ui_h
#define ui_ui_h

#include <core/kk.h>
#include <core/event.h>
#include <core/dispatch.h>
#include <core/jit.h>
#include <core/timer.h>

namespace kk {
    
    namespace ui {
        
        typedef kk::Float Float;
        
        struct Point {
            Float x,y;
            operator kk::Any() {
                return kk::Any(new TObject<kk::String, kk::Float>({{"x",x},{"y",y}}));
            }
        };
        
        struct Size {
            Float width,height;
            operator kk::Any() {
                return kk::Any(new TObject<kk::String, kk::Float>({{"width",width},{"height",height}}));
            }
        };
        
        struct Rect {
            Point origin;
            Size size;
            operator kk::Any() {
                return kk::Any(new TObject<kk::String, kk::Float>({{"x",origin.x},{"y",origin.y},{"width",size.width},{"height",size.height}}));
            }
        };
        
        struct Color {
        public:
            Color();
            Color(Float r,Float g,Float b,Float a);
            Color(kk::CString v);
            Color(kk::Uint v);
            Float r,g,b,a;
        };
        
        class Palette {
        public:
            Palette(std::initializer_list<std::pair<const kk::String,Color>> &&v);
            virtual void set(kk::CString name,Color v);
            virtual Color get(kk::CString name);
            static Palette Default;
        protected:
            std::map<kk::String,Color> _values;
        };
        
        enum FontStyle {
            FontStyleNormal,FontStyleItalic
        };
        
        enum FontWeight {
            FontWeightNormal,FontWeightBold
        };
        
        struct Font {
        public:
            Font():size(14),style(FontStyleNormal),weight(FontWeightNormal){}
            Font(Float size):size(size),style(FontStyleNormal),weight(FontWeightNormal){}
            Font(kk::String family,Float size,FontStyle style,FontWeight weight):family(family),size(size),style(style),weight(weight){}
            kk::String family;
            Float size;
            FontStyle style;
            FontWeight weight;
        };
        
        enum TextAlign {
            TextAlignStart,
            TextAlignEnd,
            TextAlignCenter,
            TextAlignLeft,
            TextAlignRight
        };
    
        enum TextBaseline {
            TextBaselineAlphabetic,
            TextBaselineTop,
            TextBaselineHanging,
            TextBaselineMiddle,
            TextBaselineIdeographic,
            TextBaselineBottom,
        };
        
        struct Transform {
            Float a, b, c, d;
            Float tx, ty;
        };
        
        enum ImageState {
            ImageStateNone,ImageStateLoading,ImageStateError,ImageStateLoaded
        };
        
        class Image {
        public:
            virtual ImageState state() = 0;
            virtual kk::Uint width() = 0;
            virtual kk::Uint height() = 0;
            virtual kk::CString src() = 0;
            virtual void setSrc(kk::CString src) = 0;
            virtual void copyPixels(void * data) = 0;
            virtual Boolean isCopyPixels() = 0;
        };
        

        class Context : public EventEmitter, public TimerSource {
        public:
            Context(kk::CString basePath,kk::DispatchQueue * queue);
            virtual kk::CString basePath();
            virtual kk::DispatchQueue * queue();
            virtual duk_context * jsContext();
            virtual kk::String absolutePath(kk::CString path);
            virtual kk::String getContent(kk::CString path);
            virtual void set(kk::Object * object);
            virtual kk::Object * get(kk::Object * object);
            virtual void remove(kk::Object * object);
            virtual void exec(kk::CString path,TObject<String, Any> * librarys);
            virtual void exec(kk::CString path,JSObject * librarys);
            static void Openlib();
            
            KK_CLASS(Context, EventEmitter, "UIContext");
            
        protected:
            kk::String _basePath;
            kk::Strong<kk::DispatchQueue> _queue;
            duk_context * _jsContext;
            std::map<void *,kk::Strong<kk::Object>> _objects;
        };
        
        kk::Strong<Image> ImageCreate(Context * context,kk::CString src);
        
        std::function<void(Context * ,Image *)> & getImageLoader();
        
        void setImageLoader(std::function<void(Context * ,Image *)> && func);
        
    }
    
    
}

#endif /* ui_h */
