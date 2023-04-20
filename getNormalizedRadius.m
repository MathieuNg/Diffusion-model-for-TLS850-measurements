function [r0, data] = getNormalizedRadius(r, data)
% AIM
% Computes the normalization of reflectance data profiles and return also
% the distance for which the maximum is located.
% 
% INPUTS
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).
% data (mat): vector of the reflectance profile for a specific colour
% channel and record.
% 
% OUTPUTS
% r0 (double): value of the radial distance from entry point in the
% material for which the reflectance signal is at maximum.
% data (mat): normalized reflectance profile.

data = data./max(data);

cond = find(data == 1);
r0 = r(cond(1));

end