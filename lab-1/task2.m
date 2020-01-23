m = 1024;
n = 1024;
A = ones(m, n);
A(round(m/2)-2:round(m/2)+2, :) = 0;
A(:, round(n/2)-2:round(n/2)+2) = 0;
imshow(A);
