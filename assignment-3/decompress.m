function img_dec = decompress(img_comp, n, m, Q)

    img_dec = zeros(size(img_comp));
    M = size(img_comp, 1);
    N = size(img_comp, 2);
    numX = M/n;
    numY = N/n;
    for i = 1:numX
        for j = 1:numY
            subimg_comp = img_comp(i*n - n + 1: i*n, j*n - n + 1: j*n);
            subimg_comp = subimg_comp .* Q;
            subimg_dec = zeros(size(subimg_comp));
            for x=0:n-1
                for y=0:n-1
                    for u=0:m-1
                        for v=0:m-1
                            pix = subimg_comp(u+1, v+1);
                            c1 = cos(((2*x+1)*u*pi)/(2*n));
                            c2 = cos(((2*y+1)*v*pi)/(2*n));
                            val = pix*c1*c2;
                            if(u==0), val = val * sqrt(1/2); end
                            if(v==0), val = val * sqrt(1/2); end
                            subimg_dec(x+1, y+1) = subimg_dec(x+1, y+1) + val;
                        end
                    end
                    subimg_dec(x+1, y+1) = subimg_dec(x+1, y+1)*(2/n);
                end
            end
            subimg_dec = round(subimg_dec);
            subimg_dec = subimg_dec + 128;
            img_dec(i*n - n + 1: i*n, j*n - n + 1: j*n) = subimg_dec;
        end
    end
end