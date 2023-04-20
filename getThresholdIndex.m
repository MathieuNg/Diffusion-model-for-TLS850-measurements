function [index] = getThresholdIndex(r, data)
% AIM
% Finds the distance for which the reflectance profile can be divided in
% two parts, one to estimate the efficient coefficient and the other for
% the transport coefficient. It follows the method described by Farrell et
% al., “The use of a neural network to determine tissue optical properties
% from spatially resolved diffuse reflectance measurements,” 
% Phys. Med. & Biol. 37, 2281 (1992).
% 
% INPUTS
% r (mat): vector of the radial distance.
% data (mat): vector containing the reflectance data profile of the
% corresponding channel and record.
% 
% OUTPUT
% index (int): integer number to be used as the position to separate the
% reflectance profile vector.

% Smoothing data with moving average filter
dataS = smooth(r.^2.*data./max(data));

% Gradient of the smoothed data. We search for changes in the gradient.
grad = gradient(dataS);

numChannel = size(dataS, 1);
span = 10;

% We put a condition since there could be many changes in the gradient due
% to remaining noise unfiltered. It requires at least 6 negative gradients
% on a span of 10 values to consider the index value.
for i = 1:numChannel
    if grad(i) < 0
        gradSpan = grad(i:i+span);
        cond = find(gradSpan < 0);
        if size(cond,1) >= 6
            index = i;
            break
        end
    end
end

end