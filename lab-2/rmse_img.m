function ans = rmse(A, B)

A = double(A);
B = double(B);
ans = sqrt((A-B).^2);

end