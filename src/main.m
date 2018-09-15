clear;
% getAllPatches
% trainClusters;
% trainCoefMatrix;
clear;

% 生成超分辨图片
hr_file_path =  './Set14/';
lr_file_path = './LR/';
sr_file_path = './SR/';
lr_img_list = dir(strcat(lr_file_path,'*.bmp'));
hr_img_list = dir(strcat(hr_file_path,'*.bmp'));
img_num = length(lr_img_list);
if img_num > 0
    for k = 1:img_num
        img_name = lr_img_list(k).name;
        fprintf('processing %s ... %d/%d\n', img_name, k, img_num);
        lr_img = imread(strcat(lr_file_path, img_name));
        SRthisImage;
        imwrite(hr_img, strcat(sr_file_path, 'sr-', img_name));
    end
end

% 计算PSNR和SSIM并保存
record = fopen('./record/super.txt','wt');
mPSNR = 0;
mSSIM = 0;
if img_num > 0
    for k = 1:img_num
        img_name = hr_img_list(k).name;
        img_hr = imread(strcat(hr_file_path, img_name));
        img_sr = imread(strcat(sr_file_path, 'sr-lr-', img_name));
        common_h = min(size(img_hr, 1), size(img_sr, 1));
        common_w = min(size(img_hr, 2), size(img_sr, 2));
        img_sr = img_sr(1:common_h, 1:common_w, :);
        img_hr = img_hr(1:common_h, 1:common_w, :);
        fprintf('calculating %s ... %d/%d\n', img_name, k, img_num);
        fprintf(record, '%s:\n', img_name);
        this_psnr = PSNR(img_hr, img_sr);
        this_ssim = SSIM(img_hr, img_sr);
        fprintf(record, '\t PSNR: %f\n', this_psnr);
        fprintf(record, '\t SSIM: %f\n', this_ssim);
        mPSNR = mPSNR + this_psnr;
        mSSIM = mSSIM + this_ssim;
    end
end
mPSNR = mPSNR / img_num;
mSSIM = mSSIM / img_num;
fprintf(record, 'average:\n');
fprintf(record, '\t PSNR: %f\n', mPSNR);
fprintf(record, '\t SSIM: %f\n', mSSIM);
fclose(record);
