clear all
close all
load('yaleb3232');

Y=fea;
Y=normc(Y);
%Choose number of class for testing
numclass=2;
train_sample=[];
train_label=[];
test_sample=[];
test_label=[];

for i=1:numclass
    p=Y(:,(gnd==i));
    num_class_each(i)=size(p,2);
    num_train_class=ceil(0.7*num_class_each(i));
    train_sample=[train_sample p(:,1:num_train_class)]; 
    train_label=[train_label i.*ones(1,num_train_class)];
    test_sample=[test_sample p(:,num_train_class+1:end)];
    test_label=[test_label i.*ones(1,num_class_each(i)-num_train_class)];
end



num_test=size(test_sample,2);
B=train_sample;
for i=1:num_test
    test_single=test_sample(:,i);
    b=test_single;
    x(:,i)= spg_bp(B,b);
    for jj=1:numclass
        xpclass=x(:,i);
        xpclass(train_label~=jj)=0;
        %x_coe(:,jj)=x((train_label==jj),i);
       residuals(i,jj)= norm(b-B*xpclass);
                    
    end
    
end


sigma=0.001;
num_train_sample=size(train_sample,2);
ratio_train_residue=0.2;
loop_number=5000;



% for i=1:loop_number
%     %Get the class 1 train sample
%     cross_train_c1=train_sample(:,(train_label==1));
%     cross_label_c1=train_label(:,train_label==1);
%     num_train_c1=size(cross_train_c1,2);
%     
%     %Reorder the training class 1
%     p=randperm(num_train_c1);
%     cross_train_c1=cross_train_c1(:,p);
%     %Randomly choose as cross-test sample
%     p_rand=ceil(num_train_c1*rand(1));   
%     b=cross_train_c1(:,p_rand);
%     cross_train_c1(:,p_rand)=[];
%     
%     %Choose the other 80% as cross-training 
%     num_cross=ceil(0.8*num_train_c1);
%     train_sample_c2=train_sample(:,(train_label==2));
%     A=[cross_train_c1(:,1:num_cross) train_sample_c2];
%     Ae=eye(size(A,1));
%     B=[A Ae];
%     %B=A;
%     %tau=45;
%     %[x] = spg_lasso(A,b,tau);
%     %x(:,i)= spg_bp(B,b);
%     x(:,i)= spg_bpdn(B,b,sigma);
%     x1=zeros(1,size(x(:,i),1));
%     x1(1:num_cross)=x(1:num_cross,i);
%     x2=zeros(1,size(x(:,i),1));
%     x2(num_cross+1:end-size(A,1))=x(num_cross+1:end-size(A,1),i);
%     residue(i,:)=[norm(B*x1'-b) norm(B*x2'-b)];
%    
% end





 