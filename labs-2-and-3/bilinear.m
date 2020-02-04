function B = bilinear(m, n, A)

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

        top = topright.*alpha + topleft.*(1-alpha);
        bottom = bottomright.*alpha + bottomleft.*(1-alpha);
        val = bottom.*beta + top.*(1-beta);
        B(i,j) = val;
    end
end

B = uint8(B);

end