% var1 = 5;
% disp('Value of var1 = ');
% disp(var1);
% whos var1;
% 
% temp = [1 2 3 4 5];
% disp('Temp = ');
% disp(temp);
% disp('Variance of temp = ');
% disp(var(temp))

% A = imread('images/kidred.jpg');
% Ag=rgb2gray(A);
% B=double(Ag);
% C=B/255;
% disp([ max(A(:)) max(Ag(:)) max(B(:)) max(C(:)) ]);
% 
% figure;
% subplot(2,2,1);
% imshow(A);
% title('Original image A');
% subplot(2,2,2);
% imshow(Ag);
% title('Ag = rgb2gray(A)');
% subplot(2,2,3);
% imshow(B);
% title('B = double(Ag)');
% subplot(2,2,4);
% imshow(C);
% title('C = B/255');
% 
% imwrite(B,'temp1.tif');
% imwrite(C,'temp2.tif');
% Tb=imread('temp1.tif');
% Tc=imread('temp2.tif');
% 
% figure;
% subplot(1,3,1);
% imshow(A);
% title('Original image A');
% subplot(1,3,2);
% imshow(Tb);
% title('Tiff image Tb');
% subplot(1,3,3);
% imshow(Tc);
% title('Tiff image Tc');

% x = 1:1:5
% y = sin(x)
% concat = [x y]
% x = x(5:-1:1)

