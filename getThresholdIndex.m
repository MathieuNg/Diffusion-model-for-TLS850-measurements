function [index] = getThresholdIndex(r, data)
% AIM
% Finds the distance for which the reflectance profile can be divided in
% two parts, one to estimate the efficient coefficient and the other for
% the transport coefficient. It follows the method described by Farrell et
% al., “The use of a neural network to determine tissue optical properties
% from spatially resolved diffuse reflectance measurements,” 
% Phys. Med. & Biol. 37, 2281 (1992).

% INPUTS
% r (mat): vector of the radial distance.
% data (mat): vector containing the reflectance data profile of the
% corresponding channel and record.

% OUTPUT
% index (int): integer number to be used as the position to separate the
% reflectance profile vector.

% Copyright (C) 2023 - Mathieu Nguyen

% This program is free software: you can redistribute it and/or modify 
% it under the terms of the GNU General Public License as published by 
% the Free Software Foundation, either version 3 of the License, or 
% (at your option) any later version. 

% This program is distributed in the hope that it will be useful, 
% but WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
% GNU General Public License for more details. 

% You should have received a copy of the GNU General Public License 
% along with this program.  If not, see <http://www.gnu.org/licenses/>.



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