clear;

num_of_clusters = 512;
% get training patches
load('data/patch_to_cluster', 'patch_to_cluster');

[clus_idx, clus_mat] = kmeans(patch_to_cluster, num_of_clusters, 'Display','iter', 'MaxIter', 200, 'emptyaction', 'drop');

save('data/clus_mat', 'clus_mat', '-v7.3');
save('data/clus_idx', 'clus_idx', '-v7.3');