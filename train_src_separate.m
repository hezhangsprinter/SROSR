addpath(genpath('/home/labuser/Desktop/He_Zhang_SROSR/Untitled Folder'));

%Cross-Validation in training
loop_num=50;
train_cross_sample=[];
train_cross_label=[];
scr_error_train=[]
pppp_src=cell(1,num_class_train);

for j= 1:num_class_train
    scr_error_train=[];
    for i=1:loop_num
        
        %Get the class j train sample
        cross_train_cj=train_sample(:,(train_label==rand_class(j)));
        cross_label_ck=train_label(:,train_label==rand_class(j));
        num_train_cj=size(cross_train_cj,2);

        %Reorder the training class j
        p=randperm(num_train_cj);
        cross_train_cj=cross_train_cj(:,p);
        %Choose  80% as cross-training and the other 20% as testing
        cross_ratio=0.8;
        num_cross=ceil(cross_ratio*num_train_cj);
        
        train_label_cother1=train_label(train_label~=rand_class(j));
        train_sample_cother1=train_sample(:,(train_label~=rand_class(j)));
        train_sample_cother=[];
        train_label_cother=[];
        %train_label_other=unique()
        %Get the training sample other than class j 

        for jj=1:num_class_train-1
            cross_train_cj_other=train_sample_cother1(:,(train_label==train_label(40*(jj-1)+1)));
            cross_label_ck_other=train_label_cother1(:,train_label==train_label(40*(jj-1)+1));
            num_train_cj_other=size(cross_train_cj_other,2);

            %Reorder the training class j
            p=randperm(num_train_cj_other);
            cross_train_cj_other=cross_train_cj_other(:,p);
            %Choose  80% as cross-training and the other 20% as testing
            cross_ratio=0.8;
            num_cross_other=ceil(cross_ratio*num_train_cj);
            train_sample_cother=[train_sample_cother,cross_train_cj_other(:,1:40)];
            train_label_cother=[train_label_cother,cross_label_ck_other(:,1:40)];
        end
                
        train_sample_cross=[cross_train_cj(:,1:num_cross),train_sample_cother];
        train_label_cross=[cross_label_ck(:,1:num_cross),train_label_cother];
        test_sample_cross=cross_train_cj(:,num_cross+1:end);
        num_cross_test=num_train_cj-num_cross;
        test_label_cross=rand_class(j).*ones(1,num_cross_test);
        displayProgressFlag=1;
        %SRC algorithms
        [X_cross, accuracy_cross(j,i),res_mat_cross] = sc_main(test_sample_cross, train_sample_cross, 'l1magic', train_label_cross, test_label_cross, num_class_train, displayProgressFlag,rand_class);
        scr_error_train=[scr_error_train;res_mat_cross]; %save the reconstruction error
    end
    pppp_src{1,j}=scr_error_train;
    disp('done!')
end


save('src_caltech_20_new2.mat')