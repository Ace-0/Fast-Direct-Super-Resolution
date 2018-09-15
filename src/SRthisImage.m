load('data/clus_idx', 'clus_idx');
load('data/clus_mat', 'clus_mat');
load('data/all_coef_matrix', 'all_coef_matrix');
load('data/cluster_patch_count', 'cluster_patch_count');

depth = size(lr_img, 3);

if depth == 3
    lr_img = rgb2ycbcr(lr_img);
    lr_img_y = lr_img(:, :, 1);
    lr_img_uv = lr_img(:, :, 2:3);
else
    lr_img_y = lr_img;
end

lr_img_y = double(lr_img_y);

lr_p_size = 7;
scale_f = 3;
lr_center_size = 3;
sigma = 0.6;

lr_img_y_ext = wextend('2d','symw', lr_img_y, 2);  %2 pixels are extended in each side

[lr_patches, mean_inten] = getTestLRpatches(lr_img_y_ext, lr_p_size, sigma);
cluster_indexes = getClusterIndex(lr_patches); % 1*num_of_patches
height = size(lr_img_y, 1);
width = size(lr_img_y, 2);
ext_height_ = size(lr_img_y_ext, 1);
ext_width = size(lr_img_y_ext, 2);
hr_height = height * scale_f;
hr_width = width * scale_f;
num_of_patches = size(lr_patches, 2);
hr_center_size = lr_center_size * scale_f;

value_count = zeros(hr_height, hr_width);
hr_img_y = zeros(hr_height, hr_width);
one_mat = ones(hr_center_size, hr_center_size);

hr_start_h = 1;
hr_start_w = 1;
for k = 1 : num_of_patches
    if mod(k, 10000) == 0
        fprintf('processing patch No.%dw/%dw\n', k, num_of_patches);
    end
    this_cluster_index = cluster_indexes(1, k);
    this_mean = mean_inten(1, k);
    this_coef_matrix = all_coef_matrix(:, :, this_cluster_index);
    this_lr_patch = lr_patches(:, k);
    % º∆À„hr_patch
    if cluster_patch_count(this_cluster_index) < 46
        lr_patch_mat = zeros(lr_center_size, lr_center_size);
        lr_patch_mat(1, :) = this_lr_patch(15 : 17);
        lr_patch_mat(2, :) = this_lr_patch(22 : 24);
        lr_patch_mat(3, :) = this_lr_patch(29 : 31);
        hr_patch_mat = imresize(lr_patch_mat, scale_f, 'bilinear');
    else
        this_lr_patch = [this_lr_patch; 1];
        hr_patch_vec =  this_coef_matrix * this_lr_patch;
        hr_patch_mat = reshape(hr_patch_vec, [hr_center_size, hr_center_size]);
        mean_mat = repmat(this_mean, [hr_center_size, hr_center_size]);
        hr_patch_mat = hr_patch_mat + mean_mat;
    end
    % ◊È≥…HR
    hr_img_y(hr_start_h : hr_start_h+hr_center_size-1, hr_start_w : hr_start_w+hr_center_size-1) = hr_img_y(hr_start_h : hr_start_h+hr_center_size-1, hr_start_w : hr_start_w+hr_center_size-1) + hr_patch_mat;
    value_count(hr_start_h : hr_start_h+hr_center_size-1, hr_start_w : hr_start_w+hr_center_size-1) = value_count(hr_start_h : hr_start_h+hr_center_size-1, hr_start_w : hr_start_w+hr_center_size-1) + one_mat;
    
    hr_start_w = hr_start_w + 3;
    if (hr_start_w > hr_width - hr_center_size + 1)
        hr_start_w = 1;
        hr_start_h = hr_start_h + 3;
    end
end

hr_img_y = hr_img_y ./ value_count;

hr_img = zeros(hr_height, hr_width, depth);
hr_img(:, :, 1) = hr_img_y;

if depth == 3
%     hr_img_uv = imresize(lr_img_uv, scale_f, 'bicubic');
%     hr_img(:, :, 2:3) = hr_img_uv;
    hr_img_u = bicubic(lr_img_uv(:,:,1), hr_height, hr_width);
    hr_img_v = bicubic(lr_img_uv(:,:,2), hr_height, hr_width);
    hr_img(:, :, 2) = hr_img_u;
    hr_img(:, :, 3) = hr_img_v;
end

hr_img = uint8(round(hr_img));

if depth == 3
    hr_img = ycbcr2rgb(hr_img);
end
    