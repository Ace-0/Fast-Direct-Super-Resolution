function [ psnr ] = PSNR(img1, img2)
    if size(img1) ~= size(img2)
        error('The sizes of two images are different');
    end
    if ndims(img1) == 3
        img1 = rgb2ycbcr(img1);
        img1 = img1(:,:,1);
        img2 = rgb2ycbcr(img2);
        img2 = img2(:,:,1);
    end
    img1 = double(img1);
    img2 = double(img2);
    mse = get_mse(img1, img2);
    level = 255;
    psnr = 20 * log10(level / sqrt(mse));
end

function [ mse ] = get_mse(img1, img2)
    diff_mat = img1 - img2;
    mse = mean2(diff_mat.^2);
end