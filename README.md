# SROSR
This is the implementation of 'Sparse Representation based Open-set Recognition' 

1. In 'train_together.m'.
Generate your training samples and testing samples,
Proceed training and save the training detail

2.  In 'objsect_src_evt.m'.
Generate the tail distribution (GPD) of matched and sum of non-mathced reconstruction errors using the 
In this code, we also do testing using SRC. The testing result will be saved.
The tail distribution of matched and sum of non-mathced will be saved.

3. In 'object_src_fmeas.m'  
Calculate the F-measure and Accuracy using 'object_src_fmeas.m'

4. Make sure to specify all the data-related parameter based on your data. (such as tail size, weights, thresholds)

** We also include one sample in the code. You can directly calculating the F-measure and Accuracy by running
'object_src_fmeas.m'

** All the code is writen in Ubuntu 14.04. 
