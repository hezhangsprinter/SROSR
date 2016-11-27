clear all
close all

%% Add path
addpath(genpath('tools/'));
addpath(genpath('spgl1-1.9/'));
addpath(genpath('evttt/'));

%load the trainng information
load('src_caltech_20_new2.mat');


%Initialization
pppp=pppp_src;
tail_size=0.25; %You have to specify the tail size 
paramGPD_right=[];
parWEIBULL_right=[];

%Get the GPD for the right class reconstruction error

for i=1:num_class_train;
    %Select all the reconstruction error that belongs to the class j 
    score_cj = pppp{1,i}(:,i);
    %recons_error_cj=aaaa(:,1);
    %Make it inverse to model the tail(score don't need to)
    score_cj=-score_cj;
    
    %Find the tail of the score
    sort_score=sort(score_cj);
    lower_th=sort_score(ceil(length(sort_score)*tail_size)+1);

    %As we want to find the lowerwst score , and want to fit it into a
    %distribution. As we want to fit the upper tail, so we give a inverse on
    %each sample

    tail_sort_neg_scores=sort_score(1:ceil(length(score_cj)*tail_size));
    tail_count=ceil(length(score_cj)*tail_size);
    normtail_score=lower_th-tail_sort_neg_scores+10^-5;
    
    %Get the parameter for the GPD and or the correct reconstruction
    %error
    paramGPD_right(i,:) = gpfit(normtail_score);
    kHat      = paramGPD_right(1);   % Tail index parameter
    sigmaHat  = paramGPD_right(2);   % Scale parameter
end

%And get the GPD for the sum of non-matched reconstrcution error
for i=1:num_class_train
    %Select all the reconstruction error that not  belongs to the true class j 
    class_label=[1:num_class_train];
    rscore_cnotj1 = sum(pppp{1,i}(:,(class_label~=i)),2);
    %Find the lowest and fit the tai;
    %recons_error_cj=aaaa(:,1);
    
    %rscore_cnotj1=-rscore_cnotj1;

    %Find the tail of the score
    sort_score=sort(rscore_cnotj1);
    lower_th_wrong=sort_score(ceil(length(sort_score)*tail_size)+1);

    %As we want to find the lowerwst score , and want to fit it into a
    %distribution. As we want to fit the upper tail, so we give a inverse on
    %each sample

    tail_sort_neg_scores=sort_score(1:ceil(length(rscore_cnotj1)*tail_size));
    tail_count=ceil(length(rscore_cnotj1)*tail_size);
    normtail_score=lower_th_wrong-tail_sort_neg_scores+10^-5;
    
    %Get the parameter for the GPD and Weibull for the correct reconstruction
    %error
    paramGPD_wrong(i,:) = gpfit(normtail_score);
    kHat_wrong      = paramGPD_wrong(1);   % Tail index parameter
    sigmaHat_wrong  = paramGPD_wrong(2);   % Scale parameter
end

    


wwww=0;


%We will have different GPD for different distribution.For a
%new test sample, we will have reconstruction error, and model the least
%K(1/3 of the total number of class) classes reconstruction error and decide whether these fit the
%corresponding class to see whether it fit. It may reduce the
%mis-classification rate.


%Add out of class test_sample (open-set test) on to within class test sample
test_class_out=1;
for i=1:test_class_out
    rand_out_test=rand_class(num_class_train+1:end);
    rand_index=ceil((257-num_class_train)*rand(1));
    out_test_ci=fea(:,gnd==rand_out_test(rand_index));
    size_out_test=size(out_test_ci,2);
    out_test_ci=out_test_ci(:,randperm(size_out_test));
     out_test_ci= out_test_ci(:,1:20);
    %out_test_ci=out_test_ci(:,1:125);
    
    test_sample=[test_sample out_test_ci];
    rand_out_label=rand_out_test(rand_index).*ones(1,size(out_test_ci,2));
    test_label=[test_label rand_out_label];    
end




%Testing 
 displayProgressFlag=1;
[X_test, accuracy_test,res_test] = sc_main(test_sample(:,1:40), train_sample, 'l1magic', train_label, test_label(:,1:40), num_class_train, displayProgressFlag,rand_class);



k=num_class_train;
for j=1:size(X_test,2)
    xp=X_test(:, j);
     x_norm1(j)=norm(xp,1);
    for iclass = 1: num_class_train
        xp=X_test(:, j);     
        xpClass = xp;
        xpClass(train_label~= rand_class(iclass)) = 0;
        sigma(iclass)=norm(xpClass,1);
    end
    sci(j)=(k*max(sigma)/ x_norm1(j)-1)/(k-1);
end
%Put test sample as input the have the coefficent for the test sample, then
%we are get the reconstruction error for each class. Then we model the
%lowerst 1/3 reconstruction error to their corresponding class to see
%whether it fits the distribution. If all not, regard as open sample. 

test_number=size(test_sample,2);
for i=1:test_number
    residue_si=res_test(i,:);
    [val, ind] = min(residue_si);
    residue_wrong=sum(residue_si(:,class_label~=ind));
    val=-val; 
    %residue_wrong=-residue_wrong;
    ks_stat_gpd1(i) = ks_stat_gpd(lower_th-val, paramGPD_right(ind,:)); 
    ks_stat_gpd_wrong(i) = ks_stat_gpd(lower_th_wrong-residue_wrong, paramGPD_wrong(ind,:));     
end

ks_stat_gpd1=ks_stat_gpd1';
ks_stat_gpd_wrong=ks_stat_gpd_wrong';


num_right=0;
for i=1:num_class_train
    num_right=num_right+nnz(test_label==rand_class(i));
end


save('/home/openset/Desktop/He_Zhang/src1/SRCEVT/Object/src_object/src_caltech_result_new3.mat')