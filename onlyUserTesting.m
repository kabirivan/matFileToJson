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
       
    % Auxiliar Variable for hand Gestures
    
        a=0;
        b=0;
        c=0;
        d=0;
        e=0;
        f=0;
    
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
       
       
    %% Synchronization Gesture Samples
    
    for kSyn = 1:5
        
        sample = sprintf('sample%d',kSyn);
        userTesting.(user).synchronizationGesture.(sample).startPointforGestureExecution  = userData.sync{kSyn, 1}.pointGestureBegins; 
        userTesting.(user).synchronizationGesture.(sample).myoDetection                   = userData.sync{kSyn, 1}.pose_myo;  
        numberRotationMatrix = length(userData.sync{kSyn, 1}.rot);
        
         for rm = 1:numberRotationMatrix
           matrix = sprintf('quaternion%d',rm);
           userTesting.(user).synchronizationGesture.(sample).quaternion.(matrix) = rotm2quat(userData.sync{kSyn, 1}.rot(:,:,rm)); 
         end
         
         for ch = 1:8         
           channel = sprintf('ch%d',ch);
           userTesting.(user).synchronizationGesture.(sample).emg.(channel) = userData.sync{kSyn, 1}.emg(:,ch);        
         end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
          xyz = sprintf('%s',dofnames(dof));
          userTesting.(user).synchronizationGesture.(sample).gyroscope.(xyz) = userData.sync{kSyn, 1}.gyro(:,dof);
          userTesting.(user).synchronizationGesture.(sample).accelerometer.(xyz) = userData.sync{kSyn, 1}.accel(:,dof);
        end
        
        
    end
    
    
    for kRep = 1:150
        
        %% No gesture (Training)
        
    if userData.training{kRep, 1}.gestureName == 'noGesture'

        a = a+1;
        sample = sprintf('sample%d',a);
        userTesting.(user).trainingSamples.noGesture.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins; 
        userTesting.(user).trainingSamples.noGesture.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;
        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
          matrix = sprintf('quaternion%d',rm);
          userTesting.(user).trainingSamples.noGesture.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
        end

       for ch = 1:8
         channel = sprintf('ch%d',ch);
         userTesting.(user).trainingSamples.noGesture.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
       end

       dofnames = ["x","y","z"];

       for dof = 1 : 3
         xyz = sprintf('%s',dofnames(dof));
         userTesting.(user).trainingSamples.noGesture.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
         userTesting.(user).trainingSamples.noGesture.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
       end
       
    end 
    
    %% Fist Gesture  (Training)
    
    if userData.training{kRep, 1}.gestureName == 'fist'
        
        b=b+1;
        sample = sprintf('sample%d',b);

        userTesting.(user).trainingSamples.fist.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;
        userTesting.(user).trainingSamples.fist.(sample).groundTruth                    = userData.training{kRep, 1}.groundTruth;
        userTesting.(user).trainingSamples.fist.(sample).groundTruthIndex               = userData.training{kRep, 1}.groundTruthIndex;
        userTesting.(user).trainingSamples.fist.(sample).myoDetection                   = userData.training{kRep, 1}.pose_myo;
        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
          matrix = sprintf('quaternion%d',rm);
          userTesting.(user).trainingSamples.fist.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
        end

        for ch = 1:8
          channel = sprintf('ch%d',ch);
          userTesting.(user).trainingSamples.fist.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
          xyz = sprintf('%s',dofnames(dof));
          userTesting.(user).trainingSamples.fist.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
          userTesting.(user).trainingSamples.fist.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end
            
    end 
        
    
    
    %% Open Gesture (Training)
    
     if userData.training{kRep, 1}.gestureName == 'open'
        c = c+1;
       
        sample = sprintf('sample%d',c);
        userTesting.(user).trainingSamples.open.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;  
        userTesting.(user).trainingSamples.open.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
        userTesting.(user).trainingSamples.open.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
        userTesting.(user).trainingSamples.open.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;
        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
          matrix = sprintf('quaternion%d',rm);
          userTesting.(user).trainingSamples.open.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
        end 

        for ch = 1:8
          channel = sprintf('ch%d',ch);
          userTesting.(user).trainingSamples.open.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
          xyz = sprintf('%s',dofnames(dof));
          userTesting.(user).trainingSamples.open.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
          userTesting.(user).trainingSamples.open.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end
                       
      end 
    
    
    %% Pinch gesture (Training)
    
    
     if userData.training{kRep, 1}.gestureName == 'pinch'    
        d = d+1;
        sample = sprintf('sample%d',d);
        userTesting.(user).trainingSamples.pinch.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;  
        userTesting.(user).trainingSamples.pinch.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
        userTesting.(user).trainingSamples.pinch.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
        userTesting.(user).trainingSamples.pinch.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;
        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
           matrix = sprintf('quaternion%d',rm);
           userTesting.(user).trainingSamples.pinch.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
        end

        for ch = 1:8
           channel = sprintf('ch%d',ch);
           userTesting.(user).trainingSamples.pinch.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
           xyz = sprintf('%s',dofnames(dof));
           userTesting.(user).trainingSamples.pinch.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
           userTesting.(user).trainingSamples.pinch.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end

     end 
       
     %% waveOut Gesture (Training)
    
     if userData.training{kRep, 1}.gestureName == 'waveOut'
        e=e+1;
        sample = sprintf('sample%d',e);

        userTesting.(user).trainingSamples.waveOut.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;
        userTesting.(user).trainingSamples.waveOut.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
        userTesting.(user).trainingSamples.waveOut.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
        userTesting.(user).trainingSamples.waveOut.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;


        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
            matrix = sprintf('quaternion%d',rm);
            userTesting.(user).trainingSamples.waveOut.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
        end

        for ch = 1:8
            channel = sprintf('ch%d',ch);
            userTesting.(user).trainingSamples.waveOut.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
            xyz = sprintf('%s',dofnames(dof));
            userTesting.(user).trainingSamples.waveOut.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
            userTesting.(user).trainingSamples.waveOut.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end    
            
     end  
     
     
     %% waveIn Gesture (Training)
    
        if userData.training{kRep, 1}.gestureName == 'waveIn'
            
            f = f+1;
            
            sample = sprintf('sample%d',f);
            userTesting.(user).trainingSamples.waveIn.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;  
            userTesting.(user).trainingSamples.waveIn.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
            userTesting.(user).trainingSamples.waveIn.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
            userTesting.(user).trainingSamples.waveIn.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;
            
            
            numberRotationMatrix = length(userData.training{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix 
                matrix = sprintf('quaternion%d',rm);
                userTesting.(user).trainingSamples.waveIn.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm));                    
            end   
            
            for ch = 1:8
                channel = sprintf('ch%d',ch);
                userTesting.(user).trainingSamples.waveIn.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
                xyz = sprintf('%s',dofnames(dof));
                userTesting.(user).trainingSamples.waveIn.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
                userTesting.(user).trainingSamples.waveIn.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
            end    
            
        end 
       

    end
    
   
    
    
   for kRep = 1:150  
         
      sample = sprintf('sample%d',kRep);
      userTesting.(user).testingSamples.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins;
      userTesting.(user).testingSamples.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;

      numberRotationMatrix = length(userData.testing{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
           matrix = sprintf('quaternion%d',rm);
           userTesting.(user).testingSamples.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm)); 
        end 


       for ch = 1:8
         channel = sprintf('ch%d',ch);
         userTesting.(user).testingSamples.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
       end

       dofnames = ["x","y","z"];

       for dof = 1 : 3
          xyz = sprintf('%s',dofnames(dof));
          userTesting.(user).testingSamples.(sample).gyroscope.(xyz) = userData.testing{kRep, 1}.gyro(:,dof);
          userTesting.(user).testingSamples.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);
       end  
         
         
         
         
   end
    
       
       
       
   end 
end


userList = fieldnames(userTesting);
savePath = './JSONtesting/'; %  String of the path to save your file in
userNum = size(userList,1);
ext = '.json';

for i = 1:userNum
  userchoose = userTesting.(userList{i});
  txt = jsonencode(userchoose);
  fileID = fopen([savePath userList{i} ext],'wt');
  fprintf(fileID,txt);   
end



