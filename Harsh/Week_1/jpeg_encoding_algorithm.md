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

<img src="https://github.com/hrsshhhh/image-processing-fpga/blob/master/Week_1/Resources/Capture.PNG" width="300" height="250">

Thus in blue chrominance(Cb) red chrominance (Cr) the size information is converted to (1/4)th of the original size information.<br/>
Whereas we keep the luminance same.

### 3.**Discrete cosine transformation:**<br/>
It deals with the fact that human eye is unable to see high frequency changes in image intensity very well. So we try to eliminate the high frequency data in this and next step.<br/>
Firstly, here we take a block which consists of 8*8 pixelkmkls.<br/>
Then we subtract 128 from each pixel so our pixel value now ranges from -128 to 127.<br/>
<img src= "https://github.com/hrsshhhh/image-processing-fpga/blob/master/Week_1/Resources/DCT1.PNG" width="300" height="300">

So in DCT we have a base DCT 8*8 pixel which looks like this,

<img src="https://imgs.search.brave.com/0ENUHlbYwzs9t1aELBPMhmMk1VBLvN_cnJZ5lo6N_ws/rs:fit:321:323:1/g:ce/aHR0cDovL2kuc3Rh/Y2suaW1ndXIuY29t/L2pIQTUwLmpwZw" width="300" height="300">

Each pixel from our original 8*8 pixel block is identical to one of the pixel from the above 64 base DCT pixels. Now this base DCT block has coefficients for each pixel. That is each pixel is assigned with a coefficient as follow,<br/>
<img src= "https://github.com/hrsshhhh/image-processing-fpga/blob/master/Week_1/Resources/DCT2.PNG" width="300" height="300">

Now the pixels from our 8*8 pixel block are multiplied by their corresponding identical pixel coefficient. If you closely look at the coefficients they are such that lower frequency pixels have high coefficient whereas higher frequency pixels have lower coefficients. 

### 4.**Quantization:**</br>
So in this step we have a standard quantization table (This table might differ from encoder to encoder) So each pixels value is divided by their respective quantization table value and then we round it off to nearest integer.
Quantization table looks like this,</br>
<img src="https://imgs.search.brave.com/imiBBnyqg9k5sDKz85gGUijuzpGVW8F31-r2TlAgp4g/rs:fit:687:575:1/g:ce/aHR0cHM6Ly9zdGF0/aWMudHVtYmxyLmNv/bS9nbHR2eW5uL3JW/WG84eDdtYi9xdWFu/dHRhYmxlLnBuZw" width="300" height="300">

This quantization table has higher values for higher frequency pixels. So with quantization we have many 0's in our 8*8 pixel block.

### 5.**Huffman Encoding:**</br>
When we list the values of pixels for final step we list the values in zigzag format.</br>
Refer the below image,</br>
<img src="https://imgs.search.brave.com/wiOE0OE39ntlqUh7wPGnScjXIdiRcDceemiDAjUX9aM/rs:fit:900:900:1/g:ce/aHR0cHM6Ly9pbWcy/LnBuZ2Rvd25sb2Fk/LmlkLzIwMTgwNTAx/L2Rrdy9raXNzcG5n/LXppZ3phZy1odWZm/bWFuLWNvZGluZy1k/YXRhLWNvbXByZXNz/aW9uLXppZ3phZy01/YWU4YzYyMTRjMWYy/MS4yNjEwODA2NDE1/MjUyMDQ1MTMzMTE4/LmpwZw" width="300" height="300">

Instead of noting all the zero we do 0[x(number of consecutive zeros)].

## Rebuilding the JPEG (Decoding):</p>
In decoding we do the exact reverse steps as that of encoding.</br>
1. Hoffman decoding</br>
2. Multiply each value by same quantization table respective value.</br>
3. Division by Inverse cosine transformation values</br>
4. Upscaling the image(Reverse of chrominance desampling)</br>
5. Converting back to colour sapce format.</br>
   
For more understanding watch this videos:</br>
- [Video 1](https://www.youtube.com/watch?v=Kv1Hiv3ox8I)
- [Video 2](https://www.youtube.com/watch?v=n_uNPbdenRs)
- [Video 3](https://www.youtube.com/watch?v=Q2aEzeMDHMA)


