function [ mssim ] = SSIM(img1, img2)
    if size(img1) ~= size(img2)
        error('The sizes of two images are different');
    end
    % 直接用size就行，因为不一定有第三维？?
    if ndims(img1) == 3
    	img1 = rgb2ycbcr(img1);
        img1 = img1(:,:,1);
        img2 = rgb2ycbcr(img2);
        img2 = img2(:,:,1);
    end
    img1 = double(img1);
    img2 = double(img2);
    
    k = [0.01, 0.03];
    level = 255;
    window = gaussionKernal(1.5);
    window = window/sum(sum(window));
    mu1 = conv2my(img1, window);
    mu2 = conv2my(img2, window);
    mu1_sq = mu1.^2;
    mu2_sq = mu2.^2;
    mu12 = mu1.*mu2;
    sigma1_sq = conv2my(img1.^2, window) - mu1_sq;
    sigma2_sq = conv2my(img2.^2, window) - mu2_sq;
    sigma12 = conv2my(img1.*img2, window) - mu12;
    c1 = (k(1) * level)^2;
    c2 = (k(2) * level)^2;
    up = (2 * (mu12) + c1) .* (2 * sigma12 + c2);
    down = (mu1_sq + mu2_sq + c1) .* (sigma1_sq + sigma2_sq + c2);

    ssim_mat = up./down;

    mssim = mean2(ssim_mat);
