[CS517] Digital Image Processing and Analysis
Assignment 2a
Submitted by: Hansin Ahuja, 2018csb1094

HOW TO RUN:
- The function returns a matrix of all the intermediate images used to create the gif file.
- Along with the prescribed +30 and -30 degree rotations, my function also handles any general affine transformation.
- For this reason, the input must be given in the form of an affine matrix.
- For purposes of smoothness, I have taken 100 images to create the gif, so please give the program some time to run.
- No inbuilt functions such as imrotate, affine2d have been used.

Some sample function calls:

1) To rotate by +30 degrees about corner:
imgs = A2a_Hansin_2018CSB1094_2020_CS517('cameraman.tif', '', 0, [], [cos(pi/6) -sin(pi/6) 0; sin(pi/6) cos(pi/6) 0; 0 0 1], 'cameraman_rotate30', 1);

2) To rotate by -30 degrees about corner:
imgs = A2a_Hansin_2018CSB1094_2020_CS517('circuit.tif', '', 0, [], [cos(pi/6) sin(pi/6) 0; -sin(pi/6) cos(pi/6) 0; 0 0 1], 'circuit_rotate-30', 1);

3) To rotate by +30 degrees about centre:
t1 = -128*cos(pi/6) + 128*sin(pi/6) +128;		% General formula: t1 = -a*cosx + b*sinx + a
t2 = -128*cos(pi/6) - 128*sin(pi/6) + 128;		% General formula: t2 = -a*sinx - b*cosx + a, for image of size [2*a, 2*b]
imgs = A2a_Hansin_2018CSB1094_2020_CS517('cameraman.tif', '', 0, [], [cos(pi/6) -sin(pi/6) t1; sin(pi/6) cos(pi/6) t2; 0 0 1], 'cameraman_centrerotate30', 1);

4) To rotate by -30 degrees about centre:
t1 = -140*cos(pi/6) - 136*sin(pi/6) +140;
t2 = -140*cos(pi/6) + 136*sin(pi/6) + 136;
imgs = A2a_Hansin_2018CSB1094_2020_CS517('circuit.tif', '', 0, [], [cos(pi/6) sin(pi/6) t1; -sin(pi/6) cos(pi/6) t2; 0 0 1], 'circuit_centrerotate-30', 1);

5) To translate the image:
imgs = A2a_Hansin_2018CSB1094_2020_CS517('tire.tif', '', 0, [], [1 0 100; 0 1 100; 0 0 1], 'tire_translate', 1);

6) To shear and scale the image:
imgs = A2a_Hansin_2018CSB1094_2020_CS517('kids.tif', '', 0, [], [2 1 0; 1 2 0; 0 0 1], 'kids_shear', 1);

These sample commands have been run by me, and the input images and output gifs have been submitted in the current directory.

OVERVIEW OF APPROACH:
- First, we use the forward mapping of the four corner points to determine the size of the canvas.
- Next, we vary 'alpha' from 0 to 1 in increments of 0.01, such that when alpha = 0, we get the identity transform and when alpha = 1, we get the final affine transform.
- For each alpha, we get an intermediate affine transformation. We use backward mapping to get the intermediate image for each alpha.
- In case the intermediate matrix is non-invertible, no image will be created for that transformation.
- Finally, we create a gif from all the intermediate images generated.
