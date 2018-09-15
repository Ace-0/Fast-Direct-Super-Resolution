function [ lr_patches, mean_inten ] = getTestLRpatches( lr_img, lr_p_size, sigma )
    [lr_height, lr_width] = size(lr_img);
    
    kernal = gaussionKernal(sigma);
    half_k_size = (size(kernal, 1)-1)/2;
    lr_img_ext = wextend('2d','symw', lr_img, half_k_size);  %5 pixels are extended in each side
    lr_img = conv2my(lr_img_ext, kernal);
    
    num_of_lr_patch = (lr_height - lr_p_size + 1) * (lr_width - lr_p_size + 1);
    pixels_of_patch = lr_p_size^2 - 4;
    lr_patches = zeros(pixels_of_patch, num_of_lr_patch);
    index = 1;
    for i = 1 : lr_height - lr_p_size + 1
        for j = 1 : lr_width - lr_p_size + 1
            lr_patch_2d = lr_img(i : i+lr_p_size-1, j : j+lr_p_size-1);
            lr_patch_1d(1:5) = lr_patch_2d(1, 2:6);
            lr_patch_1d(6:40) = reshape(lr_patch_2d(2:6, 1:7), [35, 1]);
            lr_patch_1d(41:45) = lr_patch_2d(7, 2:6);
            lr_patches(:, index) = lr_patch_1d;
            index = index + 1;
        end
    end
    
    mean_inten = mean(lr_patches);  % shape: 1 * num_of_patch
    mean_mat_lr = repmat(mean_inten, [lr_p_size^2 - 4, 1]);
    lr_patches = lr_patches - mean_mat_lr;
end