function [ output_img ] = bicubic( input_img, height, width )
    input_img = double(input_img);
	[src_height, src_width, depth] = size(input_img);
	output_img = zeros(round(height), round(width), depth);

	ratio_h = height / src_height;
	ratio_w = width / src_width;
    pixel = zeros(1, 1, depth);
    [top, down, left, right, corner] = get_padding(input_img, src_height, src_width, depth);

    for i = 1 : round(height)
        for j = 1 : round(width)
			x = i / ratio_h;
			y = j / ratio_w;
			x_int = floor(x);
			y_int = floor(y);
            for x_diff = -1 : 2
                for y_diff = -1 : 2
					neib_x = x_int + x_diff;
					neib_y = y_int + y_diff;                    
                    if neib_x < 1
                        if neib_y < 1
                            pixel(1,1,:) = corner(1, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                        elseif neib_y > src_width
                            pixel(1,1,:) = corner(3, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                        else
                            pixel(1,1,:) = top(neib_y, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                        end
                    elseif neib_x > src_height
                        if neib_y < 1
                            pixel(1,1,:) = corner(2, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                        elseif neib_y > src_width
                            pixel(1,1,:) = corner(4, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                        else
                            pixel(1,1,:) = down(neib_y, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                        end
                    elseif neib_y < 1
                        pixel(1,1,:) = left(neib_x, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                    elseif neib_y > src_width
                        pixel(1,1,:) = right(neib_x, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                    else
                        pixel(1,1,:) = input_img(neib_x, neib_y, :) * get_weight(x - neib_x) * get_weight(y - neib_y);
                    end
                    output_img(i, j, :) = output_img(i, j, :) + pixel;
                end
            end
        end
    end
	output_img = uint8(round(output_img));
end

function [ weight ] = get_weight( distance )
    dis = double(abs(distance));
    if 0 <= dis && dis <= 1
        weight = 1.5 * dis^3 - 2.5 * dis^2 + 1;
    elseif 1 < dis && dis <= 2
        weight = 0 - 0.5 * dis^3 + 2.5 * dis^2 - 4 * dis + 2;
    else
        weight = double(0);
    end
end

function [ top, down, left, right, corner ] = get_padding(in_img, height, width, depth)
    top = zeros(width, depth);
    down = zeros(width, depth);
    left = zeros(height, depth);
    right = zeros(height, depth);

    for k = 1 : width
        top(k, :) = 3 * in_img(1, k, :) - 3 * in_img(2, k, :) + in_img(3, k, :);
        down(k, :) = 3 * in_img(height, k, :) - 3 * in_img(height - 1, k, :) + in_img(height - 2, k, :);
    end
    for k = 1 : height
        left(k, :) = 3 * in_img(k, 1, :) - 3 * in_img(k, 2, :) + in_img(k, 3, :);
        right(k, :) = 3 * in_img(k, width, :) - 3 * in_img(k, width - 1, :) + in_img(k, width - 2, :);
    end
    corner = zeros(4, depth);
    % top_left, down_left, top_right, down_right
    corner(1, :) = 3 * left(1, :) - 3 * left(2, :) + left(3, :);
    corner(2, :) = 3 * left(height, :) - 3 * left(height - 1, :) + left(height - 2, :);
    corner(3, :) = 3 * right(1, :) - 3 * right(2, :) + right(3, :);
    corner(4, :) = 3 * right(height, :) - 3 * right(height - 1, :) + right(height - 2, :);
end
