function [ output_img ] = conv2my( input_img, filter )
    output_img = zeros(size(input_img));
    half = floor(size(filter, 1) / 2);
    for i = half + 1 : size(input_img, 1) - half
        for j = half + 1 : size(input_img, 2) - half
            patch = input_img(i - half : i + half, j - half : j + half) .* filter;
            output_img(i, j) = sum(patch(:));
        end
    end
    output_img = output_img(half + 1 : size(input_img, 1) - half, half + 1 : size(input_img, 2) - half);
    output_img = round(output_img);
end

