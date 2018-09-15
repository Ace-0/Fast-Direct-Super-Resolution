clear;

load('data/patch_to_cluster', 'patch_to_cluster');
load('data/all_hr_patches', 'all_hr_patches');
load('data/clus_idx', 'clus_idx');
load('data/clus_mat', 'clus_mat');


num_of_clusters = 512;
lr_p_size = 7;
lr_center_size = 3;
scale_f = 3;
num_of_patch_to_cluster = 700000;
num_of_hr_patch = 700000;
lr_patch_pixels = lr_p_size^2 - 4;
hr_patch_pixels = (lr_center_size * scale_f)^2;

all_coef_matrix = zeros(hr_patch_pixels, lr_patch_pixels + 1, num_of_clusters);
cluster_patch_count = zeros(num_of_clusters, 1);

for k = 1 : num_of_clusters
    num_of_pair = 0;
    W = [];
    V = [];
    for i = 1 : num_of_patch_to_cluster
        if clus_idx(i) == k
            num_of_pair = num_of_pair + 1;
            V(:, num_of_pair) = patch_to_cluster(i, :)';
            W(:, num_of_pair) = all_hr_patches(i, :)';
        end
    end
    if num_of_pair >= 46
        % 满秩，可逆
        % 计算第k个聚类的系数矩阵C
        % C = W / V;
        one_vec = ones(1, num_of_pair);
        V = [V;one_vec];
        C = (W * V') / (V * V');
        all_coef_matrix(:, :, k) = C;
        clear C W V;
    end
    cluster_patch_count(k) = num_of_pair;
end

save('data/all_coef_matrix', 'all_coef_matrix', '-v7.3');
save('data/cluster_patch_count', 'cluster_patch_count', '-v7.3');
