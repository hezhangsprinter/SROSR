function [D] = ks_stat_weibull1(x, parmhat)
% Compute Kolmogorv Smirnov statistic for testing wether x comes from
% distribution Exp(a)
a=parmhat(1);
b=parmhat(2);
%cdf_x = (0.5:length(x)-0.5)'/length(x);
cdf_x1=ecdf(x);
cdf_a1 =wblcdf(x,a,b,'upper');
%D = max(abs(cdf_x1-cdf_a1));
D = 1-cdf_a1;
end