//
//  ui.cc
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <ui/ui.h>

#include <core/jit.h>

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
                        this->r = (Float)(r << 4 | r) / 255.0f;
                        this->g = (Float)(g << 4 | r) / 255.0f;
                        this->b = (Float)(b << 4 | r) / 255.0f;
                        this->a = 1.0f;
                    } else if(n == 7) {
                        Uint r = 0,g = 0,b = 0;
                        sscanf(string, "#%2x%2x%2x",&r,&g,&b);
                        this->r = (Float)(r) / 255.0f;
                        this->g = (Float)(g) / 255.0f;
                        this->b = (Float)(b) / 255.0f;
                        this->a = 1.0f;
                    } else if(n == 9) {
                        Uint r = 0,g = 0,b = 0, a = 0;
                        sscanf(string, "#%2x%2x%2x%2x",&r,&g,&b,&a);
                        this->r = (Float)(r) / 255.0f;
                        this->g = (Float)(g) / 255.0f;
                        this->b = (Float)(b) / 255.0f;
                        this->a = (Float)(a) / 255.0f;
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
        
        static void Context_duk_fatal_function(void *udata, const char *msg) {
            kk::Log("[UI] [FATAL] %s",msg);
        }
        
        Context::Context(kk::CString basePath,kk::DispatchQueue * queue):_basePath(basePath),_queue(queue) {
            _jsContext = duk_create_heap(nullptr, nullptr, nullptr, nullptr, Context_duk_fatal_function);
            kk::Openlib<>::openlib(_jsContext);
            kk::Openlib<kk::TimerSource *>::openlib(_jsContext, this);
        }
        
        void Context::set(kk::Object * object) {
            auto i = _objects.find(object);
            if(i != _objects.end()) {
                _objects[object] = object;
            }
        }
        
        void Context::remove(kk::Object * object) {
            auto i = _objects.find(object);
            if(i != _objects.end()) {
                _objects.erase(i);
            }
        }
        
        kk::Object * Context::get(kk::Object * object) {
            auto i = _objects.find(object);
            if(i != _objects.end()) {
                return i->second;
            }
            return nullptr;
        }
        
        kk::CString Context::basePath() {
            return _basePath.c_str();
        }
        
        kk::DispatchQueue * Context::queue() {
            return _queue;
        }
        
        duk_context * Context::jsContext() {
            return _jsContext;
        }
        
        kk::String Context::getContent(kk::CString path) {

            kk::String v;
            kk::String p = absolutePath(path);
            
            FILE * fd = fopen(p.c_str(), "r");
            
            if(fd != nullptr) {
                char data[20480];
                size_t n;
                
                while((n = fread(data, 1, sizeof(data), fd)) > 0) {
                    v.append(data,0,n);
                }
                
                fclose(fd);
            }
            
            return v;
        }
        
        kk::String Context::absolutePath(kk::CString path) {
            
            kk::String v = _basePath;
            
            if(!v.endsWith("/")) {
                v.append("/");
            }
            
            v.append(path);
            
            return v;
            
        }
        
        void Context::exec(kk::CString path,TObject<String, Any> * librarys) {
            
            kk::String code("(function(");
            
            if(librarys != nullptr) {
                auto i = librarys->begin();
                while(i != librarys->end()) {
                    if(i != librarys->begin()) {
                        code.append(",");
                    }
                    code.append(i->first);
                    i ++;
                }
            }
            
            code.append("){");
            
            code.append(getContent(path));
            
            code.append("})");
            
            duk_context * ctx = jsContext();
            
            duk_push_string(ctx, path);
            duk_compile_string_filename(ctx, 0, code.c_str());
            
            if(duk_is_function(ctx, -1)) {
                
                if(duk_pcall(ctx, 0) == DUK_EXEC_SUCCESS) {
                    
                    duk_idx_t n =0;
                    
                    auto i = librarys->begin();
                    
                    while(i != librarys->end()) {
                        
                        PushAny(ctx, i->second);
                        
                        i ++;
                        n ++;
                    }
                    
                    if(duk_pcall(ctx, n) != DUK_EXEC_SUCCESS) {
                        Error(ctx, -1, "[Context::exec] ");
                    }
                    
                } else {
                    Error(ctx, -1, "[Context::exec] ");
                }
    
            }
            
            duk_pop(ctx);
            
        }
        
        void Context::exec(kk::CString path,JSObject * librarys) {
            
            kk::String code("(function(");
            
            std::vector<std::shared_ptr<Any>> vs;
            
            if(librarys != nullptr) {
                
                duk_context * ctx = librarys->jsContext();
                
                duk_push_heapptr(ctx, librarys->heapptr());
                
                if(duk_is_object(ctx, -1)) {
                    
                    duk_enum(ctx, -1, DUK_ENUM_INCLUDE_SYMBOLS);
                    
                    while(duk_next(ctx, -1, 1)) {
                        Any name;
                        GetAny(ctx, -2, name);
                        kk::CString cname = name;
                        if(cname) {
                            if(vs.size() != 0) {
                                code.append(",");
                            }
                            code.append(cname);
                            vs.push_back(GetAnyPtr(ctx, -1));
                        }
                        
                        duk_pop_2(ctx);
                    }
                }
                
                duk_pop(ctx);
                
            }
            
            code.append("){");
            
            code.append(getContent(path));
            
            code.append("})");
            
            duk_context * ctx = jsContext();
            
            duk_push_string(ctx, path);
            duk_compile_string_filename(ctx, 0, code.c_str());
            
            if(duk_is_function(ctx, -1)) {
                
                if(duk_pcall(ctx, 0) == DUK_EXEC_SUCCESS) {
                    
                    auto i = vs.begin();
                    
                    while(i != vs.end()) {
                        std::shared_ptr<Any> & v = (*i);
                        PushAny(ctx, * v);
                        i ++;
                    }
                    
                    if(duk_pcall(ctx, (duk_idx_t) vs.size()) != DUK_EXEC_SUCCESS) {
                        Error(ctx, -1, "[Context::exec] ");
                    }
                    
                } else {
                    Error(ctx, -1, "[Context::exec] ");
                }
                
            }
            
            duk_pop(ctx);
            
        }
        
        void Context::Openlib(){
            
            kk::Openlib<>::add([](duk_context * ctx)->void{
                
                duk_push_c_function(ctx, [](duk_context * ctx)->duk_ret_t{
                    
                    duk_idx_t top = duk_get_top(ctx);
                    
                    Any v;
                    
                    for(duk_idx_t i = - top ;i < 0; i++) {
                        switch (duk_get_type(ctx, i)) {
                            case DUK_TYPE_NULL:
                                kk::Log("null");
                                break;
                            case DUK_TYPE_UNDEFINED:
                                kk::Log("undefined");
                                break;
                            case DUK_TYPE_BOOLEAN:
                                kk::Log("%s",duk_to_boolean(ctx, i) ? "true":"false");
                                break;
                            case DUK_TYPE_NUMBER:
                                kk::Log("%g",duk_to_number(ctx, i));
                                break;
                            case DUK_TYPE_STRING:
                                kk::Log("%s",duk_to_string(ctx, i));
                                break;
                            case DUK_TYPE_BUFFER:
                            {
                                size_t n;
                                void * data = duk_is_buffer_data(ctx, i) ?  duk_get_buffer_data(ctx, i, &n) : duk_get_buffer(ctx, i, &n);
                                kk::Log("<0x%x:%d>",data,n);
                            }
                                break;
                            case DUK_TYPE_LIGHTFUNC:
                                kk::Log("[function]");
                                break;
                            default:
                                kk::Log("[object]");
                                break;
                        }
                    }
                    
                    return 0;
                    
                }, DUK_VARARGS);
                
                duk_put_global_string(ctx, "print");
                
                kk::PushClass<Context, kk::CString,kk::DispatchQueue *>(ctx, [](duk_context * ctx)->void{
                    
                    kk::PutProperty<Context,kk::CString>(ctx, -1, "basePath", &Context::basePath);
                    
                    kk::PutProperty<Context,kk::DispatchQueue *>(ctx, -1, "queue", &Context::queue);
                
                    kk::PutMethod<Context,void,kk::CString,JSObject *>(ctx, -1, "exec", &Context::exec);
                    
                    kk::PutMethod<Context,void,Object *>(ctx, -1, "set", &Context::set);
                    
                    kk::PutMethod<Context,void,Object *>(ctx, -1, "remove", &Context::remove);
                });
                
            });
            
        }
        
    }
    
}

