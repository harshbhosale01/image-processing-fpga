# Image-Processing-FPGA
## Table of contents 
- [Aim](#aim)
- [About the Project](#about-the-Project)
- [Theory](#T=theory)
- [Flowchart](#flowchart)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Results](#results)

## Aim:
  To compress and decompress an image with the help of JPEG algorithm on FPGA using Tang Primer Dev Board.

## About the Project:
  Implementing JPEG encoder algorithm with Verilog on FPGA as Phase 1. Phase 2 includes the interfacing of a camera module (preferably ov2640 or ov7670) and a TFT    display. 
## Theory:
  FPGA stands for Field Programmable Gate Array. 
  
## Flowchart:
  <img src = "https://miro.medium.com/max/1400/1*JQ3JejBDau8TnNUPuzYSLw.png" width="900" height="540">

## Tech Stack:
  - [Verilog](https://www.chipverify.com/verilog/verilog-tutorial)
  - [Tang Dynasty](https://tang.sipeed.com/en/getting-started/installing-td-ide/)
  - [Tang Primer Dev Board](https://tang.sipeed.com/en/hardware-overview/lichee-tang/)
  - [Modelsim Altera]()
  - [FPGA](https://www.intel.com/content/www/us/en/products/details/fpga/resources/overview.html)
  
## Getting Started:
  - Download and install Tang Dynasty by following the instructions mentioned in the link above.
  - Also istall the USB drivers of for Tang Primer Dev Board.
  - Download and Install Modelsim.
  - Clone or download the compression modules in this repo.
  - Open Tang Dynasty and generate RTL file by creating project and following [this process]().
  
## Results:
32x32 pixel input image and 70% compressed results 
  - [Input image](https://github.com/harshbhosale01/image-processing-fpga/blob/master/Results/Original-img.jpeg)
  - [Output image with 70 percent compression](https://github.com/harshbhosale01/image-processing-fpga/blob/master/Results/70-compressed-img.png)
  - [Comparison](https://media.discordapp.net/attachments/1006252829687689408/1030724592135835648/Compression-comparison.png?width=1120&height=538)
  
