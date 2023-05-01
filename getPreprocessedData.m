function [newData, newDistance] = getPreprocessedData(data, distance)
% AIM
% Preprocessing of the data. The reflectance profile cannot be negative so
% it removes potential negative values by setting them at 0. ALso, to avoid
% noise from the detector in the first arrays, it is removing values before
% the peak of the maximum. Most of the time, it is cutting the first two
% arrays of the NMOS sensor.

% INPUTS
% data (mat): vector of the data and selected record to preprocess.
% distance (mat): vector of the radial distance corresponding to the data.
% Since data and distance must have the same dimension, it needs to be
% adapted if changes occur.

% OUTPUTS
% newData (mat): vector of the new data to be used for inversion.
% newDistance (mat): vector of the new radial distance.

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



% Setting negative values to zero
data(data < 0) = 0;

% Cutting values before maximum
[M, I] = max(data);
newData = data(I:end);
newDistance = distance(I:end);

end