function [err, dim] = A1_Hansin_2018CSB1094_2019_CS517(qID, fname_inp1, fname_inp2, fname_out, prmts, toshow)

err =[];
dim = [];
if(qID==1)
    err = nearest_neighbours(fname_inp1, fname_out, prmts, toshow);
    fprintf('RMSE between my output and system output = %.6f\n', err);
end
if(qID==2)
    err = bilinear(fname_inp1, fname_out, prmts, toshow);
    fprintf('RMSE between my output and system output = %.6f\n', err);
end
if(qID==3)
    [dim, err] = rotate(fname_inp1, fname_out, prmts, toshow); 
    fprintf('RMSE between my output and system output = %.6f\n', err);
    fprintf('Dimensions of output image = %dx%d\n', dim(1), dim(2));
end
if(qID==4)
    err = bit_plane_slicing(fname_inp1, fname_out, prmts, toshow);
    fprintf('RMSE between input and output 1 = %.6f\n', err(1));
    if size(err, 2)>1, fprintf('RMSE between input and output 2 = %.6f\n', err(2)); end
    if size(err, 2)>2, fprintf('RMSE between input and output 3 = %.6f\n', err(3)); end
end
if(qID==5)
    [dim, err] = tie_points(fname_inp1, fname_inp2,  fname_out, prmts, toshow);
    fprintf('RMSE between reference and output image = %.6f\n', err);
    fprintf('Dimensions of output image = %dx%d\n', dim(1), dim(2));
end
if(qID==6)
    [junk1, junk2, err] = histogram_equalization(fname_inp1, fname_out, toshow);
    fprintf('RMSE between outHeq and sysHeq = %.6f\n', err);
end
if(qID==7)
    err = histogram_matching(fname_inp1, fname_inp2, fname_out, toshow);
    fprintf('RMSE between histograms of inp2 and outp = %.6f\n', err);
end
if(qID==8)
    err = ahe(fname_inp1, fname_out, toshow);
    fprintf('RMSE between outHeq and sysHeq = %.6f\n', err);
end

%%%%% To calculate RMSE %%%%%
function err = rmse(A, B)
minx = min(size(A, 1), size(B, 1)); A=A(1:minx, :); B=B(1:minx, :); 
miny = min(size(A, 2), size(B, 2)); A=A(:, 1:miny); B=B(:, 1:miny); 
A = double(A);
B = double(B);
err = sqrt(mean((A(:)-B(:)).^2));
end

%%%%% Returns error image %%%%%
function err_img = rmse_img(A, B)
A = double(A);
B = double(B);
err_img = sqrt((A-B).^2);
end

%%%%% For nearest neighbour interpolation %%%%%
function err = nearest_neighbours(fname_inp, fname_out, prmts, toshow)
    
A = imread(fname_inp);
m = prmts(1);
n = prmts(2);
B = ones(m, n);
sizeA = size(A);
scaleX = sizeA(1)/m;
scaleY = sizeA(2)/n;

for i = 1:m
    for j = 1:n
        X = (i-0.5)*scaleX + 0.5;
        X = round(X);
        Y = (j-0.5)*scaleY + 0.5;
        Y = round(Y);
        B(i,j) = A(X, Y);
    end
end

B = uint8(B);
imwrite(B, sprintf('%s.tif', fname_out));
C = imresize(A, prmts, 'nearest');
D = imresize(A, prmts);
err = rmse(B, C);

if(toshow==1)
    figure;
    subplot(2,2,1); imshow(A); title(sprintf('Input image\nMean = %.2f', mean(A(:))));
    subplot(2,2,2); imshow(B); title(sprintf('Output image\nMean = %.2f\nRMSE=%.6f', mean(B(:)), err));
    subplot(2,2,3); imshow(C); title(sprintf('System output\nMean = %.2f', mean(C(:))));
    subplot(2,2,4); imshow(D); title(sprintf('System output using bicubic\nMean = %.2f', mean(D(:))));
   % sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f', mean(B(:)), err));
end
end

%%%%% For bilinear interpolation %%%%%
function err = bilinear(fname_inp, fname_out, prmts, toshow)

A = imread(fname_inp);
m = prmts(1);
n = prmts(2);
B = zeros(m, n);
sizeA = size(A);
scaleX = sizeA(1)/m;
scaleY = sizeA(2)/n;
A = double(A);

for i = 1:m
    for j = 1:n
        X = (i-0.5)*scaleX;
        Y = (j-0.5)*scaleY;  
        floorX = floor(X+0.5);
        ceilX = ceil(X+0.5);
        floorY = floor(Y+0.5);
        ceilY = ceil(Y+0.5);
  
        if floorX < 1
            floorX = 1;
        end
        if floorY < 1
            floorY = 1;
        end
        if ceilX > sizeA(1)
            ceilX = sizeA(1);
        end
        if ceilY > sizeA(2)
            ceilY = sizeA(2);
        end
        
        topleft = A(floorX, floorY);
        topright = A(ceilX, floorY);
        bottomleft = A(floorX, ceilY);
        bottomright = A(ceilX, ceilY);
        alpha = X - (floor(X+0.5) - 0.5);
        beta = Y - (floor(Y+0.5) - 0.5);

        if floorX == ceilX
            alpha = 0.5;
        end
        if floorY == ceilY
            beta = 0.5;
        end
        
        topright = double(topright);
        topleft = double(topleft);
        bottomleft = double(bottomleft);
        bottomright = double(bottomright);
        top = topright.*alpha + topleft.*(1-alpha);
        bottom = bottomright.*alpha + bottomleft.*(1-alpha);
        val = bottom.*beta + top.*(1-beta);
        B(i,j) = val;
        
    end
end

C = imresize(A, prmts, 'bilinear');
err = rmse(B, C);
imwrite(uint8(B), sprintf('%s.tif', fname_out));
D = imresize(A, prmts);

if(toshow==1)
    figure;
    subplot(2,2,1); imshow(uint8(A)); title(sprintf('Input image\nMean = %.2f', mean(A(:))));
    subplot(2,2,2); imshow(uint8(B)); title(sprintf('Output image\nMean = %.2f\nRMSE=%.6f', mean(B(:)), err));
    subplot(2,2,3); imshow(uint8(C)); title(sprintf('System output\nMean = %.2f', mean(C(:))));
    subplot(2,2,4); imshow(uint8(D)); title(sprintf('System output using bicubic\nMean = %.2f', mean(D(:))));
    %sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f', mean(B(:)), err));
end
end

%%%%% To rotate image anticlockwise by angle theta %%%%%
function [dim, err] = rotate(fname_inp, fname_out, prmts, toshow)

A = imread(fname_inp);
theta = prmts;
theta = mod(theta, 360);
thetadeg = theta;
theta = theta * pi/180;
sizeA = size(A);
m = sizeA(1);
n = sizeA(2);
c = cos(theta);
s = sin(theta);
M  = ceil(m*abs(c) + n*abs(s));
N = ceil(m*abs(s) + n*abs(c));
dim = [M, N];

if thetadeg==0 || thetadeg ==180
    M = m; N = n;
elseif thetadeg==90 || thetadeg==270
    M = n; N = m;
end

offX = M/2;
offY = N/2;
offx = m/2;
offy = n/2;
B = zeros(M, N);

for i = 1:M
    for j = 1:N    

        x = ((i - offX - 0.5)*c + (j - offY - 0.5)*s) + offx;
        y = ((j - offY - 0.5)*c - (i - offX - 0.5)*s) + offy;

        if x<-0.5 || y<-0.5 || x>m+0.5 || y>n+0.5
            continue;
        end
        
        floorx = floor(x+0.5);
        ceilx = ceil(x+0.5);
        floory = floor(y+0.5);
        ceily = ceil(y+0.5);
  
        if floorx < 1
            floorx = 1;
        end
        if floory < 1
            floory = 1;
        end
        if floorx>m
            floorx = m;
        end
        if floory>n
            floory = n;
        end
        if ceilx > m
            ceilx = m;
        end
        if ceily > n
            ceily = n;
        end
        if ceilx < 1
            ceilx = 1;
        end
        if ceily < 1
            ceily = 1;
        end
        
        topleft = A(floorx, floory);
        topright = A(ceilx, floory);
        bottomleft = A(floorx, ceily);
        bottomright = A(ceilx, ceily);
        alpha = x - (floor(x+0.5) - 0.5);
        beta = y - (floor(y+0.5) - 0.5);
  
        if x<0.5 && y<0.5
            topright = 0; topleft = 0; bottomleft = 0; bottomright = A(1, 1); alpha = 0.5+x; beta = 0.5+y;
        elseif x<0.5 && y>n-0.5
            topright = A(1, n); topleft = 0; bottomleft = 0; bottomright = 0; alpha = 0.5+x; beta = y-n+0.5;
        elseif x>m-0.5 && y<0.5
            topright = 0; topleft = 0; bottomleft = A(m, 1); bottomright = 0; alpha = x-m+0.5; beta = 0.5+y;
        elseif x>m-0.5 && y>n-0.5
            topright = 0; topleft = A(m,n); bottomleft = 0; bottomright = 0; alpha = x-m+0.5; beta = y-n+0.5;
        elseif x<0.5
            topleft = 0; bottomleft = 0; alpha = x+0.5;
        elseif y<0.5
            topright = 0; topleft = 0; beta = y+0.5;
        elseif x>m-0.5
            topright = 0; bottomright = 0; alpha = x-m+0.5;
        elseif y>n-0.5
            bottomleft = 0; bottomright = 0; beta = y-n+0.5;
        end

        topright = double(topright);
        topleft = double(topleft);
        bottomleft = double(bottomleft);
        bottomright = double(bottomright);
        top = topright.*alpha + 1.0.*topleft*(1-alpha);
        bottom = bottomright.*alpha + bottomleft.*(1-alpha);
        val = bottom.*beta + top.*(1-beta);  
        B(i,j) = val;
    end
end

C = imrotate(A, thetadeg, 'bilinear');
err = rmse(uint8(B), C);
imwrite(uint8(B), sprintf('%s.tif', fname_out));

if(toshow==1)
    figure;
    subplot(1,3,1); imshow(uint8(A)); title(sprintf('Input image\nMean = %.2f', mean(A(:))));
    subplot(1,3,2); imshow(uint8(B)); title(sprintf('Output image\nMean = %.2f\nRMSE = %.6f\nDim = %dx%d', mean(B(:)), err, M, N));
    subplot(1,3,3); imshow(uint8(C)); title(sprintf('System output\nMean = %.2f', mean(C(:))));
    %sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f, Output dim = %dx%d', mean(B(:)), err, M, N));
end
end

%%%%%% Bit plane slicing %%%%%%
function err = bit_plane_slicing(fname_inp, fname_out, prmts, toshow)

A = imread(fname_inp);
err = [];
for i=1:size(prmts, 2)
    planes = [];
    for j = 1:8
        pow = 2^(j-1);
        if bitand(prmts(i), pow)==pow, planes = [planes j]; end
    end
    outp(:, :, i) = bit_plane_helper(A, planes);
    imwrite(uint8(outp(:, :, i)), sprintf('%s_%d.tif', fname_out, i));
    temp_err = rmse(A, outp(:, :, i));
    err = [err temp_err];
end

if toshow==1
    if size(prmts, 2)==1
        figure; im1 = outp(:, :, 1);
        subplot(1,2,1); imshow(uint8(A)); title(sprintf('Input image\nMean = %.2f', mean(A(:))));
        subplot(1,2,2); imshow(uint8(outp(:, :, 1))); title(sprintf('Output image\nRMSE = %0.6f\nMean = %.2f', err(1), mean(im1(:))));
        
    end
    
     if size(prmts, 2)==2
        figure; im1 = outp(:, :, 1); im2 = outp(:, :, 2);
        subplot(1,3,1); imshow(uint8(A)); title(sprintf('Input image\nMean = %.2f', mean(A(:))));
        subplot(1,3,2); imshow(uint8(outp(:, :, 1))); title(sprintf('Output image 1\nRMSE = %0.6f\nMean = %.2f', err(1), mean(im1(:))));
        subplot(1,3,3); imshow(uint8(outp(:, :, 2))); title(sprintf('Output image 2\nRMSE = %0.6f\nMean = %.2f', err(2), mean(im2(:))));
     end
     
     if size(prmts, 2)==3
        figure; im1 = outp(:, :, 1); im2 = outp(:, :, 2); im3 = outp(:, :, 3); 
        subplot(2,2,1); imshow(uint8(A)); title(sprintf('Input image\nMean = %.2f', mean(A(:))));
        subplot(2,2,2); imshow(uint8(outp(:, :, 1))); title(sprintf('Output image 1\nRMSE = %0.6f\nMean = %.2f', err(1), mean(im1(:))));
        subplot(2,2,3); imshow(uint8(outp(:, :, 2))); title(sprintf('Output image 2\nRMSE = %0.6f\nMean = %.2f', err(2), mean(im2(:))));
        subplot(2,2,4); imshow(uint8(outp(:, :, 3))); title(sprintf('Output image 3\nRMSE = %0.6f\nMean = %.2f', err(3), mean(im3(:))));
     end
end
end

%%%%% Helper function for bit plane slicing %%%%%
function B = bit_plane_helper(A, planes)

sizeA = size(A);
num = size(planes, 2);
P(:, :, 1) = bitand(A, 1);
P(:, :, 2) = bitand(A, 2);
P(:, :, 3) = bitand(A, 4);
P(:, :, 4) = bitand(A, 8);
P(:, :, 5) = bitand(A, 16);
P(:, :, 6) = bitand(A, 32);
P(:, :, 7) = bitand(A, 64);
P(:, :, 8) = bitand(A, 128);
P = double(P);
B = zeros(sizeA);
for i = 1:num(1)
    Pi = P(:, :, planes(i));
    B = B + Pi;
end
B = uint8(B);
end

%%%%% Inverse affine transform using tie points %%%%%
function [dim, err] = tie_points(R_name, I_name, fname_out, tiepts, toshow)

I = imread(I_name);
R = imread(R_name);
output_shape = size(R);
dim = output_shape;

r1 = [tiepts(1,1) tiepts(1,2)]; i1 = [tiepts(1,3) tiepts(1,4)];
r2 = [tiepts(2,1) tiepts(2,2)]; i2 = [tiepts(2,3) tiepts(2,4)];
r3 = [tiepts(3,1) tiepts(3,2)]; i3 = [tiepts(3,3) tiepts(3,4)];
r4 = [tiepts(4,1) tiepts(4,2)]; i4 = [tiepts(4,3) tiepts(4,4)];

r1 = r1-0.5; r2 = r2-0.5; r3 = r3-0.5; r4 = r4-0.5;
i1 = i1-0.5; i2 = i2-0.5; i3 = i3-0.5; i4 = i4-0.5;

XY = [i1(1); i1(2); i2(1); i2(2); i3(1); i3(2); i4(1); i4(2)];
M = [r1(1) r1(2) r1(1)*r1(2) 1 0 0 0 0; 0 0 0 0 r1(1) r1(2) r1(1)*r1(2) 1; r2(1) r2(2) r2(1)*r2(2) 1 0 0 0 0; 0 0 0 0 r2(1) r2(2) r2(1)*r2(2) 1; r3(1) r3(2) r3(1)*r3(2) 1 0 0 0 0; 0 0 0 0 r3(1) r3(2) r3(1)*r3(2) 1; r4(1) r4(2) r4(1)*r4(2) 1 0 0 0 0; 0 0 0 0 r4(1) r4(2) r4(1)*r4(2) 1];
Minv = pinv(M);
C = Minv * XY;

A = zeros(output_shape);
I = double(I);

for i = 1:output_shape(1)
    for j = 1:output_shape(2)
        ic = i-0.5; jc = j-0.5;
        X = C(1)*ic + C(2)*jc + C(3)*ic*jc + C(4);
        Y = C(5)*ic + C(6)*jc + C(7)*ic*jc + C(8);
        floorX = floor(X+0.5);
        ceilX = ceil(X+0.5);
        floorY = floor(Y+0.5);
        ceilY = ceil(Y+0.5);

        if floorX < 1
            floorX = 1;
        end
        
        if floorX > size(I, 1)
            floorX = size(I, 1);
        end
        
        if floorY < 1
            floorY = 1;
        end
        
        if floorY > size(I, 2)
            floorY = size(I, 2);
        end
        
        if ceilX < 1
            ceilX = 1;
        end
        
        if ceilX > size(I, 1)
            ceilX = size(I, 1);
        end
        
        if ceilY < 1
            ceilY = 1;
        end
        
        if ceilY > size(I, 2)
            ceilY = size(I, 2);
        end

        topleft = I(floorX, floorY);
        topright = I(ceilX, floorY);
        bottomleft = I(floorX, ceilY);
        bottomright = I(ceilX, ceilY);
        alpha = X - (floor(X+0.5) - 0.5);
        beta = Y - (floor(Y+0.5) - 0.5);
        
        if floorX == ceilX
            alpha = 0.5;
        end
        if floorY == ceilY
            beta = 0.5;
        end

        top = topright.*alpha + topleft.*(1-alpha);
        bottom = bottomright.*alpha + bottomleft.*(1-alpha);
        val = bottom.*beta + top.*(1-beta);        
        A(i,j) = val;
    end
end

imwrite(uint8(A), sprintf('%s.tif', fname_out));
err = rmse(A, R);

if toshow==1
    err_img = rmse_img(A, R);
    figure;
    subplot(2,2,1); imshow(uint8(R)); title(sprintf('Reference image\nMean = %.2f\nDim = %dx%d', mean(R(:)), size(R, 1), size(R, 2)));
    subplot(2,2,2); imshow(uint8(I)); title(sprintf('Input image\nMean = %.2f\nDim = %dx%d', mean(I(:)), size(I, 1), size(I, 2)));
    subplot(2,2,3); imshow(uint8(A)); title(sprintf('My output\nMean = %.2f\nDim = %dx%d\nRMSE = %.6f', mean(A(:)), size(A, 1), size(A, 2), err));
    subplot(2,2,4); imshow(uint8(err_img)); title(sprintf('Error image\nMean = %.2f\nDim = %dx%d', mean(err_img(:)), size(err_img, 1), size(err_img, 2)));;
    %sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f, Output dim = %dx%d', mean(A(:)), err, dim(1), dim(2)));
end
end

%%%%% Histogram equalization %%%%%
function [B, mappings, err] = histogram_equalization(fname_inp, fname_out, toshow)

A = imread(fname_inp);
sizeA = size(A);

H = zeros(256, 1);
sizeH = size(H);
for i = 1:sizeA(1)
    for j = 1:sizeA(2)
        H(1 + A(i, j)) = H(1 + A(i, j)) + 1;
    end
end

for i = 2 : sizeH(1)
    H(i) = H(i-1) + H(i); 
end

H = (H./(sizeA(1) * sizeA(2))).*(sizeH(1)-1);

B = zeros(sizeA);
for i = 1:sizeA(1)
    for j = 1:sizeA(2)
        B(i, j) = H(1 + A(i, j));
    end
end

B = uint8(B);
imwrite(uint8(B), sprintf('%s.tif', fname_out));
C = histeq(A, 256);
err = rmse(B, C);
mappings = H;

if toshow==1
    figure;
    subplot(2,3,1); imshow(uint8(A)); title(sprintf('Input image (inp)\nMean = %.2f', mean(A(:))));
    subplot(2,3,2); imshow(uint8(B)); title(sprintf('My output (outHeq)\nMean = %.2f\nRMSE = %.6f', mean(B(:)), err));
    subplot(2,3,3); imshow(uint8(C)); title(sprintf('System output (sysHeq)\nMean = %.2f\n', mean(C(:))));
    subplot(2,3,4); plot(plothist(A)); title('inp histogram');
    subplot(2,3,5); plot(plothist(B)); title('outHeq histogram');
    subplot(2,3,6); plot(plothist(C)); title('sysHeq histogram');
    %sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f', mean(B(:)), err));
end
end

%%%%% Helper function for adaptive histeq and histogram matching %%%%%
function [B, mappings] = histeq_helper(A)

sizeA = size(A);

H = zeros(256, 1);
sizeH = size(H);
for i = 1:sizeA(1)
    for j = 1:sizeA(2)
        H(1 + A(i, j)) = H(1 + A(i, j)) + 1;
    end
end

for i = 2 : sizeH(1)
    H(i) = H(i-1) + H(i); 
end

H = (H./(sizeA(1) * sizeA(2))).*(sizeH(1)-1);

B = zeros(sizeA);
for i = 1:sizeA(1)
    for j = 1:sizeA(2)
        B(i, j) = H(1 + A(i, j));
    end
end

B = uint8(B);
mappings = H;

end

%%%%% Histogram matching %%%%%
function err = histogram_matching(fname_inp1, fname_inp2, fname_out, toshow)

A = imread(fname_inp1);
B = imread(fname_inp2);

[A_eq, HA] =  histeq_helper(A);
[B_eq, HB] =  histeq_helper(B);

sizeA = size(A);
C = zeros(sizeA);
sizeH = size(HA);

for i = 0:sizeH(1)-1
    min_diff = intmax;
    min_index = intmax;
    for j = 1:sizeH(1)
        if i > HB(j)
            diff = i - HB(j);
        else
            diff = HB(j) - i;
        end
        if diff < min_diff
            min_diff = diff;
            min_index = j;
        end
    end
    HA(i+1) = min_index - 1;
end

for i = 1:sizeA(1)
    for j = 1:sizeA(2)
        C(i, j) = HA(1 + A_eq(i, j));
    end
end

C = uint8(C);
histB = plothist(B); histC = plothist(C);
histB = histB/(size(B,1)*size(B,2)); histC = histC/(size(C,1)*size(C,2));  %Comment this line if histograms aren't to be normalized according to their sizes. Note: Commenting this line won't account for the fact that larger images will have much larger histograms and inflate the RMSE.
err = rmse(histB, histC);
imwrite(uint8(C), sprintf('%s.tif', fname_out));

if toshow==1
    figure;
    subplot(2,3,1); imshow(uint8(A)); title(sprintf('Input image 1 (inp1)\nMean = %.2f', mean(A(:))));
    subplot(2,3,2); imshow(uint8(B)); title(sprintf('Input image 2 (inp2)\nMean = %.2f', mean(B(:))));
    subplot(2,3,3); imshow(uint8(C)); title(sprintf('Output image (outp)\nMean = %.2f\n', mean(C(:))));
    subplot(2,3,4); plot(plothist(A)); title('inp1 histogram');
    subplot(2,3,5); plot(plothist(B)); title('inp2 histogram');
    subplot(2,3,6); plot(plothist(C)); title(sprintf('outp histogram\nRMSE = %.6f', err));
    %sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f', mean(C(:)), err));
end
end

%%%%% Generate histogram %%%%%
 function H = plothist(A)
A = uint8(A);
H = zeros(256, 1);
for i = 1:size(A, 1)
    for j = 1:size(A, 2)
        H(1 + A(i, j)) = H(1 + A(i, j)) + 1;
    end
end
end


%%%%% Adaptive histogram equalization with tile size = 8 %%%%%
function [err, B, C] = ahe(fname_inp1, fname_out, toshow)

A = imread(fname_inp1);
tiles = [8, 8];
m = size(A, 1)/tiles(1);
n = size(A, 2)/tiles(2);
for i = 1:tiles(1)
    for j = 1:tiles(2)
        x1 = (i-1)*m + 1;
        x2 = i*m;
        y1 = (j-1)*n + 1;
        y2 = j*n;
        x1 = floor(x1); x2 = floor(x2); y1 = floor(y1); y2 = floor(y2);
        if i==tiles(1), x2=size(A,1); end
        if j==tiles(2), y2=size(A,2); end
        subimg = A(x1:x2, y1:y2);
        pos = tiles(1)*(i-1) + j;
        [eq, P(i, j, :)] = histeq_helper(subimg);
        
    end
end

A = double(A);
B = zeros(size(A));
for i = 1:size(A, 1)
    for j = 1:size(A, 2)
       
        X1 = floor((i + m/2) / m);
        Y1 = floor((j + n/2) / n);
        X2 = X1+1; Y2 = Y1+1;
        if X1<1
            X1=1;
        end
        if X2>tiles(1)
            X2=tiles(1);
        end
        if Y1<1
            Y1=1;
        end
        if Y2>tiles(2)
            Y2=tiles(2);
        end
        
        topleft = P(X1, Y1, 1+A(i,j));
        topright = P(X2, Y1, 1+A(i,j));
        bottomleft = P(X1, Y2, 1+A(i,j));
        bottomright = P(X2, Y2, 1+A(i,j));
        alpha = 0.5 - X1 + i/m;
        beta = 0.5 - Y1 + j/n;
        top = (1-alpha)*topleft + alpha*topright;
        bottom = (1-alpha)*bottomleft + alpha*bottomright;
        B(i,j) = (1-beta)*top + beta*bottom;
 
    end
end
C = adapthisteq(uint8(A),'clipLimit',1);  % CLAHE with clip limit = 1 implements AHE.
err = rmse(B, C);
imwrite(uint8(B), sprintf('%s.tif', fname_out));

if toshow==1
    figure;
    subplot(2,3,1); imshow(uint8(A)); title(sprintf('Input image (inp)\nMean = %.2f', mean(A(:))));
    subplot(2,3,2); imshow(uint8(B)); title(sprintf('My output (outHeq)\nMean = %.2f\nRMSE = %.6f', mean(B(:)), err));
    subplot(2,3,3); imshow(uint8(C)); title(sprintf('System output (sysHeq)\nMean = %.2f\n', mean(C(:))));
    subplot(2,3,4); plot(plothist(A)); title('inp histogram');
    subplot(2,3,5); plot(plothist(B)); title('outHeq histogram');
    subplot(2,3,6); plot(plothist(C)); title('sysHeq histogram');
    %sgtitle(sprintf('Mean=%0.2f, RMSE=%0.2f', mean(B(:)), err));
end
end

end