%function B = fastfourier(img1, img2)

img1 = rgb2gray(imread('img1.jpg'));
img2 = rgb2gray(imread('img2.jpeg'));
img2 = imresize(img2, size(img1));

imgt1 = fft2(img1);
imgt2 = fft2(img2);
spectrum1 = abs(imgt1);
spectrum2 = abs(imgt2);
phase1 = angle(imgt1);
phase2 = angle(imgt2);

img1_using_spectrum = ifft2(spectrum1);
img1_using_phase = ifft2(exp(1i.*phase1));
img1_spectrum_img2_phase = ifft2(spectrum1 .* exp(1i.*phase2));
img2_spectrum_img1_phase = ifft2(spectrum2 .* exp(1i.*phase1));

figure;
subplot(2, 3, 1); imshow(uint8(img1));
subplot(2, 3, 2); imshow(uint8(phase1));
subplot(2, 3, 3); imshow(uint8(img1_using_spectrum));
subplot(2, 3, 4); imshow(uint8(img1_using_phase));
subplot(2, 3, 5); imshow(uint8(img1_spectrum_img2_phase));
subplot(2, 3, 6); imshow(uint8(img2_spectrum_img1_phase));


%end