# Image Encoding Algorithm
			
*JPEG* : JOint Photographic Experts Group 
JPEG (or JPG) is not really a file format but rather an image compression standard. 
Generally a much simpler and standard version is used i.e. JFIF . JPEG is a subset of JFIF and even though we mean JFIF , .jpeg or .jpg foramt is used .

## Assumptions of JPEG Compression

1. We are more sensitive to the illuminocity of color, rather than the chromatric value of an image.	
2. We are not particularly sensitive to high-frequency content in images.	

## JPEG coding algorithm 

*Stages in JPEG coding algorithm*
1. COlour Transformation 
2. Applying 2D Direct Cosine Transformation (DCT) to 8x8 block 
3. Quantization (filtering ) Stage 
4. Huffmann encoding .

If we even break these process down then,

![Stages in JPEG coding algorithm](https://media.geeksforgeeks.org/wp-content/uploads/20200407203949/JPEG1.png)

In short consider an image 




![Sample image](https://github.com/hrsshhhh/image-processing-fpga/blob/master/Hardik/imgs/Original-img.png)





- Splitting – 
    We split our image into the blocks of 8*8 blocks. It forms 64 blocks in which each block is referred to as 1 pixel.
    ![Splitted img](https://github.com/hrsshhhh/image-processing-fpga/blob/master/Hardik/imgs/After-splitting.png) 

     
- Color Space Transform – 
    In this phase, we convert R, G, B to Y, Cb, Cr model. Here Y is for brightness, Cb is color blueness and Cr stands for Color redness. We transform it into chromium colors as these are less sensitive to human eyes thus can be removed. 
    ![colour transformation](https://github.com/hrsshhhh/image-processing-fpga/blob/master/Hardik/imgs/Colour-conversion.png)
     
- Apply DCT – 
    We apply Direct cosine transform on each block. The discrete cosine transform (DCT) represents an image as a sum of sinusoids of varying magnitudes and frequencies. 
	
     
- Quantization – 
    In the Quantization process, we quantize our data using the quantization table. 
	
     
-  Serialization – 
    In serialization, we perform the zig-zag scanning pattern to exploit redundancy. 
	
     
-  Vectoring – 
    We apply DPCM (differential pulse code modeling) on DC elements. DC elements are used to define the strength of colors. 

     
-  Encoding – 
    In the last stage, we apply to encode either run-length encoding or Huffman encoding. The main aim is to convert the image into text and by applying any encoding we convert it into binary form (0, 1) to compress the data. 



![Example](https://followtutorials.com/2014/02/discrete-cosine-transform-and-jpeg-compression-image-processing.html)
   


