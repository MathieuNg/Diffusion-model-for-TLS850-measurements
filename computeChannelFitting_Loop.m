function [transport, efficient] = computeChannelFitting_Loop(A, r, sep, data, eff0, trp0)
% AIM
% Computes the inversion method to reach convergence on the final estimates
% of the optical properties. It requires values from the initialization
% part.
% 
% INPUTS
% A (double): diffuse Fresnel parameter for internal reflections in the
% material.
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).
% sep (int): integer to separate the reflectance data.
% data (mat): vector of the reflectance profile for a specific colour
% channel and record.
% eff0 (double): previous iteration of efficient coefficient in mm-1.
% trp0 (double): previous iteration of transport coefficient in mm-1.
% 
% OUTPUTS
% transport (double): estimate of transport coefficient in mm-1.
% efficient (double): estimate of efficient coefficient in mm-1.

% Proceeding to the separation of radial distances and reflectance profiles
% data.
[r1, r2] = getArraySeparated(r, sep);
[data1, data2] = getArraySeparated(data, sep);

% Computing new estimates of optical coefficients with previous iterated
% values.
transport = fitFunction_T(A, r1, data1, eff0);
efficient = fitFunction_E(A, r2, data2, trp0);

end
