function [data1, data2] = getArraySeparated(data, sep)
% AIM
% Separates the array into two parts following the separator parameter
% provided.

% INPUTS
% data (mat): vector to be separated in two parts.
% sep (int): separator position to use to separate the data array.

% OUTPUTS
% data1 (mat): vector containing values before and including the separator.
% data2 (mat): vector containing values after and excluding the separator.

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



data1 = data(1:sep);
data2 = data(sep+1:end);

end