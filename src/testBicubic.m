hr_file_path =  './Set14/';
lr_file_path = './LR/';
bi_file_path = './BI/';
img_list = dir(strcat(hr_file_path,'*.bmp'));
img_num = length(img_list);
% bicubic生成图片
if img_num > 0
    for k = 1:img_num
        img_name = img_list(k).name;
        fprintf('processing %s ... %d/%d\n', img_name, k, img_num);
        img_hr = imread(strcat(hr_file_path, img_name));
        [height, width, depth] = size(img_hr);
        img_lr = bicubic(img_hr, height / 3, width / 3);
        imwrite(img_lr, strcat(lr_file_path, 'lr-', img_name));
        img_bi = bicubic(img_lr, height, width);
        imwrite(img_bi, strcat(bi_file_path, 'bi-', img_name));
    end
end

% 计算PSNR和SSIM并保存
record = fopen('./record/bicubic.txt','wt');
mPSNR = 0;
mSSIM = 0;
if img_num > 0
    for k = 1:img_num
        img_name = img_list(k).name;
        img_hr = imread(strcat(hr_file_path, img_name));
        img_bi = imread(strcat(bi_file_path, 'bi-', img_name));
        fprintf('calculating %s ... %d/%d\n', img_name, k, img_num);
        fprintf(record, '%s:\n', img_name);
        this_psnr = PSNR(img_hr, img_bi);
        this_ssim = SSIM(img_hr, img_bi);
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