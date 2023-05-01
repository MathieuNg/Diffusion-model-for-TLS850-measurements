function [transport] = fitFunction_T(A, r, data, efficient)
% AIM
% Non linear least-square fitting of the diffusion model by only having the
% transport coefficient as a variable to estimate.
 
% INPUTS
% A (double): diffuse Fresnel parameter for internal reflections in the
% material.
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).
% data (mat): vector of the reflectance profile for a specific colour
% channel and record.
% efficient (double): efficient coefficient in mm-1 given as a starting
% point.
 
% OUTPUT
% transport (double): estimate of the transport coefficient in mm-1.

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



% Normalization of data
[r0, data] = getNormalizedRadius(r, data);

% Declaration of fitting configuration
fo = fitoptions('Method', 'NonlinearLeastSquares', ...
    'Lower', [0], 'Upper', [10], 'StartPoint', [3], ...
    'MaxIter', 1000);

% Fitting the model
ft = fittype( @(t, A, r) modelFunction_T(t,efficient,A,r)./modelFunction_T(t,efficient,A,r0), ...
    'problem', {'A'}, 'independent', {'r'}, 'options', fo);
f = fit(r, data, ft, 'problem', A);

% Result of fitting
transport = f.t;

end