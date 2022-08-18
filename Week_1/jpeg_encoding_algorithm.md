# JPEG compression algorithm

[JPEG](https://en.wikipedia.org/wiki/JPEG#:~:text=JPEG%20for%20distribution.-,JPEG%20compression,domain%20(a.k.a.%20transform%20domain).) is a commonly used method of lossy compression for digital images, particularly for those images produced by digital photography.

This algorithm is basically based on drawbacks of human eye. It deletes the components that our eye is not great at percieving.

## The following are the steps in compression of JPEG file:<br/>

<img src="https://imgs.search.brave.com/TwnSmfvodO8McvuEbxGHyze_HHV83S4_TenecpDC9wg/rs:fit:917:225:1/g:ce/aHR0cHM6Ly90c2Uz/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC5P/eDhLZE9Lc2RjTzBf/dzg3S3R1RkN3SGFE/MSZwaWQ9QXBp" width="600" height="300">


### 1.**Colour space seperation:**<br/>
Each pixel has 3 RGB values, process ofcolour space conversion takes this 3 values and converts it into luminance(Y), Blue chrominance (Cb), Red chrominance(Cr).

<img src="https://programmerclick.com/images/891/5c4dacc518cbe884876b95b422ba5aab.JPEG" width="350" height="300">

### 2.**Chrominance Downsampling:**<br/>
Our eyes are bad at percieving chrominance so in this step what we do is we take 2*2 pixel block and finf the average of 4 pixels in that block for blue chrominance(Cb) red chrominance (Cr). 

<img src="Resources\Capture.PNG" width="300" height="250">

Thus in blue chrominance(Cb) red chrominance (Cr) the size information is converted to (1/4)th of the original size information.<br/>
Whereas we keep the luminance same.

### 3.**Discrete cosine transformation:**<br/>
It deals with the fact that human eye is unable to see high frequency changes in image intensity very well. So we try to eliminate the high frequency data in this and next step.<br/>
Firstly, here we take a block which consists of 8*8 pixels.<br/>
Then we subtract 128 from each pixel so our pixel value now ranges from -128 to 127.<br/>
<img src= "Resources\DCT1.png" width="300" height="300">

So in DCT we have a base DCT 8*8 pixel which looks like this,

<img src="https://www.researchgate.net/profile/Sayeed-Chowdhury/publication/344485397/figure/fig3/AS:943483275730945@1601955350581/8-8-2-D-DCT-bases-on-the-left-and-PCA-bases-for-CIFAR-10-on-the-right-The-DCT-bases.ppm" width="300" height="300">

Each pixel from our original 8*8 pixel block is identical to one of the pixel from the above 64 base DCT pixels. Now this base DCT block has coefficients for each pixel. That is each pixel is assigned with a coefficient as follow,<br/>
<img src= "Resources\DCT2.png" width="300" height="300">

Now the pixels from our 8*8 pixel block are multiplied by their corresponding identical pixel coefficient. If you closely look at the coefficients they are such that lower frequency pixels have high coefficient whereas higher frequency pixels have lower coefficients. 
