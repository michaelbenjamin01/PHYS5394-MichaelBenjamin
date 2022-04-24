clear;
clc;

% load data
data1 = load("data1.txt")';
data2 = load("data2.txt")';
data3 = load("data3.txt")';

% signal parameters
a1 = 10;
a2 = 3;
a3 = 3;

nSamples = 2048;
sampFreq = 1024;

%% initialize noise PSD for each data file

noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;

% data1
dataLen1 = length(data1)/sampFreq;
kNyq1 = floor(nSamples/2)+1;
posFreq1 = (0:(kNyq1-1))*(1/dataLen1);
psdPosFreq1 = noisePSD(posFreq1);

% data2
dataLen2 = length(data2)/sampFreq;
kNyq2 = floor(nSamples/2)+1;
posFreq2 = (0:(kNyq2-1))*(1/dataLen2);
psdPosFreq2 = noisePSD(posFreq2);

% data3
dataLen3 = length(data3)/sampFreq;
kNyq3 = floor(nSamples/2)+1;
posFreq3 = (0:(kNyq3-1))*(1/dataLen3);
psdPosFreq3 = noisePSD(posFreq3);

%% calculate GLRT for each of the 3 data realizations

glrt_data1 = glrtqcsig(data1,10,[a1 a2 a3], sampFreq, psdPosFreq1)

glrt_data2 = glrtqcsig(data2,10,[a1 a2 a3], sampFreq, psdPosFreq2)

glrt_data3 = glrtqcsig(data3,10,[a1 a2 a3], sampFreq, psdPosFreq3)

%FIXME Incomplete: Missed the main part of Lab11/Tasks: set 4 (Review Lab Slides); Obtain significance for each observed GLRT value