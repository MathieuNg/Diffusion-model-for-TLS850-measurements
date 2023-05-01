function f = modelFunction_T(sigT, sigEff, A, r)
% AIM
% Returns the diffusion model following the work of Farrell et al., 
% “A diffusion theory model of spatially resolved, steady-state diffuse
% reflectance for the noninvasive determination of tissue optical 
% properties in vivo,” Med. Phys. 19, 879–888 (1992).
% This equation is parameterized with the transport (sigT) and efficient
% (sigEff) coefficients to be adapted to our inversion method.
% Use this function when sigT is the parameter to estimate while sigEff is
% known.

% INPUTS
% sigT (double): transport coefficient in mm-1 unknown and to be estimated.
% sigEff (double): efficient coefficient in mm-1 with value given.
% A (double): diffuse Fresnel parameter for internal reflections in the
% material.
% r (mat): vector of radial distance given in millimeters (from 0 to 20
% mm).

% OUTPUT
% f (function): diffusion model to use for fitting.

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



r1 = sqrt((1./sigT).^2 + r.^2);
r2 = sqrt(((1./sigT)*(1+4*A/3)).^2 + r.^2);

f = ( (sigEff + 1./r1).*exp(-sigEff.*r1)./r1.^2 + ...
    (1 + 4*A/3)*(sigEff + 1./r2).*exp(-sigEff.*r2)./r2.^2 );

end