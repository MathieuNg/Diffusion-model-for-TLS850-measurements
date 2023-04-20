function [scattering, absorption] = getOpticalProperties(transport, efficient)
% AIM
% Returns the values of absorption and reduced scattering coefficients by
% using the estimates of transport and efficient coefficients.
% 
% INPUTS
% transport (double): transport coefficient given in mm-1.
% efficient (double): efficient coefficient given in mm-1.
% 
% OUTPUTS
% scattering (double): reduced scattering coefficient given in mm-1.
% absorption (double): absorption coefficient given in mm-1.

absorption = efficient.^2./(3*transport);
scattering = transport - absorption;

end