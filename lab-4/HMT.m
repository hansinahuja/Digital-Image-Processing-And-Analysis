function C = HMT(img, se, k)

if mod(size(se,1), 2)==0
    se = padarray(se, 1, 'post');
end

if mod(size(se,2), 2)==0
    se = padarray(se, [0,1], 'post');
end

se = padarray(se, [k, k]);
A = erosion(img, se);
imgC = 1-img;
seC = 1-se;
B = erosion(imgC, seC);
C = bitand(A, B);

figure;
subplot(2, 2, 1); imshow(img);
subplot(2, 2, 2); imshow(A);
subplot(2, 2, 3); imshow(B);
subplot(2, 2, 4); imshow(C);

end