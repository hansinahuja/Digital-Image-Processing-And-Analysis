A = imread("watch.tif");
sizeA = size(A);
m = round(2*sizeA(1));
n = round(2*sizeA(2));
B_inbuilt = imresize(A, [m, n], 'bilinear');
B_nearest = bilinear(m, n, A);
C = rmse_img(B_inbuilt, B_nearest);
err = rmse(B_inbuilt, B_nearest);

flag = 0;
for i = 1:m
break;
    for j = 1:n
        if B_nearest ~= B_inbuilt
            disp([i, j, B_nearest, B_inbuilt]);
            flag = 1;
            break;
            
        end
    end
    
    if flag == 1
        break;
    end
end

CC = B_nearest - B_inbuilt > 0 ;
CD = B_inbuilt - B_nearest > 0;
D = CC | CD;


figure;
 subplot(2,2,1);
 imshow(A);
 title('Original image');
 subplot(2,2,2);
 imshow(B_inbuilt);
 title('Resized using inbuilt function');
 subplot(2,2,3);
 imshow(B_nearest);
 title('Resized using custom function');
 subplot(2,2,4);
 imshow(C);
 title(['Error image, e = ', num2str(err)]);