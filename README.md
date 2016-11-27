# SROSR
This is the implementation of 'Sparse Representation based Open-set Recognition' T-PAMI
1. Generating your training samples and testing samples and  proceeding training in the meantime by using 'train_together.m'.
   Proceeding SRC and save the reconstruction error using ''

2.  Generate the tail distribution (GPD) of matched and sum of non-mathced reconstruction errors using the 
'objsect_src_evt.m'.
In this code, we also do testing using SRC. The testing result will be saved
The tail distribution of matched and sum of non-mathced will be saved.

3.  Calculating the F-measure and accuracy using 'object_src_fmeas.m'
4. Some parameter you have to specify based on your data. (such as tail size, weights, thresholds)

** We also include one sample in the code. You can directly calculating the F-measure and Accuracy by running
'object_src_fmeas.m'

** All the code is writen in Ubuntu 14.04. If you are using windows and other systems, make sure you change the '/' to '\'.
