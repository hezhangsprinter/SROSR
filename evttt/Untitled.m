
clear all
close all
whichSubset = 2;    % 0-clear, 1-switch, 2-all
load('baseline_wacv.mat');
switch whichSubset
    case 0
        data = load('scores_cnn_clear.mat');
        wacv_pfa = wacv_clear(:,1);
        wacv_pd = wacv_clear(:,2);
        nameWhich = ' (clear ties)';
    case 1
        data = load('scores_cnn_switch.mat');
        wacv_pfa = wacv_switch(:,1);
        wacv_pd = wacv_switch(:,2);
        nameWhich = ' (clear + sw)';
    case 2
        data = load('scores_cnn_all.mat');
        wacv_pfa = wacv_all(:,1);
        wacv_pd = wacv_all(:,2);
        nameWhich = ' (all ties)';
end
%Initialization
tail_size=0.05;
prior_size = 1000;

%Randomly choose data points through the data
score1=0;
label1=0;
%Choose the fisrt 43 miles as training samples
seltrain=randperm(85);
trainnumbers=ceil(85*rand(1));

for i=1:trainnumbers
    score1=[score1 data.scores{1,seltrain(i)}(:,1)'];
    label1=[label1 data.gt{1,seltrain(i)}(:,1)'];
end

% ii=ceil(85*rand(1));
% jj=ceil(85*rand(1));
% kk=ceil(85*rand(1));
% pp=ceil(85*rand(1));
% score1=[data.scores{1,ii}(:,1)' data.scores{1,jj}(:,1)' data.scores{1,kk}(:,1)' data.scores{1,pp}(:,1)']';
% label1=[data.gt{1,ii}(:,1)' data.gt{1,jj}(:,1)' data.gt{1,kk}(:,1)' data.gt{1,pp}(:,1)']';

[z,x]=size(label1);
i=0;
for m=1:z
    for n=1:x
        if(label1(m,n)==1)
            i=i+1;
            y(i,:)=[m,n];
        end
    end
end
%Select all the training samples that belongs to the H0 
neg_scores = score1(label1==0);
%Find the tail of the score
sort_neg_scores=sort(neg_scores);
lower_th=sort_neg_scores(ceil(length(sort_neg_scores)*tail_size)+1);
%As we want to find the lowerwst score , and want to fit it into a
%distribution. As we want to fit the upper tail, so we give a inverse on
%each sample
tail_sort_neg_scores=sort_neg_scores(1:ceil(length(neg_scores)*tail_size));

% prior_sum=sum(tail_sort_neg_scores);
% prior_n=numel(tail_sort_neg_scores);
% alpha0 = 1 + prior_size;
% beta0 = prior_size * prior_sum / prior_n;
% a_hat0=beta0/(alpha0-1);

p=sort(score1);
tail_count=ceil(length(neg_scores)*tail_size);
normtail_score=lower_th-tail_sort_neg_scores;
a_hat0= expfit(normtail_score);
paramEsts = gpfit(normtail_score);
kHat      = paramEsts(1);   % Tail index parameter
sigmaHat  = paramEsts(2);   % Scale parameter
parmhat = wblfit(normtail_score);

for start_idx = 1:250
            % Check whether the a new data sample fit the GPD
            % distribution, and retuen the cdf of this data sample
            trunc_scores =lower_th -p(start_idx:start_idx+tail_count-1);
            ks_stat_gpd1(start_idx) = ks_stat_gpd(lower_th-p(start_idx), paramEsts);
end

for start_idx = 1:250
            % Check whether the a new data sample fit the Weibull
            % distribution, and retuen the cdf of this data sample
            trunc_scores = lower_th-p(start_idx:start_idx+tail_count-1);
            ks_stat2_weibull(start_idx)= ks_stat_weibull1(lower_th-p(start_idx), parmhat);             
end

for start_idx = 1:250
            % Check whether the a new data sample fit the Exponential
            % distribution, and retuen the cdf of this data sample
            trunc_scores =lower_th -p(start_idx:start_idx+tail_count-1);
            ks_stat_exp1(start_idx) = ks_stat_exp(lower_th-p(start_idx), a_hat0);
end

%wblfit have to fit the positive data



outlier_gpd=zeros(size(y,1),2);
outlier_weibull=zeros(size(y,1),2);

for i=1:size(y,1)
    www=y(i,2);
    out_gpd=ks_stat_gpd(lower_th- score1(y(i,2)),paramEsts);
    outlier_gpd(i,:)=[out_gpd www];
    out_ex=ks_stat_weibull1(lower_th- score1(y(i,2)),parmhat);
    outlier_weibull(i,:)=[out_ex www];
end

outlier_sort_gpd=sort(outlier_gpd(:,1));
thresh_gpd=outlier_sort_gpd(ceil(size(y,1)*0.05));

outlier_sort_weibull=sort(outlier_weibull(:,1));
thresh_weibull=outlier_sort_weibull(ceil(size(y,1)*0.05));



test_samples=0;
test_labels=0;

seltrain=randperm(85);
trainnumbers=ceil(85*rand(1));



for i=trainnumbers+1:85
    test_samples=[test_samples data.scores{1,seltrain(i)}(:,1)'];
    test_labels=[test_labels data.gt{1,seltrain(i)}(:,1)'];
end

p=test_samples;
[z1,x1]=size(test_labels);
i=0;
for m=1:z1
    for n=1:x1
        if(test_labels(m,n)==1)
            i=i+1;
            ytest(i,:)=[m,n];
        end
    end
end


i=0;
outlier_index_weibull=0;
for start_idx = 1:length(test_samples)
            % Check whether the a new data sample fit the Weibull
            % distribution, and retuen the cdf of this data sample 
            ks_stat2_weibull_test(start_idx)= ks_stat_weibull1(lower_th-p(start_idx), parmhat);  
            if (ks_stat2_weibull_test(start_idx)>=thresh_weibull)
                i=i+1;
                outlier_index_weibull(i)=start_idx;
                
                
            end
end
i=0;
outlier_index_gpd=0;
for start_idx = 1:length(test_samples)
            % Check whether the a new data sample fit the GPD
            % distribution, and retuen the cdf of this data sample
            ks_stat_gpd1_test(start_idx) = ks_stat_gpd(lower_th-p(start_idx), paramEsts);
            if (ks_stat_gpd1_test(start_idx)>=thresh_gpd)
                i=i+1;
                outlier_index_gpd(i)=start_idx;
            end
end




outlier_gpd_test=zeros(size(ytest,1),2);
outlier_weibull_test=zeros(size(ytest,1),2);
 
for i=1:size(ytest,1)
    www=ytest(i,2);
    out_gpd_test=ks_stat_gpd(lower_th-test_samples(ytest(i,2)),paramEsts);
    outlier_gpd_test(i,:)=[out_gpd_test www];
    out_ex_test=ks_stat_weibull1(lower_th-test_samples(ytest(i,2)),parmhat);
    outlier_weibull_test(i,:)=[out_ex_test www];   
end


c=intersect(ytest(:,2),outlier_index_weibull');
false_negative=size(ytest,1)-size(c,1)
false_positive=size(outlier_index_weibull,2)-size(c,1)

ks_stat_gpd1_test_sorted=sort(ks_stat_gpd1_test,'descend');
ks_stat2_weibull_test_sorted=sort(ks_stat2_weibull_test,'descend');


% for start_idx = 1:250
%             % Check wether the samples start_idx:start_idx+tail_count-1
%             % fit the prior exponential CDF
%             %lower_th = sorted_neg_scores(start_idx+tail_count-1);
%             trunc_scores = lower_th-p(start_idx:start_idx+tail_count-1);
%             ks_stat3_weibull(start_idx)= ks_stat_weibull1(trunc_scores, parmhat);
% 
% end


% 
% for start_idx = 1:50
%             % Check wether the samples start_idx:start_idx+tail_count-1
%             % fit the prior exponential CDF
%             %lower_th = sorted_neg_scores(start_idx+tail_count-1);
% %           trunc_scores = lower_th-p(start_idx:start_idx+tail_count-1);
%             xxxx=lower_th-p(start_idx);
%             yyyy=lower_th-tail_sort_neg_scores;
%             ks_stat3(start_idx)= ks_stat_weibullchange(xxxx,yyyy,parmhat);
% end
