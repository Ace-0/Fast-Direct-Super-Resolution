function [ rand_arr ] = getRandowArr( num_of_patch )
    seed = RandStream('mcg16807','Seed',0); 
    RandStream.setGlobalStream(seed) 
        
    rand_arr = rand(num_of_patch,1);
    rand_arr = ceil(rand_arr * 650);
    rand_arr = sort(rand_arr, 'ascend');
end

