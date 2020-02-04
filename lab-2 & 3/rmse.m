function ans = rmse(A, B)

A = double(A);
B = double(B);
ans = sqrt(mean((A(:)-B(:)).^2));

end