function [efficient] = fitFunction_E(A, r, data, transport)
% AIM
% Non linear least-square fitting of the diffusion model by only having the
% efficient coefficient as a variable to estimate.
% 
% INPUTS
% A (double): diffuse Fresnel parameter for internal reflections in the
% material.
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).
% data (mat): vector of the reflectance profile for a specific colour
% channel and record.
% transport (double): transport coefficient in mm-1 given as a starting
% point.
% 
% OUTPUT
% efficient (double): estimate of the efficient coefficient in mm-1.

% Normalization of data
[r0, data] = getNormalizedRadius(r, data);

% Declaration of fitting configuration
fo = fitoptions('Method', 'NonlinearLeastSquares', ...
    'Lower', [0], 'Upper', [10], 'StartPoint', [3], ...
    'MaxIter', 1000);

% Fitting the model
ft = fittype( @(e, A, r) modelFunction_E(e,transport,A,r)./modelFunction_E(e,transport,A,r0), ...
    'problem', {'A'}, 'independent', {'r'}, 'options', fo);
f = fit(r, data, ft, 'problem', A);

% Result of fitting
efficient = f.e;

end