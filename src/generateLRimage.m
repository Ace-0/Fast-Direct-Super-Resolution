function [ trim_img, lr_img ] = generateLRimage( img_y, sigma, scale_f )
    [height, width, ~] = size(img_y);
    % È¥µôÓàÊýµÄ±ß½Ç
    h_trim = height - mod(height, scale_f);
    w_trim = width - mod(width, scale_f);
    trim_img = img_y(1 : h_trim, 1 : w_trim);
    h_lr = h_trim / scale_f;
    w_lr = w_trim / scale_f;
    kernal = gaussionKernal(sigma);
    half_k_size = (size(kernal, 1)-1)/2;
    trim_img_ext = wextend('2d','symw', trim_img, half_k_size);  %5 pixels are extended in each side
    blur_img = conv2my(trim_img_ext, kernal);
    lr_img = double(bicubic(blur_img, h_lr, w_lr));
end

