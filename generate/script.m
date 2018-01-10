% CSL-603 course project.
% Submitted by - Manas Gupta(2015csb1018) and Sarthak Gupta(2015csb1029)
%% Data generation
% The dataGenerate() function will generate a data set with two features
% and two classes.
[x1, x2, y1, y2,overlap] = dataGenerate();
X = [x1 x2]; % We created the data set with two features.
Y = [y1; y2]; % This is the class label (+1 or -1)
C = 1;
sigma = 1;
epsilon = 1e-4; % Tolerance.
noChangeIter = 10; % Number of times the SMO must iterate if the alphas do not change.
rows = size(X, 1); % Number of data points.
alpha = zeros(rows, 1); % Initializing the lagrange multipliers.
% Taking the variables as the procedure given in the Platt paper for SMO.
E = zeros(rows, 1); % To store the value of SVM on every point.
b = 0; % To store the bias.
eta = 0;
L = 0;
H = 0;
% Evaluating the kernel matrix.
K = gaussian(X, sigma);
disp('Training on the dataset.');
iter = 0; % Initializing the iterator.
while (iter < noChangeIter)     
   changeAlpha = 0;
    for i = 1 : rows
        E(i) = b + sum (alpha .* Y .* K(:, i)) - Y(i);
        if ((Y(i)*E(i) < -epsilon && alpha(i) < C) || (Y(i)*E(i) > epsilon && alpha(i) > 0))
            j = ceil(rows * rand());
            if(j == i) % If j == i keep generating until j != i
                while (j == i)
                    j = ceil(rows * rand());
                end
            end
            E(j) = b + sum (alpha .* Y .* K(:,j)) - Y(j);

            % Save old alphas
            oldAlpha1 = alpha(i);
            oldAlpha2 = alpha(j);
            
            % Update the values of L and H.
            if (Y(i) == Y(j)),
                L = max(0, alpha(j) + alpha(i) - C);
                H = min(C, alpha(j) + alpha(i));
            else
                L = max(0, alpha(j) - alpha(i));
                H = min(C, C + alpha(j) - alpha(i));
            end       
            if (L == H) % Go to the next data point. 
                continue;
            end
            % Calculate eta from the given equation.
            eta = 2 * K(i,j) - K(i,i) - K(j,j);
            if (eta >= 0) % If eta is > 0 continue to the next iteration.
                continue;
            end
            % Update the alpha values.
            alpha(j) = alpha(j) - (Y(j) * (E(i) - E(j))) / eta;
            alpha(j) = min (H, alpha(j));
            alpha(j) = max (L, alpha(j));
            % Check if change in alpha is significant
            if (abs(alpha(j) - oldAlpha2) < epsilon)
                alpha(j) = oldAlpha2;
                continue;
            end
            % Update the value of alpha
            alpha(i) = alpha(i) + Y(i)*Y(j)*(oldAlpha2 - alpha(j));   
            % Compute b1 and b2 using (17) and (18) respectively. 
            b1 = b - E(i) - Y(i) * (alpha(i) - oldAlpha1) *  K(i,j)' - Y(j) * (alpha(j) - oldAlpha2) *  K(i,j)';
            b2 = b - E(j) - Y(i) * (alpha(i) - oldAlpha1) *  K(i,j)' - Y(j) * (alpha(j) - oldAlpha2) *  K(j,j)';
            %Calculate the bias term according to the given conditions.
            if (0 < alpha(i) && alpha(i) < C)
                b = b1;
            elseif (0 < alpha(j) && alpha(j) < C)
                b = b2;
            else
                b = (b1+b2)/2;
            end
            changeAlpha = changeAlpha + 1;
        end        
    end
    if (changeAlpha ~= 0) % If there is change in alpha then iter = 0.
        iter = 0;
    else% Other wise increase iter.
        iter = iter + 1;
    end
end
disp('Done!');
greaterZeroIndex = (alpha > 0); % Getting indexes of alpha that are greater than zero.
% Saving the model.
trainedAlpha = alpha(greaterZeroIndex);
trainedX = X(greaterZeroIndex,:);
trainedY = Y(greaterZeroIndex);

Y(Y==0) = -1; % Making 0 labels as -1.
predY = predictY(trainedX,trainedY, trainedAlpha, X, sigma);
accuracy = 0;
for i = 1: size(predY, 1)
   if(predY(i, 1) == Y(i, 1))
      accuracy = accuracy + 1; 
   end
end
accuracy = accuracy / size(Y,1);
accuracy = accuracy * 100;
disp('The accuracy on the train data.');
disp(accuracy);

%Plotting the decision boundary.
x1plot = linspace(min(X(:,1)), max(X(:,1)), 100)';
x2plot = linspace(min(X(:,2)), max(X(:,2)), 100)';
[X1, X2] = meshgrid(x1plot, x2plot);
vals = zeros(size(X1));
for i = 1:size(X1, 2)
   this_X = [X1(:, i), X2(:, i)];
   vals(:, i) = predictY(trainedX,trainedY, trainedAlpha, this_X, sigma);
end
hold on
contour(X1, X2, vals, [1 1], 'g');
title(['plot showing decision boundary learned by svm with overlap ',num2str(overlap)]);
hold off;

