close all
clear all
clc

% Xavier Aguas.
% Artificial Intelligence and Computer Vision Research Lab
% Escuela Politécnica Nacional, Quito - Ecuador
% xavier.aguas@epn.edu.ec
% May 29, 2020

%% Load training data  

folders = dir('training');
numFolders = length(folders);


for i = 1:numFolders
    
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
    
    %% Synchronization Gesture Samples
    
     for kSyn = 1:5
        sample = sprintf('sample%d',kSyn);
        userTraining.(user).synchronizationGesture.(sample).startPointforGestureExecution  = userData.sync{kSyn, 1}.pointGestureBegins; 
        userTraining.(user).synchronizationGesture.(sample).myoDetection                   = userData.sync{kSyn, 1}.pose_myo;
        
        numberRotationMatrix = length(userData.sync{kSyn, 1}.rot);
        
         for rm = 1:numberRotationMatrix
            matrix = sprintf('quaternion%d',rm);

            userTraining.(user).synchronizationGesture.(sample).quaternion.(matrix) = rotm2quat(userData.sync{kSyn, 1}.rot(:,:,rm)); 

         end
         
         for ch = 1:8
               
                channel = sprintf('ch%d',ch);
                userTraining.(user).synchronizationGesture.(sample).emg.(channel) = userData.sync{kSyn, 1}.emg(:,ch);
             
         end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
            
            xyz = sprintf('%s',dofnames(dof));
            userTraining.(user).synchronizationGesture.(sample).gyroscope.(xyz) = userData.sync{kSyn, 1}.gyro(:,dof);
            userTraining.(user).synchronizationGesture.(sample).accelerometer.(xyz) = userData.sync{kSyn, 1}.accel(:,dof);

        end
        
        
     end
 
 
 %% Training Samples    
     
  for kRep = 1:150    
      
   %% noGesture Gesture   
   
   if userData.training{kRep, 1}.gestureName == 'noGesture'
       
      a = a+1;
      sample = sprintf('sample%d',a);

      userTraining.(user).trainingSamples.noGesture.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins; 
      userTraining.(user).trainingSamples.noGesture.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;

      numberRotationMatrix = length(userData.training{kRep, 1}.rot);

      for rm = 1:numberRotationMatrix
         matrix = sprintf('quaternion%d',rm);
         userTraining.(user).trainingSamples.noGesture.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
      end

       for ch = 1:8
          channel = sprintf('ch%d',ch);
          userTraining.(user).trainingSamples.noGesture.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
       end

       dofnames = ["x","y","z"];

       for dof = 1 : 3
           xyz = sprintf('%s',dofnames(dof));
           userTraining.(user).trainingSamples.noGesture.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
           userTraining.(user).trainingSamples.noGesture.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);

       end
   end 
     
   
   %% Fist Gesture
   
    
        if userData.training{kRep, 1}.gestureName == 'fist'
            
            b=b+1;
            sample = sprintf('sample%d',b);
            
            userTraining.(user).trainingSamples.fist.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;
            userTraining.(user).trainingSamples.fist.(sample).groundTruth                    = userData.training{kRep, 1}.groundTruth;
            userTraining.(user).trainingSamples.fist.(sample).groundTruthIndex               = userData.training{kRep, 1}.groundTruthIndex;
            userTraining.(user).trainingSamples.fist.(sample).myoDetection                   = userData.training{kRep, 1}.pose_myo;
            
            
            numberRotationMatrix = length(userData.training{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix
             matrix = sprintf('quaternion%d',rm);
             userTraining.(user).trainingSamples.fist.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
            end

            for ch = 1:8
                channel = sprintf('ch%d',ch);
                userTraining.(user).trainingSamples.fist.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
                xyz = sprintf('%s',dofnames(dof));
                userTraining.(user).trainingSamples.fist.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
                userTraining.(user).trainingSamples.fist.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);

            end
            
        end 
        
        
        
        
   %% Open Gesture
   
   
       if userData.training{kRep, 1}.gestureName == 'open'
            
            c = c+1;
            sample = sprintf('sample%d',c);
            userTraining.(user).trainingSamples.open.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;  
            userTraining.(user).trainingSamples.open.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
            userTraining.(user).trainingSamples.open.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
            userTraining.(user).trainingSamples.open.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;
            
            
            numberRotationMatrix = length(userData.training{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix
               matrix = sprintf('quaternion%d',rm);
               userTraining.(user).trainingSamples.open.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
            end 
            
            for ch = 1:8
                channel = sprintf('ch%d',ch);
                userTraining.(user).trainingSamples.open.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
                xyz = sprintf('%s',dofnames(dof));
                userTraining.(user).trainingSamples.open.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
                userTraining.(user).trainingSamples.open.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
            end
            
            
        end 
        
   %% Pinch Gesture
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
       if userData.training{kRep, 1}.gestureName == 'pinch'

        d = d+1;
        sample = sprintf('sample%d',d);
        userTraining.(user).trainingSamples.pinch.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;  
        userTraining.(user).trainingSamples.pinch.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
        userTraining.(user).trainingSamples.pinch.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
        userTraining.(user).trainingSamples.pinch.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;


        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
            matrix = sprintf('quaternion%d',rm);
            userTraining.(user).trainingSamples.pinch.(sample).quaternions.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm));
        end 

        for ch = 1:8
            channel = sprintf('ch%d',ch);
            userTraining.(user).trainingSamples.pinch.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
            xyz = sprintf('%s',dofnames(dof));
            userTraining.(user).trainingSamples.pinch.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
            userTraining.(user).trainingSamples.pinch.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end

       end
       
       
    %% WaveOut Gesture   
    
    if userData.training{kRep, 1}.gestureName == 'waveOut'
        
        e = e+1;
        sample = sprintf('sample%d',e);
        userTraining.(user).trainingSamples.waveOut.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;
        userTraining.(user).trainingSamples.waveOut.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
        userTraining.(user).trainingSamples.waveOut.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
        userTraining.(user).trainingSamples.waveOut.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;


        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
            matrix = sprintf('quaternion%d',rm);
            userTraining.(user).trainingSamples.waveOut.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm)); 
        end

        for ch = 1:8
            channel = sprintf('ch%d',ch);
            userTraining.(user).trainingSamples.waveOut.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
            xyz = sprintf('%s',dofnames(dof));
            userTraining.(user).trainingSamples.waveOut.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
            userTraining.(user).trainingSamples.waveOut.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end    
            
     end    
        
     
    
   %% WaveIn Gesture  
    
    if userData.training{kRep, 1}.gestureName == 'waveIn'
        
        f = f + 1;
        sample = sprintf('sample%d',f);
        userTraining.(user).trainingSamples.waveIn.(sample).startPointforGestureExecution  = userData.training{kRep, 1}.pointGestureBegins;  
        userTraining.(user).trainingSamples.waveIn.(sample).groundTruth =                    userData.training{kRep, 1}.groundTruth;
        userTraining.(user).trainingSamples.waveIn.(sample).groundTruthIndex =               userData.training{kRep, 1}.groundTruthIndex;
        userTraining.(user).trainingSamples.waveIn.(sample).myoDetection  =                  userData.training{kRep, 1}.pose_myo;


        numberRotationMatrix = length(userData.training{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
            matrix = sprintf('quaternion%d',rm);
            userTraining.(user).trainingSamples.waveIn.(sample).quaternion.(matrix) = rotm2quat(userData.training{kRep, 1}.rot(:,:,rm));      
        end   

        for ch = 1:8
            channel = sprintf('ch%d',ch);
            userTraining.(user).trainingSamples.waveIn.(sample).emg.(channel) = userData.training{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
            xyz = sprintf('%s',dofnames(dof));
            userTraining.(user).trainingSamples.waveIn.(sample).gyroscope.(xyz) = userData.training{kRep, 1}.gyro(:,dof);
            userTraining.(user).trainingSamples.waveIn.(sample).accelerometer.(xyz) = userData.training{kRep, 1}.accel(:,dof);
        end    

    end
    
    
  end
    
 
  
  %% Testing Samples
  
  % Auxiliar variables for hand gestures
    a=0;
    b=0;
    c=0;
    d=0;
    e=0;
    f=0;

  for kRep = 1:150  
  
    %%  No Gesture (Testing)
    if userData.testing{kRep, 1}.gestureName == 'noGesture'
        
        a = a+1;
        
        sample = sprintf('sample%d',a);
        userTraining.(user).testingSamples.noGesture.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins; 
        userTraining.(user).testingSamples.noGesture.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;
        numberRotationMatrix = length(userData.testing{kRep, 1}.rot);

        for rm = 1:numberRotationMatrix
           matrix = sprintf('quaternion%d',rm);
           userTraining.(user).testingSamples.noGesture.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm)); 
        end

       for ch = 1:8
        channel = sprintf('ch%d',ch);
        userTraining.(user).testingSamples.noGesture.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
       end

       dofnames = ["x","y","z"];

       for dof = 1 : 3
           xyz = sprintf('%s',dofnames(dof));
           userTraining.(user).testingSamples.noGesture.(sample).gyroscope.(xyz) = userData.testing{kRep, 1}.gyro(:,dof);
           userTraining.(user).testingSamples.noGesture.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);

       end
    end 
    
    %% Fist Gesture (testing)
    
         if userData.testing{kRep, 1}.gestureName == 'fist'
             
            b = b+1;
            sample = sprintf('sample%d',b);
            userTraining.(user).testingSamples.fist.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins;  
            userTraining.(user).testingSamples.fist.(sample).groundTruth =                    userData.testing{kRep, 1}.groundTruth;
            userTraining.(user).testingSamples.fist.(sample).groundTruthIndex =               userData.testing{kRep, 1}.groundTruthIndex;
            userTraining.(user).testingSamples.fist.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;
            
            
            numberRotationMatrix = length(userData.testing{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix
                matrix = sprintf('quaternion%d',rm);
                userTraining.(user).testingSamples.fist.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm));
            end   
            
            
            for ch = 1:8
                channel = sprintf('ch%d',ch);
                userTraining.(user).testingSamples.fist.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
                xyz = sprintf('%s',dofnames(dof));
                userTraining.(user).testingSamples.fist.(sample).gyroscope.(xyz) =     userData.testing{kRep, 1}.gyro(:,dof);
                userTraining.(user).testingSamples.fist.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);

            end
            
         end
        
         
     %% Open Gesture (Testing)    
         
        if userData.testing{kRep, 1}.gestureName == 'open'
              
            c = c+1;
            
            sample = sprintf('sample%d',c);
            userTraining.(user).testingSamples.open.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins;  
            userTraining.(user).testingSamples.open.(sample).groundTruth =                    userData.testing{kRep, 1}.groundTruth;
            userTraining.(user).testingSamples.open.(sample).groundTruthIndex =               userData.testing{kRep, 1}.groundTruthIndex;
            userTraining.(user).testingSamples.open.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;            
            numberRotationMatrix = length(userData.testing{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix
               matrix = sprintf('quaternion%d',rm);
               userTraining.(user).testingSamples.open.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm));
            end 
            
            for ch = 1:8
               channel = sprintf('ch%d',ch);
               userTraining.(user).testingSamples.open.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
                xyz = sprintf('%s',dofnames(dof));
                userTraining.(user).testingSamples.open.(sample).gyroscope.(xyz) = userData.testing{kRep, 1}.gyro(:,dof);
                userTraining.(user).testingSamples.open.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);
            end
            
            
        end 
        
    %% Pinch Gesture (Testing)        
        
        
        if userData.testing{kRep, 1}.gestureName == 'pinch'
           
            d = d+1;
            
            sample = sprintf('sample%d',d);
            userTraining.(user).testingSamples.pinch.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins;  
            userTraining.(user).testingSamples.pinch.(sample).groundTruth =                    userData.testing{kRep, 1}.groundTruth;
            userTraining.(user).testingSamples.pinch.(sample).groundTruthIndex =               userData.testing{kRep, 1}.groundTruthIndex;
            userTraining.(user).testingSamples.pinch.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;
            numberRotationMatrix = length(userData.testing{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix
              matrix = sprintf('quaternion%d',rm);
              userTraining.(user).testingSamples.pinch.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm));
            end 
            
            for ch = 1:8
              channel = sprintf('ch%d',ch);
              userTraining.(user).testingSamples.pinch.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
              xyz = sprintf('%s',dofnames(dof));
              userTraining.(user).testingSamples.pinch.(sample).gyroscope.(xyz) = userData.testing{kRep, 1}.gyro(:,dof);
              userTraining.(user).testingSamples.pinch.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);
            end

       end 
       
   %% WaveOut Gesture
   
   
        if userData.testing{kRep, 1}.gestureName == 'waveOut'
            
            e = e+1;
            
            sample = sprintf('sample%d',e);
            userTraining.(user).testingSamples.waveOut.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins;  
            userTraining.(user).testingSamples.waveOut.(sample).groundTruth =                    userData.testing{kRep, 1}.groundTruth;
            userTraining.(user).testingSamples.waveOut.(sample).groundTruthIndex =               userData.testing{kRep, 1}.groundTruthIndex;
            userTraining.(user).testingSamples.waveOut.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;
            
            
            numberRotationMatrix = length(userData.testing{kRep, 1}.rot);
            
            for rm = 1:numberRotationMatrix
                matrix = sprintf('quaternion%d',rm);
                userTraining.(user).testingSamples.waveOut.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm));
            end 

            for ch = 1:8
                channel = sprintf('ch%d',ch);
                userTraining.(user).testingSamples.waveOut.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
            end

            dofnames = ["x","y","z"];

            for dof = 1 : 3
                xyz = sprintf('%s',dofnames(dof));
                userTraining.(user).testingSamples.waveOut.(sample).gyroscope.(xyz) = userData.testing{kRep, 1}.gyro(:,dof);
                userTraining.(user).testingSamples.waveOut.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);
            end    
            
        end 
    
     %% WaveIn Gesture   
        
     if userData.testing{kRep, 1}.gestureName == 'waveIn'
          
        f = f+1;
        
        sample = sprintf('sample%d',f);
        userTraining.(user).testingSamples.waveIn.(sample).startPointforGestureExecution  = userData.testing{kRep, 1}.pointGestureBegins;  
        userTraining.(user).testingSamples.waveIn.(sample).groundTruth =                    userData.testing{kRep, 1}.groundTruth;
        userTraining.(user).testingSamples.waveIn.(sample).groundTruthIndex =               userData.testing{kRep, 1}.groundTruthIndex;
        userTraining.(user).testingSamples.waveIn.(sample).myoDetection  =                  userData.testing{kRep, 1}.pose_myo;

            
        numberRotationMatrix = length(userData.testing{kRep, 1}.rot);
            
        for rm = 1:numberRotationMatrix
            matrix = sprintf('quaternion%d',rm);
            userTraining.(user).testingSamples.waveIn.(sample).quaternion.(matrix) = rotm2quat(userData.testing{kRep, 1}.rot(:,:,rm));
        end 
            
        for ch = 1:8
            channel = sprintf('ch%d',ch);
            userTraining.(user).testingSamples.waveIn.(sample).emg.(channel) = userData.testing{kRep, 1}.emg(:,ch);
        end

        dofnames = ["x","y","z"];

        for dof = 1 : 3
            xyz = sprintf('%s',dofnames(dof));
            userTraining.(user).testingSamples.waveIn.(sample).gyroscope.(xyz) = userData.testing{kRep, 1}.gyro(:,dof);
            userTraining.(user).testingSamples.waveIn.(sample).accelerometer.(xyz) = userData.testing{kRep, 1}.accel(:,dof);
        end    
            
     end    
             
  
   end     
 end
    
end


userList = fieldnames(userTraining);
savePath = './JSONtraining/'; %  String of the path to save your file in
userNum = size(userList,1);
ext = '.json';

for i = 1:userNum
  userchoose = userTraining.(userList{i});
  txt = jsonencode(userchoose);
  fileID = fopen([savePath userList{i} ext],'wt');
  fprintf(fileID,txt);   
end







