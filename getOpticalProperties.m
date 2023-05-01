function [scattering, absorption] = getOpticalProperties(transport, efficient)
% AIM
% Returns the values of absorption and reduced scattering coefficients by
% using the estimates of transport and efficient coefficients.

% INPUTS
% transport (double): transport coefficient given in mm-1.
% efficient (double): efficient coefficient given in mm-1.

% OUTPUTS
% scattering (double): reduced scattering coefficient given in mm-1.
% absorption (double): absorption coefficient given in mm-1.

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



absorption = efficient.^2./(3*transport);
scattering = transport - absorption;

end