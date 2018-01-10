function yPredicted = predictY(trainedX, trainedY, trainedAlpha, X, sigma)
    % This function predicts the accuracy of the classification after the model
    % is trained.
    rows = size(X, 1);% Get the number of data points to test.
    yPredicted = zeros(rows, 1);% Preallocate the size of the prediction matrix.
    % First get the Kernel Matrix.
    X1 = sum(X.^2, 2);
    X2 = sum(trainedX.^2, 2)';
    K = bsxfun(@plus, X1, bsxfun(@plus, X2, - 2 * X * trainedX'));
    K = gaussianKernel(1, 0, sigma) .^ K;
    K = bsxfun(@times, trainedY', K);
    K = bsxfun(@times, trainedAlpha', K);
    p = sum(K, 2);
    % If p < 0 give label -1 otherwis give label +1
    yPredicted(p < 0) =  -1;
    yPredicted(p >=  0) =  1;
end

