function [ cluster_indexes ] = getClusterIndex( lr_patches )
    load('data/clus_mat', 'clus_mat');
    num_of_patch = size(lr_patches, 2);
    num_of_clusters = size(clus_mat, 1);
    cluster_indexes = zeros(1, num_of_patch);
    for k = 1 : num_of_patch
        this_patch = lr_patches(:, k)';
        this_patch_rep = repmat(this_patch, [num_of_clusters, 1]);
        diff_square_mat = ((clus_mat - this_patch_rep).^2);  % 512*45
        diff_square_sum_vec = sum(diff_square_mat, 2);  % 1 * 512
        [~, this_cluster_index] = min(diff_square_sum_vec);
        cluster_indexes(1, k) = this_cluster_index;
    end
end

