A = imread('images/kidred.jpg');
B = imread('images/lena512.bmp');
A = rgb2gray(A);
A = imresize(A, size(B));
A = double(A);
B = double(B);

ans = sqrt(mean((A(:)-B(:)).^2))
