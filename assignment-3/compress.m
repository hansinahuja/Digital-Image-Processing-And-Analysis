function img_comp = compress(img, n, Q)

    padX = mod(size(img, 1), n);
    padY = mod(size(img, 2), n);
    img = padarray(img, [padX, padY], 'post');
    img_comp = zeros(size(img));
    M = size(img, 1);
    N = size(img, 2);
    numX = M/n;
    numY = N/n;
    img = double(img);

    for i = 1:numX
        for j = 1:numY
            subimg = img(i*n - n + 1: i*n, j*n - n + 1: j*n);
            subimg = subimg - 128;
            subimg_comp = zeros(size(subimg));
            for u=0:n-1
                for v=0:n-1
                    for x=0:n-1
                        for y=0:n-1
                            pix = subimg(x+1, y+1);
                            c1 = cos(((2*x+1)*u*pi)/(2*n));
                            c2 = cos(((2*y+1)*v*pi)/(2*n));
                            subimg_comp(u+1, v+1) = subimg_comp(u+1, v+1) + (pix*c1*c2);
                        end
                    end
                    if(u==0), subimg_comp(u+1, v+1) = subimg_comp(u+1, v+1) * sqrt(1/n); 
                    else, subimg_comp(u+1, v+1) = subimg_comp(u+1, v+1) * sqrt(2/n);   end
                    if(v==0), subimg_comp(u+1, v+1) = subimg_comp(u+1, v+1) * sqrt(1/n); 
                    else, subimg_comp(u+1, v+1) = subimg_comp(u+1, v+1) * sqrt(2/n);   end
                end
            end
            subimg_comp = subimg_comp ./ Q;
            subimg_comp = round(subimg_comp);
            img_comp(i*n - n + 1: i*n, j*n - n + 1: j*n) = subimg_comp;
        end
    end

end