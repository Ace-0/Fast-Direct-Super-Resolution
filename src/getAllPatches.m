clear;

train_file_path =  './Train/';
sigma = 1.2;
lr_p_size = 7;
lr_center_size = 3;
scale_f = 3;
num_of_patch_to_cluster = 700000;
num_of_hr_patch = 700000;
select_base = num_of_hr_patch / 10000;
lr_patch_pixels = lr_p_size^2 - 4;
hr_patch_pixels = (lr_center_size * scale_f)^2;

train_img_list = dir(strcat(train_file_path,'*.jpg'));
train_img_num = length(train_img_list);

num_of_patch = 0;
patch_to_cluster = zeros(num_of_patch_to_cluster, lr_patch_pixels);
all_hr_patches = zeros(num_of_hr_patch, hr_patch_pixels);

% get all patches
if train_img_num > 0
    for k = 1:train_img_num
        img_name = train_img_list(k).name;
        hr_img_rgb = imread(strcat(train_file_path, img_name));
        hr_img_yuv = rgb2ycbcr(hr_img_rgb);
        hr_img_yuv = double(hr_img_yuv);
        hr_img_y = hr_img_yuv(:, :, 1);
        fprintf('processing... %d/%d\n', k, train_img_num);
        disp(num_of_patch);
  
        [hr_patches, lr_patches] = getPatchFromHR(hr_img_y, sigma, scale_f, lr_p_size, lr_center_size);
        patch_each_img = size(hr_patches, 2);
       
        % 随机选取
        rand_arr = getRandowArr(patch_each_img);
        for index = 1:patch_each_img
            % 随机值小于select_base，则选取
            if rand_arr(index) <= select_base
                num_of_patch = num_of_patch + 1;
                if num_of_patch > num_of_patch_to_cluster
                    break;
                end
                patch_to_cluster(num_of_patch, :) = (lr_patches(:, index))';
                all_hr_patches(num_of_patch, :) = (hr_patches(:, index))';
            end
        end
        if num_of_patch > num_of_patch_to_cluster
            break;
        end
    end
end
save('data/patch_to_cluster' , 'patch_to_cluster' ,'-v7.3' );
save('data/all_hr_patches' , 'all_hr_patches' ,'-v7.3' );
