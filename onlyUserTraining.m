close all
clear all
clc


%% Load training data  

folders = dir('training');
numFolders = length(folders);


for i = 1:3
    
   if ~(strcmpi(folders(i).name, '.') || strcmpi(folders(i).name, '..') || strcmpi(folders(i).name, '.DS_Store'))
   info = load(['training/' folders(i).name '/userData.mat']) ;
   userData = info.userData;
    
   % Auxiliar variables for hand gestures
    a=0;
    b=0;
    c=0;
    d=0;
    e=0;
    f=0;
    
    
    user = sprintf('%s',info.userData.userInfo.username);
       
    % General info of experiment
    userTraining.(user).generalInfo.deviceModel = 'Myo Armband';
    userTraining.(user).generalInfo.samplingFrequencyInHertz = 200;
    userTraining.(user).generalInfo.recordingTimeInSeconds = 5;
    userTraining.(user).generalInfo.repetitionsForSynchronizationGesture = 5;
    userTraining.(user).generalInfo.myoPredictionLabel.waveOut = 1;
    userTraining.(user).generalInfo.myoPredictionLabel.waveIn = 2;
    userTraining.(user).generalInfo.myoPredictionLabel.fist = 3;
    userTraining.(user).generalInfo.myoPredictionLabel.open = 4;
    userTraining.(user).generalInfo.myoPredictionLabel.pinch = 5;
    userTraining.(user).generalInfo.myoPredictionLabel.noGesture = 6;
    
    % User info 
    userTraining.(user).userInfo.name   =  userData.userInfo.username;  
    userTraining.(user).userInfo.age = userData.userInfo.age;
    userTraining.(user).userInfo.gender = userData.userInfo.gender;
    userTraining.(user).userInfo.occupation = userData.userInfo.occupation;
    userTraining.(user).userInfo.ethnicGroup = userData.userInfo.ethnicGroup;
    
    if  userData.userInfo.handedness == "right_Handed"

        userTraining.(user).userInfo.handedness = 'right';

    elseif userData.userInfo.handedness == "left_Handed"

        userTraining.(user).userInfo.handedness = 'left';

    end
    
 

    if userData.userInfo.hasSufferedArmDamage == 1

        userTraining.(user).userInfo.ArmDamage = 'True';

    else

        userTraining.(user).userInfo.ArmDamage = 'False';

    end

    userTraining.(user).userInfo.distanceFromElbowToMyoInCm = userData.userInfo.fromElbowToMyo;
    userTraining.(user).userInfo.distanceFromElbowToUlnaInCm = userData.userInfo.fromElbowToUlna;
    userTraining.(user).userInfo.armPerimeterInCm = userData.userInfo.armPerimeter;
    userTraining.(user).userInfo.date = datestr(userData.extraInfo.date);
    
       
       
       
   end
    
end
