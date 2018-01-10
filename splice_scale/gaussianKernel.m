function kernel = gaussianKernel(X1, X2, sigma)
% This function computes the gaussian kernel of two column vectors.
kernel = exp(-sum((X1 - X2) .^ 2) / ( 2 * sigma * sigma));
end
