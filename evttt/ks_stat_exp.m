function [D] = ks_stat_exp(x, a)
% Compute Kolmogorv Smirnov statistic for testing wether x comes from
% distribution Exp(a)

cdf_x = (0.5:length(x)-0.5)'/length(x);
cdf_x=ecdf(x);
cdf_a = 1-exp(-x*a);
D = max(abs(cdf_x-cdf_a));

end