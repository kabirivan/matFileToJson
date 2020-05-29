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
       
    user = sprintf('%s',info.userData.userInfo.username);  
    
    % General Info of the experiment
    userTesting.(user).generalInfo.deviceModel = 'Myo Armband';
    userTesting.(user).generalInfo.samplingFrequencyInHertz = 200;
    userTesting.(user).generalInfo.recordingTimeInSeconds = 5;
    userTesting.(user).generalInfo.repetitionsForSynchronizationGesture = 5;
    userTesting.(user).generalInfo.myoPredictionLabel.waveOut = 1;
    userTesting.(user).generalInfo.myoPredictionLabel.waveIn = 2;
    userTesting.(user).generalInfo.myoPredictionLabel.fist = 3;
    userTesting.(user).generalInfo.myoPredictionLabel.open = 4;
    userTesting.(user).generalInfo.myoPredictionLabel.pinch = 5;
    userTesting.(user).generalInfo.myoPredictionLabel.noGesture = 6;
    
    % User info
    userTesting.(user).userInfo.age = userData.userInfo.age  ;
    userTesting.(user).userInfo.gender = userData.userInfo.gender;
    userTesting.(user).userInfo.occupation = userData.userInfo.occupation;
    userTesting.(user).userInfo.name   =  userData.userInfo.username;
    userTesting.(user).userInfo.ethnicGroup = userData.userInfo.ethnicGroup;
    
     if  userData.userInfo.handedness == "right_Handed"

        userTesting.(user).userInfo.handedness = 'right';

     elseif userData.userInfo.handedness == "left_Handed"

        userTesting.(user).userInfo.handedness = 'left';

     end
     
     if userData.userInfo.hasSufferedArmDamage == 1

        userTesting.(user).userInfo.ArmDamage = 'True';

     else

        userTesting.(user).userInfo.ArmDamage = 'False';

     end
       
    userTesting.(user).userInfo.distanceFromElbowToMyoInCm = userData.userInfo.fromElbowToMyo;
    userTesting.(user).userInfo.distanceFromElbowToUlnaInCm = userData.userInfo.fromElbowToUlna;
    userTesting.(user).userInfo.forearmPerimeterInCm = userData.userInfo.armPerimeter;
    userTesting.(user).userInfo.date = datestr(userData.extraInfo.date);       
       
       
       
       
       
       
   end 
end