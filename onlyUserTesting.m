close all
clear all
clc

% Xavier Aguas.
% Artificial Intelligence and Computer Vision Research Lab
% Escuela Politécnica Nacional, Quito - Ecuador
% xavier.aguas@epn.edu.ec
% May 29, 2020


close all
clear all
clc 


folders = dir('testing');
numFolders = length(folders);
numUsertesting = numFolders;


for i = 1:numFolders
   if ~(strcmpi(folders(i).name, '.') || strcmpi(folders(i).name, '..') || strcmpi(folders(i).name, '.DS_Store'))  
    
   info = load(['testing/' folders(i).name '/userData.mat']) ;
   userData = info.userData;    
       
       
       
       
       
       
       
       
       
       
   end 
end