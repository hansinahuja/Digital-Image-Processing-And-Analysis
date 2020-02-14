function B = myblur(A, k)

lim = floor(k/2);
B = zeros(size(A));
for i = 1:size(A,1)
    for j= 1:size(A,2)
        p1 = i-lim;
        p2 = i+lim;
        q1 = j-lim;
        q2 = j+lim;
        if p1<1, p1=1; end
        if p2>size(A, 1), p2 = size(A, 1); end
        if q1<1, q1=1; end
        if q2>size(A, 2), q2 = size(A, 2); end
        subimg = A(p1:p2, q1:q2);
        B(i, j) = mean(subimg(:));
        
    end
end

figure;
subplot(1, 2, 1); imshow(uint8(A));
subplot(1, 2, 2); imshow(uint8(B));

end