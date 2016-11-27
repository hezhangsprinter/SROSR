function [D] = ks_stat_weibullchange(x,trainsample,parmhat)
% Compute Kolmogorv Smirnov statistic for testing wether x comes from
% distribution Exp(a)


a=parmhat(1);
b=parmhat(2);
y=trainsample';
p=[y(2:end) x];
cdf_x=ecdf(p);
cdf_a =wblcdf(p,a,b);
cdf_a=cdf_a';
cdf_x=cdf_x(2:end);
D = max(abs(cdf_x-cdf_a));

end