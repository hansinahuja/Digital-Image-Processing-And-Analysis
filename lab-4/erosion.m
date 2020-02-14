function C = erosion(A, B)

m = floor(size(B, 1)/2);
n = floor(size(B, 2)/2);
C = zeros(size(A));

for i = 1:size(A, 1)
    for j = 1:size(A, 2)
        flag = 0;
        for p = 0-m:0+m
            for q = 0-n:0+n
                Bpix = B(p+m+1, q+n+1);
                Ap = i + p;
                Aq = j + q;
                if Ap<1 || Aq<1 || Ap>size(A, 1) || Aq>size(A, 2)
                   Apix = 0;
                else
                    Apix = A(Ap, Aq);
                end
                
                if Bpix==1 && Apix==0
                    flag = 1;
                end
                
            end
        end
        
        if flag==1
            C(i,j)=0;
        else
            C(i,j)=1;
        end
        
    end
end


end