function [A] = getDiffuseFresnel(eta)
% AIM
% Computes the diffuse Fresnel parameter to take into consideration
% internal reflections inside the material following the method proposed by
% Donner et al., "Light diffusion in multi-layered translucent materials,” 
% ACM Trans. Graph. 24, 1032–1039 (2005).

% INPUT
% eta (double): real part of the refractive index of the material
% considered.

% OUTPUT
% A (double): diffuse Fresnel parameter defined by the following equation.

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



if eta < 1
    Fd = -0.4399 + 0.7099/eta - 0.3319/eta^2 + 0.0636/eta^2;
elseif eta >= 1
    Fd = -1.440/eta^2 + 0.710/eta + 0.668 + 0.0636*eta;
end

A = (1+Fd)/(1-Fd);

end