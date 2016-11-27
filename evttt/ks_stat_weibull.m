function [D] = ks_stat_weibull(x, parmhat)
% Compute Kolmogorv Smirnov statistic for testing wether x comes from
% distribution Exp(a)
a=parmhat(1);
b=parmhat(2);
%cdf_x = (0.5:length(x)-0.5)'/length(x);
cdf_x=ecdf(x);
cdf_a =wblcdf(x,a,b);
cdf_x=cdf_x(2:end);
D = cdf_a;
end