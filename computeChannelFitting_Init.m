function [transport, efficient] = computeChannelFitting_Init(A, r, sep, data)
% AIM
% Computes the inversion method for the Part 1 Initialization. The
% computation is done for a specific channel and record.

% INPUTS
% A (double): diffuse Fresnel parameter for internal reflections in the
% material.
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).
% sep (int): integer to separate the reflectance data.
% data (mat): vector of the reflectance profile for a specific colour
% channel and record.

% OUTPUTS
% transport (mat): transport coefficients estimated on the first part of
% the reflectance curve.
% efficient (mat): efficient coefficients estimated on the second part of
% the reflectance curve.

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



% Separation of vector for distance and reflectance data
[r1, r2] = getArraySeparated(r, sep);
[data1, data2] = getArraySeparated(data, sep);

% Both estimation are assumed to be independent from each other, which
% explains the use of assigned values to 1 for efficient and transport
% coefficients.

% Initial estimation of the transport coefficient assuming a value for
% efficient coefficient in this part of the curve.
sigEff_0 = 1;
transport = fitFunction_T(A, r1, data1, sigEff_0);

% Initial estimation of the efficient coefficient assuming a value for
% transport coefficient in this part of the curve.
sigT_0 = 1;
efficient = fitFunction_E(A, r2, data2, sigT_0);

end