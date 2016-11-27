

load('yaleb3232')
addpath(genpath('SSC_ADMM/'));
Y=fea;
Y=normc(Y);
%Choose number of class for testing
num_class=2;
train_sample=[];
train_label=[];
test_sample=[];
test_label=[];

for i=1:num_class
    p=fea(:,(gnd==i));
    num_class=size(p,2);
    num_train_class=ceil(0.7*num_class);
    train_sample=[train_sample p(:,1:num_train_class)]; 
    train_label=[train_label i.*ones(1,num_train_class)];
    test_sample=[test_sample p(:,num_train_class+1:end)];
    test_label=[test_label i.*ones(1,num_class-num_train_class)];
end


%C2 = admmLasso_mat_func(Y,affine,alpha,thr,maxIter)
%Get residue for the class 1
aaa=0;
%Randomly get the residue for one class
for i=1:30
    
    
    C2 = admmLasso_mat_func(Y,false,200,1,1000);
    Yhat=Y*C2;
    R=Y-Yhat;

     for i=1:size(R,1)
         r(i)=norm(R(i,:));
     end
 
end
 