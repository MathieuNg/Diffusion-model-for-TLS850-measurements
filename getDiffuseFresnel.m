function [A] = getDiffuseFresnel(eta)
% AIM
% Computes the diffuse Fresnel parameter to take into consideration
% internal reflections inside the material following the method proposed by
% Donner et al., "Light diffusion in multi-layered translucent materials,” 
% ACM Trans. Graph. 24, 1032–1039 (2005).
% 
% INPUT
% eta (double): real part of the refractive index of the material
% considered.
% 
% OUTPUT
% A (double): diffuse Fresnel parameter defined by the following equation.

if eta < 1
    Fd = -0.4399 + 0.7099/eta - 0.3319/eta^2 + 0.0636/eta^2;
elseif eta >= 1
    Fd = -1.440/eta^2 + 0.710/eta + 0.668 + 0.0636*eta;
end

A = (1+Fd)/(1-Fd);

end