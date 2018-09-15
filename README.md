# Fast-Direct-Super-Resolution
A fast, direct method to achieve Super-Resolution by simple functions

Reference Paper: [Fast Direct Super-Resolution by Simple Functions
Chih-Yuan](./doc/Fast_Direct_Super-Resolution_by_Simple_Functions_ICCV_2013.pdf)

### Directory Architecture

`src/`: Source codes
`doc/`: Reference paper and details of source codes(in Simplified Chinese)

`original-high-resolution-examples/`: Original images in high resolution

`low-resolution-examples/`: Images in low resolution which are down-sampled by Bicubic Interpolation
`super-resolution-examples/`: Images in high resolution which are processed by the algorithm of this repository

### Example

original high-resolution image

![](./original-high-resolution-examples/lenna.bmp)

low resolution image

![](./low-resolution-examples/lr-lenna.bmp)

result of bocubic interpolation

![](./bicubic-examples/bi-lenna.bmp)

result of this algorithm

![](./super-resolution-examples/sr-lr-lenna.bmp)

