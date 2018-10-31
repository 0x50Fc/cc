//
//  CGContext.cc
//  kk
//
//  Created by zhanghailong on 2018/10/29.
//  Copyright © 2018年 kkmofang.cn. All rights reserved.
//

#include <ui/CGContext.h>

namespace kk {
    
    namespace ui {
    
        
        namespace CG {
            
            Pattern::Pattern(Image * image,PatternType type):_image(image),_type(type) {
                
            }
            
            Image * Pattern::image() {
                return _image;
            }
            
            PatternType Pattern::type() {
                return _type;
            }

            ImageData::ImageData(Uint width,Uint height):_data(nullptr),_width(width),_height(height) {
                size_t n =_width * height * 4;
                _data = (Ubyte *) malloc(n);
                memset(_data, 0, n);
            }
            
            ImageData::~ImageData() {
                free(_data);
            }
            
            void ImageData::copyPixels(void * data) {
                memcpy(data, _data, _width * _height * 4);
            }
            
            Boolean ImageData::isCopyPixels() {
                return true;
            }
            
            Uint ImageData::width() {
                return _width;
            }
            
            Uint ImageData::height() {
                return _height;
            }
            
            Ubyte * ImageData::data() {
                return _data;
            }
            
            Uint ImageData::size() {
                return _width * _height * 4;
            }
            
            ImageState ImageData::state() {
                return ImageStateLoaded;
            }
            
            kk::CString ImageData::src() {
                return nullptr;
            }
            
            void ImageData::setSrc(kk::CString src) {
                
            }
            
            void Gradient::addColorStop(Float loc,Color color) {
                _locations.push_back(loc);
                _colors.push_back(color);
            }
            
        }
        
        
    }
    
}
