function err = main()
M = [];
for d = 1:24
    if(d<10), st = strcat('dataset/kodim0', num2str(d)); 
    else st = strcat('dataset/kodim', num2str(d)); end
    img_path = strcat(st, '.png');
    img = rgb2gray(imread(img_path));
    Q = [16	11	10	16	24	40	51	61;
    12	12	14	19	26	58	60	55;
    14	13	16	24	40	57	69	56;
    14	17	22	29	51	87	80	62;
    18	22	37	56	68	109	103	77;
    24	35	55	64	81	104	113	92;
    49	64	78	87	103	121	120	101;
    72	92	95	98	112	100	103	99];
    n = 8;
    img_comp = compress(img, n, Q);
    imgs = [];
    rmses = [];
    for m=1:n
        imgs(:, :, m) = decompress(img_comp, n, m, Q);
        rmses = [rmses rmse(img, imgs(:, :, m))];
        %disp([m, rmse(img, imgs(:, :, m))]);
    end
    M = [M; rmses];
    %figure;
    %subplot(2,2,1); imshow(uint8(img)); title(sprintf('Original image'));
    %subplot(2,2,2); imshow(uint8(imgs(:, :, 1))); title(sprintf('1x1 decompression\nRMSE = %.2f', rmse(img, imgs(:, :, 1))));
    %subplot(2,2,3); imshow(uint8(imgs(:, :, 4))); title(sprintf('4x4 decompression\nRMSE = %.2f', rmse(img, imgs(:, :, 2))));
    %subplot(2,2,4); imshow(uint8(imgs(:, :, 8))); title(sprintf('8x8 decompression\nRMSE = %.2f', rmse(img, imgs(:, :, 3))));
    disp(d);
end
err = M;
end

