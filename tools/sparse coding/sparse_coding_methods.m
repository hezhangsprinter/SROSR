function [xp] = sparse_coding_methods(xInit, A, y, sc_algo)
    [m Nd]=size(A);
    
    if( strcmp(sc_algo, 'l1magic'))
        opts = spgSetParms('iterations',4000,'verbosity',0);
        epsilon = 0.001;
        %xp = l1qc_logbarrier(xInit, A, [], y, epsilon, 1e-3);
        %xp=l1eq_pd(xInit, A, [],y);
        xp= spg_bp(A,y,opts);
        %xp= spg_bp1(A,y,'iterations',1000,'verbosity',0);
        %xp = SolveBP(A, y,size(A,2));
        %xp = SolvePFP(A, y,size(A,2));
    elseif(strcmp(sc_algo, 'SparseLab'))
        maxIters=20;
        lambda = 0.05;
        xp = SolvePFP(A, y, Nd, maxIters, lambda, 1e-3);
    elseif(strcmp(sc_algo, 'fast_sc'))
        
    elseif(strcmp(sc_algo, 'SL0'))
        
    elseif(strcmp(sc_algo, 'YALL1'))
        
    else
       error('A sparse coding algorithm must be specified.');
    end
end