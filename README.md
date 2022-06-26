# FPGA_VLC_reciever
Implementation of Camera Based Visible Light Communication on FPGA


This project targets to extend existing Visible Light Communication system to FPGA domain. It aims to merge together two different technologies: digital image processing and visible light communication. Previous studies presented a concept of smartphone-to-smartphone communication link in which screen of smartphone works as a transmitter, showing data encoded into images on screen. By designing an image processing algorithm for FPGA, receiver for this short-range VLC link can be created. It would allow to establish VLC communication with whole new family of devices. Design of this algorithm is a main point of this project.

The algorithm was designed and implemented on Spartan-3e FPGA. A range of experiments was taken to test algorithm’s performance. Despite its limited abilities to extract data from rotated or tilted screen, algorithm can recover data from image in less than 2ms, which, considering achieved data density of 960 bits per frame, can provide a link with 480kbps data transmission capability.
