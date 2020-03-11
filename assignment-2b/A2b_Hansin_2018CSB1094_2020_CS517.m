% Sample function calls (details are in README.txt):
% load eg1_pts; imgs = A2b_Hansin_2018CSB1094_2020_CS517('hansin.jpg', 'andy.jpeg', eg1_pts, 'eg1_outp', 1);
% load eg2_pts; imgs = A2b_Hansin_2018CSB1094_2020_CS517('walt.jpg', 'jesse.jpg', eg2_pts, 'eg2_outp', 1);

function imgs = A2b_Hansin_2018CSB1094_2020_CS517(fname_inp1, fname_inp2, tpts, fname_out, toshow)
im1 = double(imread(fname_inp1));
im2 = double(imread(fname_inp2));
hp = tpts(:, 1:2);
cp = tpts(:, 3:4);
hp = [hp; [0.5, 0.5]; [0.5, size(im1, 2)-0.5]; [size(im1, 1)-0.5, 0.5]; [size(im1, 1)-0.5, size(im1, 2)-0.5]];
cp = [cp; [0.5, 0.5]; [0.5, size(im2, 2)-0.5]; [size(im2, 1)-0.5, 0.5]; [size(im2, 1)-0.5, size(im2, 2)-0.5]];
ap = (hp+cp)/2;
dt = delaunayTriangulation(ap);
frames = 61;
count = 1;
imgs = [];
for alpha = linspace(0, 1, frames)
    if(alpha==0), img = im1;
    elseif(alpha==1), img = im2;
    else
        ip = (1-alpha)*hp + alpha*cp;
        im1t = transform(dt, im1, hp, ip);
        im2t = transform(dt, im2, cp, ip);
        img = (1-alpha)*im1t + alpha*im2t;
    end
    fprintf("Frame %d/%d.\n", count, frames);
    imgs(:, :, :, count) = img;
    count = count + 1; 
end

% To create the gif, I used the logic given in the following link:
% https://www.mathworks.com/matlabcentral/answers/94495-how-can-i-create-animated-gif-images-in-matlab
filename = strcat(fname_out, '.gif');
time = 0.03;
for i = 1:size(imgs, 4)
    img = uint8(imgs(:, :, :, i));
    [A, map] = rgb2ind(img, 256);
    if i == 1
        imwrite(A, map, filename, 'gif', 'LoopCount', Inf, 'DelayTime', time);
    else
        imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', time);
    end
end

for i = size(imgs, 4):-1:1
    img = uint8(imgs(:, :, :, i));
    [A, map] = rgb2ind(img, 256);
    imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', time);
end

if(toshow == 1)
    unit = frames/8;
    subplot(3,3,1); imshow(uint8(imgs(:, :, :, 1))); title('0% Morphing');
    subplot(3,3,2); imshow(uint8(imgs(:, :, :, round(1*unit)))); title('12.5% Morphing');
    subplot(3,3,3); imshow(uint8(imgs(:, :, :, round(2*unit)))); title('25% Morphing');
    subplot(3,3,4); imshow(uint8(imgs(:, :, :, round(3*unit)))); title('37.5% Morphing');
    subplot(3,3,5); imshow(uint8(imgs(:, :, :, round(4*unit)))); title('50% Morphing');
    subplot(3,3,6); imshow(uint8(imgs(:, :, :, round(5*unit)))); title('62.5% Morphing');
    subplot(3,3,7); imshow(uint8(imgs(:, :, :, round(6*unit)))); title('75% Morphing');
    subplot(3,3,8); imshow(uint8(imgs(:, :, :, round(7*unit)))); title('87.5% Morphing');
    subplot(3,3,9); imshow(uint8(imgs(:, :, :, size(imgs, 4)))); title('100% Morphing');
end
end
function imt = transform(dt, im, hp, ip)

% To locate the point in a triangle, we use basic geometry: the cross product of
% a side and the vector joining the point and corresponding vertex will be negative.
% This must be valid for all 3 vertices.
t = zeros([size(im, 2), size(im, 1)]);
x = ip(:, 1); y = ip(:, 2);
for j = 1:size(dt,1)
    x1 = x(dt(j, 1)); x2 = x(dt(j, 2)); x3 = x(dt(j, 3)); y1 = y(dt(j, 1)); y2 = y(dt(j, 2)); y3 = y(dt(j, 3));
    for p = 1:size(im, 2)
        for q = 1:size(im, 1)
            if ((x2-x1)*(q-y1) - (y2-y1)*(p-x1)) * ((x2-x1)*(y3-y1) - (y2-y1)*(x3-x1)) < 0, continue; end
            if ((x3-x2)*(q-y2) - (y3-y2)*(p-x2)) * ((x3-x2)*(y1-y2) - (y3-y2)*(x1-x2)) < 0, continue; end
            if ((x1-x3)*(q-y3) - (y1-y3)*(p-x3)) * ((x1-x3)*(y2-y3) - (y1-y3)*(x2-x3)) < 0, continue; end
            t(p, q) = j;
        end
    end
end

am = zeros(3, 3, size(dt, 1));
for i = 1:size(dt, 1)
    Ainv = pinv(transpose([hp(dt(i, :), :) ones(3,1)]));
    B = transpose([ip(dt(i, :), :) ones(3,1)]);
    am(:, :, i) = B*Ainv;
end

imt = im;
for i = 1:size(im, 1)
    for j = 1:size(im, 2)
        if(t(j, i) == 0), continue; end
        iam = pinv(am(:, :, t(j, i)));
        pt = [j; i; 1];
        p = round(iam*pt);
        if(p(1) < 1) p(1) = 1; end
        if(p(2) < 1) p(2) = 1; end
        if(p(1) > size(im, 2)) p(1) = size(im, 2); end
        if(p(2) > size(im, 1)) p(2) = size(im, 1); end
        imt(i, j, :) = im(p(2), p(1), :);
    end
end
end