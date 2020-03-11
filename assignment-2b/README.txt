[CS517] Digital Image Processing and Analysis
Assignment 2b
Submitted by: Hansin Ahuja, 2018csb1094

HOW TO RUN:
- The function returns a matrix of all the intermediate images used to create the gif file.
- The function takes the following arguments:
	- fname_inp1: File name of image 1
	- fname_inp2: File name of image 2
	- tpts: A kx4 matrix, where tpts(:, 1:2) refers to the tie points of image 1 and tpts(:, 3:4) refers to the tie points of image 2.
	- fname_out: name of the desired .gif file, without the extension
	- toshow: pass 1 to show the various stages of morphing
- The only major inbuilt function used is delaunayTriangulation. Inbuilt functions such as affine2d, etc. have been used.
- Assumptions:
	- Sizes of image 1 and image 2 are equal, and both images are in RGB format.
	- The tie points passed as input are valid and logical. Adversarial tie points, like multiple points in a straight line must not be passed. The points must provide a decent Delaunay triangulation.
	
Some sample function calls:

* NOTE: The fact that I'm using 59 intermediate frames and many tie points for triangulation increases the running time. This can easily be reduced by reducing these parameters, but there will be a trade-off with the quality of the output.

1) To morph my face into Andy Samberg's face (took 4-5 mins to run on my machine):
load eg1_pts; imgs = A2b_Hansin_2018CSB1094_2020_CS517('hansin.jpg', 'andy.jpeg', eg1_pts, 'eg1_outp', 1);

2) To morph Walter White's face into Jesse Pinkman's face (took 6-7 mins to run on my machine):
load eg2_pts; imgs = A2b_Hansin_2018CSB1094_2020_CS517('walt.jpg', 'jesse.jpg', eg2_pts, 'eg2_outp', 1);
* NOTE: I got the images and corresponding tie points for the second example from https://github.com/DevendraPratapYadav/FaceMorphing/tree/master/code

These commands have been run by me, and the input images and output gifs have been submitted in the current directory.

OVERVIEW OF APPROACH:
- First we find a Delaunay triangulation of the mean of tie points passed.
- We vary alpha from 0 to 1, and find an intermediate set of tie points for each alpha.
- Using these intermediate points, we find an affine transform for each triangle from the input images to the intermediate image. This happens in the function 'transform.m'.
- We now cross-dissolve the two transformed images, again using the fraction alpha.
- We create a .gif file using all the intermediate images from front to back, and then back to front to create a boomerang effect.