%clear all
load('src_caltech_result_new3.mat')
addpath(genpath('/home/openset/Desktop/He_Zhang/src1/SRCEVT/Object/src_object'));

%load('src_result_3.mat')
%f_src=cell(1,test_class_out);
F_src_final=[];
predict_label=zeros(1,size(res_test,1));
for i=1:size(res_test,1)
    [min_re,ind]=min(res_test(i,:));
    if(rand_class(ind)==test_label(i))
        predict_label(i)=1;
    end
end
%num_right=40

     thereshold=0.09; % YOU HAVE TO specify it
     weights=0.3;  %You have to specify it yourself
%hopework_gpd=ks_stat_gpd1;%+weights*ks_stat_gpd_wrong;
hopework_gpd=ks_stat_gpd1+weights*ks_stat_gpd_wrong;

%accuracy=TP+TN/all
ratio=1;

true=hopework_gpd(1:num_right)<=thereshold;
true_positive=nnz(true==predict_label(1:num_right)');
%true_positive=nnz(hopework_weil1(1:num_right)<=thereshold);
true_negative=nnz(hopework_gpd(num_right+1:end)>thereshold)*ratio;
%The negative one that been regarded as positive
false_positive=nnz(hopework_gpd(num_right+1:end)<=thereshold)*ratio;

false_negative=num_right-true_positive;
%Calculate Accuracy
accuracy_our=(true_positive+true_negative)/(num_right+(size(test_sample,2)-num_right))

%Presion equals; ratio of correctly classified positive examples 
Precision=true_positive/(true_positive+false_positive);
%Recalll
Recall=true_positive/(true_positive+false_negative);

%Calculate F-measure
F_measure_our=2*Precision*Recall/(Precision+Recall)
openness=1-sqrt(2*num_class_train/(num_class_train+num_class_train+test_class_out))
%end




% 
% fid=fopen('result_src_Fmeasure_ca.txt','a');
% fprintf(fid,'%4f\t',F_src_final);
% fprintf(fid,'\n');
% fclose(fid)
% 
% 
% fid=fopen('result_src_Accuracy_ca.txt','a');
% fprintf(fid,'%4f\t',A_src);
% fprintf(fid,'\n');
% fclose(fid)
