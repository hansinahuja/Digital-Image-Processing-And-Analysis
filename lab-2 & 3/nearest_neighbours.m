function B = nearest_neighbours(m, n, A)

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

end