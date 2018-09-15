function [ hr_patches, lr_patches ] = getPatchFromHR( hr_img_y, sigma, scale_f, lr_p_size, lr_center_size )
    depth = size(hr_img_y, 3);
    if depth ~= 1
        error('The image here should only contain its Y channel');
    end
    [hr_img, lr_img] = generateLRimage(hr_img_y, sigma, scale_f);
    hr_p_size = lr_p_size * scale_f;
    hr_center_size = lr_center_size * scale_f;
    hr_patches = getHRpatches(hr_img, scale_f, hr_p_size, hr_center_size);
    lr_patches = getLRpatches(lr_img, lr_p_size);

    mean_inten = mean(lr_patches);  % shape: 1 * num_of_patch
    mean_mat_hr = repmat(mean_inten, [hr_center_size^2, 1]);
    mean_mat_lr = repmat(mean_inten, [lr_p_size^2 - 4, 1]);
    hr_patches = hr_patches - mean_mat_hr;
    lr_patches = lr_patches - mean_mat_lr;
end


function [ hr_patches ] = getHRpatches( hr_img, scale_f, hr_p_size, hr_center_size )
    [hr_height, hr_width] = size(hr_img);
    num_of_hr_patch = ((hr_height - hr_p_size) / scale_f + 1) * ((hr_width - hr_p_size) / scale_f + 1);
    pixels_of_patch = hr_center_size^2;
    hr_patches = zeros(pixels_of_patch, num_of_hr_patch);
    trim_size = (hr_p_size - hr_center_size) / 2;
    index = 1;
    for i = 1 : scale_f : hr_height - hr_p_size + 1
        for j = 1 : scale_f : hr_width - hr_p_size + 1
            hr_patch_2d = hr_img(i+trim_size : i+trim_size+hr_center_size-1, j+trim_size : j+trim_size+hr_center_size-1);
            hr_patch_1d = reshape(hr_patch_2d(:, :), [pixels_of_patch, 1]);
            hr_patches(:, index) = hr_patch_1d;
            index = index + 1;
        end
    end
end

function [ lr_patches ] = getLRpatches( lr_img, lr_p_size )
    [lr_height, lr_width] = size(lr_img);
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
end
