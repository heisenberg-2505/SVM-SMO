function yPredicted = svmPredict(model, X, sigma)
    % This function predicts the accuracy of the classification after the model
    % is trained.
    rows = size(X, 1);% Get the number of data points to test.
    yPredicted = zeros(rows, 1);% Preallocate the size of the prediction matrix.
    % First get the Kernel Matrix.
    X1 = sum(X.^2, 2);
    X2 = sum(model.X.^2, 2)';
    K = bsxfun(@plus, X1, bsxfun(@plus, X2, - 2 * X * model.X'));
    K = gaussianKernel(1, 0, sigma) .^ K;
    K = bsxfun(@times, model.y', K);
    K = bsxfun(@times, model.alphas', K);
    p = sum(K, 2);
    yPredicted(p >= 0) =  1;
    yPredicted(p <  0) =  0;
end

