% CSL-603 course project.
% Submitted by - Manas Gupta(2015csb1018) and Sarthak Gupta(2015csb1029)
%% Data generation
% The dataGenerate() function will generate a data set with two features
% and two classes.
[x1, x2, y1, y2] = dataGenerate();
X = [x1 x2]; % We created the data set with two features.
Y = [y1; y2]; % This is the class label (+1 or -1)
%disp(size(X));
%disp(size(Y));

%% Using Polynomial Kernel
power = 2; % Change here to change the power of the kernel.
C = 3; % Penalty parameter.
kernelMatrix = polynomialKernel(X, power);
% m = size(X, 1);
% p = zeros(m, 1);
% pred = zeros(m, 1);
% model = svmTrain(X, Y, C, kernelMatrix);
% for i = 1 : m
%     prediction = 0;
%     for j = 1: size(model.X, 1)
%         prediction = prediction + ...
%                 model.alphas(j) * model.y(j) * ...
%                 gaussianKernel(X(i,:)', model.X(j,:)');
%     end
%     p(i) = prediction(i) + model.b;
% end
% pred(p >= 0) =  1;
% pred(p <  0) =  -1;
% accuracy = 0;
% %% Using Gaussian Kernel
