img = rgb2gray(imread('dataset/kodim05.png'));
n = 16;
imgc = compress(img, n, Q);
imgd = decompress(imgc, n, n, Q);
err = rmse(img, imgd);
imwrite(uint8(img), 'fig5.png');
imwrite(uint8(imgd), 'fig7.png');