function err = rmse(A, B)
    minx = min(size(A, 1), size(B, 1)); A=A(1:minx, :); B=B(1:minx, :); 
    miny = min(size(A, 2), size(B, 2)); A=A(:, 1:miny); B=B(:, 1:miny); 
    A = double(A);
    B = double(B);
    err = sqrt(mean((A(:)-B(:)).^2));
end