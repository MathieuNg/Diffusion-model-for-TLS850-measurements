clear all
close all

% Data filename should be precised with the .txt extension, with the folder
% root included in the name.
dataFilename = '.txt';

% Output will give a .txt file and a .mat file. Text file contains the average estimates of
% absorption and reduced scattering coefficients for RGB channels given in
% mm-1. 
textFilename = '.txt';

% Matrix file contains two variables finalAbs and finalSca. Both are
% matrices with values of absorption and reduced scattering coefficients
% for each record (method 1) or for the average of records (method 2).
matFilename = '.mat';

% Creating a .mat file containing the final estimates of absorption and
% reduced scattering coefficients for all RGB channels and records.
% Variables stored in this matrix are statAbs and statSca.
statFilename = '.mat';

% Number of iterations to loop to have final estimates of the coefficients.
% Convergence is reached quite rapidly in most cases.
numIterations = 20;

% Real part of the refractive index
eta = ;

% METHOD 1: Averaging estimates
% fprintf('### Method 1 ###\n');
% computeInversion_method1(dataFilename, textFilename, matFilename, statFilename, numIterations, eta);

% METHOD 2: Averaging signals
% fprintf('### Method 2 ###\n');
% computeInversion_method2(dataFilename, textFilename, matFilename, statFilename, numIterations, eta);