//
//  ui.cc
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <ui/ui.h>

namespace kk {
    
    namespace ui {
    
        Palette::Palette(std::initializer_list<std::pair<const kk::String,Color>> &&v):_values(v){
            
        }
        
        void Palette::set(kk::CString name,Color v) {
            _values[name] = v;
        }
        
        Color Palette::get(kk::CString name) {
            Color v = {0,0,0,0};
            std::map<kk::String,Color>::iterator i = _values.find(name);
            if(i != _values.end()) {
                return i->second;
            }
            return v;
        }
        
        Palette Palette::Default = {
            {"black",(0x000000)},
            {"red",(0xff0000)},
            {"white",(0xffffff)},
            {"green",(0x00ff00)},
            {"blue",(0x0000ff)},
            {"magenta",(0xff00ff)},
            {"yellow",(0xffff00)},
        };
        
        Color::Color():r(0),g(0),b(0),a(0) {
            
        }

        Color::Color(Float r,Float g,Float b,Float a):r(r),g(g),b(g),a(a) {
            
        }
        
        Color::Color(kk::CString string):Color() {
            
            if(string != nullptr) {
                
                if(kk::String::startsWith(string, "rgba(")) {
#ifdef KK_UI_FLOAT64
                    sscanf(string, "rgba(%lf,%lf,%lf,%lf)",&r,&g,&b,&a);
#else
                    sscanf(string, "rgba(%f,%f,%f,%f)",&r,&g,&b,&a);
#endif
                    r = r / 255.0f;
                    g = g / 255.0f;
                    b = b / 255.0f;
                    
                } else if(kk::String::startsWith(string, "rgb(")) {
                    
#ifdef KK_UI_FLOAT64
                    sscanf(string, "rgba(%lf,%lf,%lf)",&r,&g,&b);
#else
                    sscanf(string, "rgba(%f,%f,%f)",&r,&g,&b);
#endif
                    r = r / 255.0f;
                    g = g / 255.0f;
                    b = b / 255.0f;
                    a = 1.0f;
                    
                } else if(kk::String::startsWith(string, "#")) {
                    
                    size_t n = strlen(string);
                    
                    if(n == 4) {
                        Uint r = 0,g = 0,b = 0;
                        sscanf(string, "#%1x%1x%1x",&r,&g,&b);
                        this->r = (Float)(r << 8 | r) / 255.0f;
                        this->g = (Float)(g << 8 | r) / 255.0f;
                        this->b = (Float)(b << 8 | r) / 255.0f;
                        this->a = 1.0f;
                    } else if(n == 7) {
                        Uint r = 0,g = 0,b = 0;
                        sscanf(string, "#%2x%2x%2x",&r,&g,&b);
                        this->r = (Float)(r) / 255.0f;
                        this->g = (Float)(g) / 255.0f;
                        this->b = (Float)(b) / 255.0f;
                        this->a = 1.0f;
                    }
                    
                } else {
                    Color v = Palette::Default.get(string);
                    r = v.r;
                    g = v.g;
                    b = v.g;
                    a = v.a;
                }
            }
            
        }
        
        Color::Color(kk::Uint v):Color() {
            r = (0x0ff & (v >> 24)) / 255.0;
            g = (0x0ff & (v >> 16)) / 255.0;
            b = (0x0ff & (v >> 8)) / 255.0;
            a = (0x0ff & (v )) / 255.0;
        }
        
    }
    
}

