I = imread('test_pattern_transformed.tif');
R = imread('test_pattern_tie_points.tif');

r1 = [115, 117];
i1 = [192, 128];
r2 = [80, 617];
i2 = [487, 625];   
r3 = [633, 77];
i3 = [684, 140];
r4 = [613, 602];
i4 = [1011, 664];

XY = [i1(1); i1(2); i2(1); i2(2); i3(1); i3(2); i4(1); i4(2)];
M = [r1(1) r1(2) r1(1)*r1(2) 1 0 0 0 0; 0 0 0 0 r1(1) r1(2) r1(1)*r1(2) 1; r2(1) r2(2) r2(1)*r2(2) 1 0 0 0 0; 0 0 0 0 r2(1) r2(2) r2(1)*r2(2) 1; r3(1) r3(2) r3(1)*r3(2) 1 0 0 0 0; 0 0 0 0 r3(1) r3(2) r3(1)*r3(2) 1; r4(1) r4(2) r4(1)*r4(2) 1 0 0 0 0; 0 0 0 0 r4(1) r4(2) r4(1)*r4(2) 1];
Minv = pinv(M);
C = Minv * XY;

sizeI = size(I);
sizeR = size(R);
A = zeros(sizeR);
m = sizeR(1);
n = sizeR(2);
I = double(I);
R = double(R);

for i = 1:m
    for j = 1:n
        X = C(1)*i + C(2)*j + C(3)*i*j + C(4);
        Y = C(5)*i + C(6)*j + C(7)*i*j + C(8);

        floorX = floor(X+0.5);
        ceilX = ceil(X+0.5);
        floorY = floor(Y+0.5);
        ceilY = ceil(Y+0.5);

        if floorX < 1
            floorX = 1;
        end
        
        if floorX > sizeI(1)
            floorX = sizeI(1);
        end
        
        if floorY < 1
            floorY = 1;
        end
        
        if floorY > sizeI(2)
            floorY = sizeI(2);
        end
        
        if ceilX < 1
            ceilX = 1;
        end
        
        if ceilX > sizeI(1)
            ceilX = sizeI(1);
        end
        
        if ceilY < 1
            ceilY = 1;
        end
        
        if ceilY > sizeI(2)
            ceilY = sizeI(2);
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
        val = round(bottom.*beta + top.*(1-beta));        
        A(i,j) = val;
    end
end

A = double(A);
R = double(R);
err_img = sqrt((A-R).^2);
err = sqrt(mean((A(:)-R(:)).^2));
A = uint8(A);