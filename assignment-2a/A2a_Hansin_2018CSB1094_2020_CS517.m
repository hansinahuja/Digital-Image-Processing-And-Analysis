% Some sample function calls (details in README.txt):
% imgs = A2a_Hansin_2018CSB1094_2020_CS517('cameraman.tif', '', 0, [], [cos(pi/6) -sin(pi/6) 0; sin(pi/6) cos(pi/6) 0; 0 0 1], 'cameraman_rotate30', 1);
% imgs = A2a_Hansin_2018CSB1094_2020_CS517('circuit.tif', '', 0, [], [cos(pi/6) sin(pi/6) 0; -sin(pi/6) cos(pi/6) 0; 0 0 1], 'circuit_rotate-30', 1);
% t1 = -128*cos(pi/6) + 128*sin(pi/6) +128; t2 = -128*cos(pi/6) - 128*sin(pi/6) + 128; imgs = A2a_Hansin_2018CSB1094_2020_CS517('cameraman.tif', '', 0, [], [cos(pi/6) -sin(pi/6) t1; sin(pi/6) cos(pi/6) t2; 0 0 1], 'cameraman_centrerotate30', 1);
% t1 = -140*cos(pi/6) - 136*sin(pi/6) +140; t2 = -140*cos(pi/6) + 136*sin(pi/6) + 136; imgs = A2a_Hansin_2018CSB1094_2020_CS517('circuit.tif', '', 0, [], [cos(pi/6) sin(pi/6) t1; -sin(pi/6) cos(pi/6) t2; 0 0 1], 'circuit_centrerotate-30', 1);
% imgs = A2a_Hansin_2018CSB1094_2020_CS517('tire.tif', '', 0, [], [1 0 100; 0 1 100; 0 0 1], 'tire_translate', 1);
% imgs = A2a_Hansin_2018CSB1094_2020_CS517('kids.tif', '', 0, [], [2 1 0; 1 2 0; 0 0 1], 'kids_shear', 1);

function imgs = A2a_Hansin_2018CSB1094_2020_CS517(fname_inp1, fname_inp2, angle, tpts, afnTM, fname_out, toshow)

A = imread(fname_inp1);
I = [1 0 0; 0 1 0; 0 0 1];
X = afnTM;

corners = zeros([1, 3, 4]);
limits = zeros(2);
corners(:, :, 1) = [0 0 1]; corners(:, :, 2) = [size(A, 1) 1 1]; corners(:, :, 3) = [1 size(A, 2) 1]; corners(:, :, 4) = [size(A, 1) size(A, 2) 1];
corners(:, :, 1) = X*transpose(corners(:, :, 1)); corners(:, :, 2) = X*transpose(corners(:, :, 2)); corners(:, :, 3) = X*transpose(corners(:, :, 3)); corners(:, :, 4) = X*transpose(corners(:, :, 4));
limits(1, 1) = max([max(corners(1, 1, :)), 1, size(A, 1)]); limits(1, 2) = min([min(corners(1, 1, :)), 1, size(A, 1)]);
limits(2, 1) = max([max(corners(1, 2, :)), 1, size(A, 2)]); limits(2, 2) = min([min(corners(1, 2, :)), 1, size(A, 2)]);
targsize = 1 + ceil([limits(1,1) - limits(1, 2) limits(2,1) - limits(2,2)]);
alpha100 = 0;
curr = 1;
imgs = [];
Xi = pinv(X);

while(alpha100 <= 100)
    alpha = alpha100/100;
    Xt = (1-alpha)*I + alpha*Xi;
    if(det(Xt) == 0)
        alpha100 = alpha100 + 1;
        continue;
    end
    img = zeros(targsize);
    for i = 1:targsize(1)
        for j = 1:targsize(2)
            pt = [i-0.5, j-1.5, 1] + [limits(1,2)-1, limits(2,2)-1, 0];
            pt = Xt * transpose(pt);
            alpha = pt(1)-round(pt(1))+0.5; beta = pt(2)-round(pt(2))+0.5; 
            floorX = round(pt(1)); floorY = round(pt(2)); ceilX = floorX + 1; ceilY = floorY + 1;        
            if(floorX<0 || floorY<0 || floorX>size(A, 1) || floorY>size(A, 2)), continue; end
            if(floorX < 1), floorX = 1; end
            if(floorY < 1), floorY = 1; end
            if(ceilX > size(A, 1)), ceilX = size(A, 1); end
            if(ceilY > size(A, 2)), ceilY = size(A, 2); end
            val1 = A(floorX, floorY); val2 =  A(floorX, ceilY); val3 =  A(ceilX, floorY); val4 =  A(ceilX, ceilY);
            top = val1*(1-alpha) +  val3*alpha;
            bottom = val2*(1-alpha) +  val4*alpha;
            val = top*(1-beta) + bottom*beta;
            img(i, j) = val;
        end
    end   
    imgs(:, :, curr) = img;
    curr = curr+1;
    alpha100 = alpha100 + 1;
end

name = append(fname_out, ".gif");
for k = 1:size(imgs, 3)
    if k ==1
        imwrite(uint8(imgs(:,:,k)), name, 'gif', 'LoopCount', Inf, 'DelayTime', 0.02);
    else
        imwrite(uint8(imgs(:,:,k)), name, 'gif', 'WriteMode', 'append', 'DelayTime', 0.02);
    end
end

if(toshow == 1)
    unit = size(imgs, 3)/8;
    subplot(3,3,1); imshow(uint8(imgs(:, :, 1))); title('0% Morphing');
    subplot(3,3,2); imshow(uint8(imgs(:, :, round(1*unit)))); title('12.5% Morphing');
    subplot(3,3,3); imshow(uint8(imgs(:, :, round(2*unit)))); title('25% Morphing');
    subplot(3,3,4); imshow(uint8(imgs(:, :, round(3*unit)))); title('37.5% Morphing');
    subplot(3,3,5); imshow(uint8(imgs(:, :, round(4*unit)))); title('50% Morphing');
    subplot(3,3,6); imshow(uint8(imgs(:, :, round(5*unit)))); title('62.5% Morphing');
    subplot(3,3,7); imshow(uint8(imgs(:, :, round(6*unit)))); title('75% Morphing');
    subplot(3,3,8); imshow(uint8(imgs(:, :, round(7*unit)))); title('87.5% Morphing');
    subplot(3,3,9); imshow(uint8(imgs(:, :, size(imgs, 3)))); title('100% Morphing');
end
imgs = uint8(imgs);

end