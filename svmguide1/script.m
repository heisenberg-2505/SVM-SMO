%%CSL-603 Project.
A = svm2mat('svmguide1.txt'); % Extracting the training data.
X = A(:, 2:end); % Getting the Training data.
Y = A(:, 1); % Getting the class label.
B = svm2mat('svmguide1.t'); % Extracting the testing data.
XTest = B(:,2:end); % Getting the testing data.
YTest = B(:,1);% Getting the class label.
YTest(YTest == 0) = -1; % Making 0 labels as -1.
Y(Y == 0) = -1; % Changing the label from 0 to -1 if present.
C = [0.1;0.25;1;5;10]; % Box Parameter.
sigma = [0.1;0.25;1;5;10]; % Used in Gaussian Kernel.
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
%u=size(sigma,1);
acc_test=zeros(size(sigma,1),1);
acc_train=zeros(size(sigma,1),1);
sg2 = 2;
% for sg2 = 1: size(sigma, 1)
K = gaussian(X, sigma(sg2));
disp('Training on the dataset.');
iter = 0; % Initializing the iterator.
%sg = 2;
for sg = 1: size(C, 1)
while (iter < noChangeIter)     
   changeAlpha = 0;
    for i = 1 : rows
        E(i) = b + sum (alpha .* Y .* K(:, i)) - Y(i);
        if ((Y(i)*E(i) < -epsilon && alpha(i) < C(sg)) || (Y(i)*E(i) > epsilon && alpha(i) > 0))
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
                L = max(0, alpha(j) + alpha(i) - C(sg));
                H = min(C(sg), alpha(j) + alpha(i));
            else
                L = max(0, alpha(j) - alpha(i));
                H = min(C(sg), C(sg) + alpha(j) - alpha(i));
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
            if (0 < alpha(i) && alpha(i) < C(sg))
                b = b1;
            elseif (0 < alpha(j) && alpha(j) < C(sg))
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
%% testing accuracy for training case
X = A(:,2:end);
Y = A(:,1);
Y(Y==0) = -1; % Making 0 labels as -1.
predY = predictY(trainedX,trainedY, trainedAlpha, X, sigma(sg2));
acc_train(sg) = 0;
for i = 1: size(predY, 1)
   if(predY(i, 1) == Y(i, 1))
      acc_train(sg) = acc_train(sg) + 1; 
   end
end
acc_train(sg) = acc_train(sg) / size(Y,1);
acc_train(sg) = acc_train(sg) * 100;
disp('The accuracy on the test data.');
disp(acc_train(sg));
%% Testing the svm
predictionY = predictY(trainedX,trainedY, trainedAlpha, XTest, sigma(sg2));
%% accuracy for test case
acc_test(sg) = 0;
for i = 1: size(predictionY, 1)
   if(predictionY(i, 1) == YTest(i, 1))
      acc_test(sg) = acc_test(sg) + 1; 
   end
end
acc_test(sg) = acc_test(sg) / size(YTest, 1);
acc_test(sg) = (acc_test(sg) * 100);
disp('The accuracy on the test data.');
disp(acc_test(sg));
end
figure,
plot(sigma,acc_train,'DisplayName','Train');
hold on;
plot(sigma,acc_test,'DisplayName','Test');
xlabel('sigma values->');
ylabel('acuuracy over test set');
title('plot of accuracy for test set v/s sigma values');
legend('show');
hold off;