function [] = computeInversion_method2(dataFilename, textFilename, matFilename, numIterations, eta)
% AIM
% Computes the inversion method fitted to a diffusion model to estimate
% absorption and reduced scattering coefficients from reflectance profiles
% data obtained through the Dia-Stron TLS850.
% The annotation Method 2 refers to performing the inversion method on an
% average of all records, thus obtaining optical properties for it. It is
% faster than the Method 1, but does not allow to run statistical studies.
% 
% INPUTS
% dataFilename (str): filename of .txt file containing the reflectance
% profiles obtained by acquisition through the TLS device.
% textFilename (str): filename of .txt file to save the final estimates of
% absorption and reduced scattering coefficients for each RGB channel.
% matFilename (str): filename of .mat file to access variables finalAbs and
% finalSca containing the final values of absorption and reduced scattering
% coefficients. This corresponds to the average of optical estimates.
% numIterations (int): integer to specify the number of iterations in the
% convergence loop to reach final values of estimates.
% eta (double): real part of the refractive index of the material.

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

% Part 1: Initialization
% Averaging all records
avgDataR = mean(dataR, [2]);
avgDataG = mean(dataG, [2]);
avgDataB = mean(dataB, [2]);

% Initial guesses
eff0 = zeros(1, 3);
trp0 = zeros(1, 3);

% RED Channel
[proDataR, proDistanceR] = getPreprocessedData(avgDataR, r);
sepR = getThresholdIndex(proDistanceR, proDataR);

[trp, eff] = computeChannelFitting_Init(A, proDistanceR, sepR, proDataR);
trp0(1,1) = trp;
eff0(1,1) = eff;

% GREEN Channel
[proDataG, proDistanceG] = getPreprocessedData(avgDataG, r);
sepG = getThresholdIndex(proDistanceG, proDataG);

[trp, eff] = computeChannelFitting_Init(A, proDistanceG, sepG, proDataG);
trp0(1,2) = trp;
eff0(1,2) = eff;

% BLUE Channel
[proDataB, proDistanceB] = getPreprocessedData(avgDataB, r);
sepB = getThresholdIndex(proDistanceB, proDataB);

[trp, eff] = computeChannelFitting_Init(A, proDistanceB, sepB, proDataB);
trp0(1,3) = trp;
eff0(1,3) = eff;

% Part 2: Iteration process for convergence
% Storing data for each iterations
saveEff = zeros(size(eff0,1), size(eff0,2), numIterations+1);
saveTrp = zeros(size(trp0,1), size(trp0,2), numIterations+1);

% Initialization of saving matrices
saveEff(1,:,1) = eff0;
saveTrp(1,:,1) = trp0;

% Iteration loop
for i = 2:numIterations+1
    fprintf(sprintf("Iteration #%d \n", i-1))

    eff = saveEff(:,:,i-1);
    trp = saveTrp(:,:,i-1);

    % Initialization
    effInt = zeros(1, 3);
    trpInt = zeros(1, 3);

    % RED Channel
    [proDataR, proDistanceR] = getPreprocessedData(avgDataR, r);
    sepR = getThresholdIndex(proDistanceR, proDataR);

    EFF = eff(1,1);
    TRP = trp(1,1);
    [transport, efficient] = computeChannelFitting_Loop(A, proDistanceR, sepR, proDataR, EFF, TRP);
    effInt(1,1) = efficient;
    trpInt(1,1) = transport;

    % GREEN Channel
    [proDataG, proDistanceG] = getPreprocessedData(avgDataG, r);
    sepG = getThresholdIndex(proDistanceG, proDataG);

    EFF = eff(1,2);
    TRP = trp(1,2);
    [transport, efficient] = computeChannelFitting_Loop(A, proDistanceG, sepG, proDataG, EFF, TRP);
    effInt(1,2) = efficient;
    trpInt(1,2) = transport;

    % BLUE Channel
    [proDataB, proDistanceB] = getPreprocessedData(avgDataB, r);
    sepB = getThresholdIndex(proDistanceB, proDataB);

    EFF = eff(1,3);
    TRP = trp(1,3);
    [transport, efficient] = computeChannelFitting_Loop(A, proDistanceB, sepB, proDataB, EFF, TRP);
    effInt(1,3) = efficient;
    trpInt(1,3) = transport;

    % Saving results for next iteration
    saveEff(1,:,i) = effInt;
    saveTrp(1,:,i) = trpInt;
end

% Converting from (transport, efficient) to (absorption, reduced
% scattering) by taking the mean of all estimates for transport and
% efficient coefficients (method 1)
finalEff = saveEff(1,:,end);
finalTrp = saveTrp(1,:,end);
[finalSca, finalAbs] = getOpticalProperties(finalTrp, finalEff);

% Writing processes in the .txt file and .mat file
fprintf(resultsID, 'Abs (RGB): %.3e %.3e %.3e\n', finalAbs(1), finalAbs(2), finalAbs(3));
fprintf(resultsID, 'Sca (RGB): %.3e %.3e %.3e\n', finalSca(1), finalSca(2), finalSca(3));
fprintf(resultsID, '\n');
save(matFilename, 'finalAbs', 'finalSca')

% Closing the .txt file
fclose(resultsID);

end