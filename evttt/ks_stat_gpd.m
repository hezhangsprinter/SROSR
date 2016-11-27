function [D] = ks_stat_gpd(x, paramhat)
% Compute Kolmogorv Smirnov statistic for testing wether x comes from
% distribution Exp(a)
kHat      = paramhat(1);   % Tail index parameter
sigmaHat  = paramhat(2);   % Scale parameter
%cdf_x = (0.5:length(x)-0.5)'/length(x);
cdf_x=ecdf(x);
cdf_a=gpcdf(x,kHat,sigmaHat);
cdf_x=cdf_x(2:end);
%D = max(abs(cdf_x-cdf_a));
D=cdf_a;
end