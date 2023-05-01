function [r0, data] = getNormalizedRadius(r, data)
% AIM
% Computes the normalization of reflectance data profiles and return also
% the distance for which the maximum is located.

% INPUTS
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).
% data (mat): vector of the reflectance profile for a specific colour
% channel and record.

% OUTPUTS
% r0 (double): value of the radial distance from entry point in the
% material for which the reflectance signal is at maximum.
% data (mat): normalized reflectance profile.

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



data = data./max(data);

cond = find(data == 1);
r0 = r(cond(1));

end