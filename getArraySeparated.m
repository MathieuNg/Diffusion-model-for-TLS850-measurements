function [data1, data2] = getArraySeparated(data, sep)
% AIM
% Separates the array into two parts following the separator parameter
% provided.
% 
% INPUTS
% data (mat): vector to be separated in two parts.
% sep (int): separator position to use to separate the data array.
% 
% OUTPUTS
% data1 (mat): vector containing values before and including the separator.
% data2 (mat): vector containing values after and excluding the separator.

data1 = data(1:sep);
data2 = data(sep+1:end);

end