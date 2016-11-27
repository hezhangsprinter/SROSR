

clear all
close all
%% Add path
addpath(genpath('tools/'));
addpath(genpath('data/'));
addpath(genpath('evttt/'));

addpath(genpath('spgl1-1.9/'));
%addpath(genpath('/home/openset/Desktop/Phd/He_Zhang_SROSR'));
%addpath(genpath('/home/openset/Desktop/He_Zhang/src1/SRCEVT/Object_src_object_data'));
%Load the training samples and its correponding labels
load('spm_caltech256.mat')


%% Train
fea=double(pyramid);
gnd=label;
fea=normc(fea);
num_class_train=20;
rand_class=randperm(257);
train_sample=[];
train_label=[];
test_sample=[];
test_label=[];

%Getting training and testing data for the close-set class
num_all_class=70;
for i=1:num_class_train
    p=fea(:,gnd==rand_class(i));
    p_size=size(p,2);
    p=p(:,randperm(p_size));
    p=p(:,1:num_all_class);
    train_size=ceil(50); %number of Train samples for each class
    test_size=num_all_class-train_size;
    train_sample=[train_sample p(:,1:train_size)];
    train_label=[train_label rand_class(i).*ones(1,train_size)];
    test_sample=[test_sample p(:,train_size+1:num_all_class)];
    test_label=[test_label rand_class(i).*ones(1,test_size)];
end
%Proceed SRC methods
train_src_separate;
