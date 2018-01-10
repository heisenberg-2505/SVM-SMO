% This function implements the gaussian kernel which is used in SVM.
function kernelMatrix = gaussian(X, sigma)
    % The generated kernel matrix will be a square matrix of the size of
    % the number of data points.
    rows = size(X, 1); % Getting the dimesion of the kernel matrix.
    kernelMatrix = zeros(rows, rows); % Initializing the kernel matrix.
    for i = 1 : rows
        for j = 1 : rows
            kernelMatrix(i, j) = exp(-(norm(X(i, :) - X(j, :))/(2*sigma*sigma)));
        end
    end
end