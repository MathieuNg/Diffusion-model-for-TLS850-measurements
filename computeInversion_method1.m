function [] = computeInversion_method1(dataFilename, textFilename, matFilename, statFilename, numIterations, eta)
% AIM
% Computes the inversion method fitted to a diffusion model to estimate
% absorption and reduced scattering coefficients from reflectance profiles
% data obtained through the Dia-Stron TLS850.
% The annotation Method 1 refers to performing the inversion method on all
% records acquired, thus obtaining optical estimates for each estimates,
% then returning the average of these estimates.

% INPUTS
% dataFilename (str): filename of .txt file containing the reflectance
% profiles obtained by acquisition through the TLS device.
% textFilename (str): filename of .txt file to save the final estimates of
% absorption and reduced scattering coefficients for each RGB channel.
% matFilename (str): filename of .mat file to access variables finalAbs and
% finalSca containing the final values of absorption and reduced scattering
% coefficients. This corresponds to the average of optical estimates.
% statFilename (str): filename of .mat file containing final values of
% absorption and reduced scattering for all records (before the averaging
% process explained). Use these variables to run a statistical study on the
% estimates.
% numIterations (int): integer to specify the number of iterations in the
% convergence loop to reach final values of estimates.
% eta (double): real part of the refractive index of the material.

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



% Creating text file for the results
resultsID = fopen(textFilename, 'w');

% Reading data from TLS text file that must be exported from the software
% first. All records for each channel are extracted and stored in the
% following variables.
[dataR, dataG, dataB] = readDataTLS(dataFilename);
numRecords = size(dataR, 2);

% Diffuse Fresnel parameter varying depending on the material and the real
% part of the refractive index
A = getDiffuseFresnel(eta);

% Modelisation of the NMOS sensor array. Its length is of 20 millimeters
% and it is needed to compute the diffusion model and obtain estimates of
% optical coefficients in the proper unit.
r = linspace(0, 20, 512);
r = r(:);


% The following part is the algorithm of the Inversion method. It is
% divided into two parts. First is the initialisation of the loop process
% with a first estimation of optical coefficients. Second part is the loop to
% reach convergence and final values of optical coefficients. The method
% focuses on estimating efficient (eff) and transport (trp) coefficient,
% which are then converted to absorption (abs) and reduced scattering (sca)
% coefficients.

% Part 1: Initialization
% Creating initial guesses
eff0 = zeros(numRecords, 3);
trp0 = zeros(numRecords, 3);

% Loop over all records
for rec = 1:numRecords
    % RED Channel
    [proDataR, proDistanceR] = getPreprocessedData(dataR(:,rec), r);
    sepR = getThresholdIndex(proDistanceR, proDataR);

    [trp, eff] = computeChannelFitting_Init(A, proDistanceR, sepR, proDataR);
    trp0(rec,1) = trp;
    eff0(rec,1) = eff;

    % GREEN Channel
    [proDataG, proDistanceG] = getPreprocessedData(dataG(:,rec), r);
    sepG = getThresholdIndex(proDistanceG, proDataG);

    [trp, eff] = computeChannelFitting_Init(A, proDistanceG, sepG, proDataG);
    trp0(rec,2) = trp;
    eff0(rec,2) = eff;

    % BLUE Channel
    [proDataB, proDistanceB] = getPreprocessedData(dataB(:,rec), r);
    sepB = getThresholdIndex(proDistanceB, proDataB);

    [trp, eff] = computeChannelFitting_Init(A, proDistanceB, sepB, proDataB);
    trp0(rec,3) = trp;
    eff0(rec,3) = eff;
end

% After this loop, the first initial estimates for the optical properties
% are known and will be used in the second part to reach convergence.
% Instead of having a random guess for sigT and sigEff, previous iterations
% would be used to refine the final values.


% Part 2: Iteration process for convergence
% Storing data for each iteration
saveEff = zeros(size(eff0,1), size(eff0,2), numIterations+1);
saveTrp = zeros(size(trp0,1), size(trp0,2), numIterations+1);

% Initialization of saving matrices
saveEff(:,:,1) = eff0;
saveTrp(:,:,1) = trp0;

% Iteration loop
for i = 2:numIterations+1
    fprintf(sprintf("Iteration #%d \n", i-1))
    eff = saveEff(:,:,i-1);
    trp = saveTrp(:,:,i-1);

    % Initialization
    effInt = zeros(numRecords, 3);
    trpInt = zeros(numRecords, 3);

    for rec = 1:numRecords
        % RED Channel
        [proDataR, proDistanceR] = getPreprocessedData(dataR(:,rec), r);
        sepR = getThresholdIndex(proDistanceR, proDataR);

        EFF = eff(rec,1);
        TRP = trp(rec,1);
        [transport, efficient] = computeChannelFitting_Loop(A, proDistanceR, sepR, proDataR, EFF, TRP);
        effInt(rec,1) = efficient;
        trpInt(rec,1) = transport;

        % GREEN Channel
        [proDataG, proDistanceG] = getPreprocessedData(dataG(:,rec), r);
        sepG = getThresholdIndex(proDistanceG, proDataG);

        EFF = eff(rec,2);
        TRP = trp(rec,2);
        [transport, efficient] = computeChannelFitting_Loop(A, proDistanceG, sepG, proDataG, EFF, TRP);
        effInt(rec,2) = efficient;
        trpInt(rec,2) = transport;

        % BLUE Channel
        [proDataB, proDistanceB] = getPreprocessedData(dataB(:,rec), r);
        sepB = getThresholdIndex(proDistanceB, proDataB);

        EFF = eff(rec,3);
        TRP = trp(rec,3);
        [transport, efficient] = computeChannelFitting_Loop(A, proDistanceB, sepB, proDataB, EFF, TRP);
        effInt(rec,3) = efficient;
        trpInt(rec,3) = transport;
    end

    % Saving results for next iteration
    saveEff(:,:,i) = effInt;
    saveTrp(:,:,i) = trpInt;
end

% Converting from (transport, efficient) to (absorption, reduced
% scattering) by taking the mean of all estimates for transport and
% efficient coefficients (method 1)
finalEff = mean(saveEff(:,:,end), [1]);
finalTrp = mean(saveTrp(:,:,end), [1]);
[finalSca, finalAbs] = getOpticalProperties(finalTrp, finalEff);

% Writing processes in the .txt file and .mat file
fprintf(resultsID, 'Abs (RGB): %.3e %.3e %.3e\n', finalAbs(1), finalAbs(2), finalAbs(3));
fprintf(resultsID, 'Sca (RGB): %.3e %.3e %.3e\n', finalSca(1), finalSca(2), finalSca(3));
fprintf(resultsID, '\n');
save(matFilename, 'finalAbs', 'finalSca')

% Writing process of the .mat to store values for statistical studies of
% optical properties
[statSca, statAbs] = getOpticalProperties(saveTrp(:,:,end), saveEff(:,:,end));
save(statFilename, 'statAbs', 'statSca')

% Closing the .txt file
fclose(resultsID);

end
