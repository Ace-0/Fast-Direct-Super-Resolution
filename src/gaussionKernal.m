function [ kernal ] = gaussionKernal( sigma )
    kernalsize = ceil(sigma * 3) * 2 + 1;
    k = floor(kernalsize / 2);
    kernal = zeros(kernalsize, kernalsize);
    for i = 1 : kernalsize
        for j = 1 : kernalsize
            evalue = - (((i - k - 1)^2 + (j - k - 1)^2) / (2 * sigma^2));
            divalue = 2 * pi * sigma^2;
            kernal(i, j) = exp(evalue) / divalue;
        end
    end
end

