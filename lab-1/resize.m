A = imread('images/ngc6543a.jpg');
B = imresize(A, [256, 256]);
C = imresize(A, [64, 64]);
D = imresize(A, [16, 16]);

figure;
subplot(2,2,1);
imshow(A);
title('Original image');
subplot(2,2,2);
imshow(B);
title('Resized to 256x256');
subplot(2,2,3);
imshow(C);
title('Resized to 64x64');
subplot(2,2,4);
imshow(D);
title('Resized to 16x16');