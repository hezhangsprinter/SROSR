function [X, accuracy, res_mat] = sc_main(Y, A, sc_algo, trainLabel, testLabel, numClass, displayProgressFlag,rand_class)

[m Nt]= size(Y);
[m Nd]= size(A);
res_mat=[];
X = zeros(Nd, Nt);

% Compute the sparse representation X

Ainv = pinv(A);
sumTime=0;
correctSample=0;
for i = 1: Nt
    % Inital guess
    xInit = Ainv * Y(:,i);
      
    % sparse coding: solve a linear system
    tic
    xp = sparse_coding_methods(xInit, A, Y(:,i), sc_algo);
    t = toc;
    sumTime = sumTime+t;
  
    X(:, i) = xp;
    
    % Predict label of the test sample
    residuals = zeros(1,numClass);
    for iClass = 1: numClass
        xpClass = xp;
        xpClass(trainLabel~= rand_class(iClass)) = 0;
        residuals(iClass) = norm(Y(:,i) - A*xpClass);
    end
    res_mat(i,:)=residuals;
    [val, ind] = min(residuals);
    if(rand_class(ind)==testLabel(i))
        correctSample = correctSample+1;
    end
    displayProgressFlag=1;
    if(displayProgressFlag)
        avgTime = sumTime/i;
        accuracy = correctSample / i;
        fprintf('Accuracy = %f %% (%d out of %d), speed = %f s\n', accuracy*100, correctSample, i, avgTime);
    end
end
accuracy = correctSample/Nt;
avgTime=sumTime/Nt;

end