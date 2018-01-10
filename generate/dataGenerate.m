function [x1, x2, y1, y2, overlap] = dataGenerate()
    % Generating non linear separable data 
    % The data is circular where the inner points have '+' label.
    % The outer circle has '-' label.
    % The data has no overlap.
    n = 1500; % The number of data points for each class.
    inRadius = 2.0000;
    outLowRadius = 1.9999;
    outUpRadius = 7.0000;
    overlap = 1;
    
    % Generating the inner circle (+ label)
    temp = 2 * pi * rand(n, 1);
    rTemp = (inRadius + overlap) * sqrt(rand(n, 1));
    x1Temp = rTemp .* cos(temp);
    x2Temp = rTemp .* sin(temp);
    y1Temp = ones(n, 1);
    y1Temp = -y1Temp;
    
    % Generating the outer circle (- label)
    temp = 2 * pi * rand(n, 1);
    rTemp = (outUpRadius - outLowRadius) * sqrt(rand(n, 1)) + outLowRadius;
    x3Temp = rTemp .* cos(temp);
    x4Temp = rTemp .* sin(temp);
    y2Temp = ones(n, 1);
    
    % Plotting the data.
    plot(x1Temp, x2Temp, 'ko', x3Temp, x4Temp, 'k+', 'MarkerFaceColor', 'y');
    x1 = [x1Temp; x3Temp];
    x2 = [x2Temp; x4Temp];
    y1 = y1Temp;
    y2 = y2Temp;
end