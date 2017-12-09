% 11-30-17 - JRE added code to position the figures in a 3x4 matrix 
% Parallel version (needs toolbox)
% Be sure to be in the cwd with Settings and the following
spikeFramesFile = 'Squeaky 100917 unit 2.txt';
PrimaryFramePtsFile = 'PrimaryFramePts_9292017_1327.txt';
SecondaryFramePtsFile = 'SecondaryFramePts_9292017_1327.txt';
%%%I. From unit text Format
spikeFormat =['%f %f %f %d %f %f %f %f %f %f %f %f\n'];
%spikes[:,1] = frames time
%spikes[:,2] = spike time
%spikes[:,3] = lag time
%spikes[:,4] = frame index
%spikes[:,5] = HeR
%spikes[:,6] = VeR
%spikes[:,7] = HeL
%spikes[:,8] = VeL
%spikes[:,9] = HT
%spikes[:,10] = VT
%spikes[:,11] = shL
%spikes[:,12] = shR
fileID = fopen(spikeFramesFile,'r');
spikes =[];
while ~feof(fileID)
    line = fgets(fileID);
    [holder,n,errmsg] =sscanf(line, spikeFormat);
    spikes = [spikes; holder'];
end
fclose(fileID);


%Load Settings and Points
fileID = fopen('Settings.txt','r');
line = fgets(fileID);
holder =sscanf(line, '%f');
line = fgets(fileID);
stimWidth =sscanf(line, '%f');
line = fgets(fileID);
minDist =sscanf(line, '%f');
line = fgets(fileID);
numLightCount =sscanf(line, '%f');
line = fgets(fileID);
numDarkCount =sscanf(line, '%f');
line = fgets(fileID);
seed =sscanf(line, '%f');
fclose(fileID);

% %Load Frame points
pointsFormat = '%f,%f;';
tic
for i = 1:2
   if i ==1
       PrimaryFramePts =readFramePts(PrimaryFramePtsFile,pointsFormat,numLightCount);
   else
       SecondaryFramePts = readFramePts(SecondaryFramePtsFile,pointsFormat,numDarkCount);
   end
end
toc




%Ivb. Imgs (Pri/Sec)(R/L)Eye(R/L/No)Shutter
img = zeros(110,148);
imgPriREyeLShutter =img;
imgPriREyeNoShutter =img;
imgPriLEyeRShutter =img;
imgPriLEyeNoShutter =img;
imgSecREyeLShutter =img;
imgSecREyeNoShutter =img;
imgSecLEyeRShutter =img;
imgSecLEyeNoShutter =img;
countREyeLShutter=0;
countREyeNoShutter=0;
countLEyeRShutter=0;
countLEyeNoShutter=0;
tic
for i=1:length(spikes)
    frameNum =spikes(i,4);
    imgPriDilated = getImFrame(PrimaryFramePts,frameNum,stimWidth);
    imgSecDilated = getImFrame(SecondaryFramePts,frameNum,stimWidth);
    if(spikes(i,9)>0)%right Eye
        if(spikes(i,11)==0)%left shuttered
            imgPriREyeLShutter = imgPriDilated+imgPriREyeLShutter;
            imgSecREyeLShutter = imgSecDilated+imgSecREyeLShutter;
            countREyeLShutter = countREyeLShutter+1;
        else %No Shutter
            imgPriREyeNoShutter = imgPriDilated+imgPriREyeNoShutter;
            imgSecREyeNoShutter = imgSecDilated+imgSecREyeNoShutter;
            countREyeNoShutter = countREyeNoShutter+1;
        end
    else    %  left Eye
       if(spikes(i,12)==0)%Right shuttered
            imgPriLEyeRShutter = imgPriDilated+imgPriLEyeRShutter;
            imgSecLEyeRShutter = imgSecDilated+imgSecLEyeRShutter;
            countLEyeRShutter = countLEyeRShutter+1;
        else %No Shutter
            imgPriLEyeNoShutter = imgPriDilated+imgPriLEyeNoShutter;
            imgSecLEyeNoShutter = imgSecDilated+imgSecLEyeNoShutter;
            countLEyeNoShutter = countLEyeNoShutter+1;
        end 
    end
end
toc
%Show images 
fig1 =imtool(imgPriREyeNoShutter,[min(min(imgPriREyeNoShutter)) max(max(imgPriREyeNoShutter))]);
fig2 =imtool(imgPriREyeLShutter,[min(min(imgPriREyeLShutter)) max(max(imgPriREyeLShutter))]);
fig3 =imtool(imgPriLEyeNoShutter,[min(min(imgPriLEyeNoShutter)) max(max(imgPriLEyeNoShutter))]);
fig4 =imtool(imgPriLEyeRShutter,[min(min(imgPriLEyeRShutter)) max(max(imgPriLEyeRShutter))]);
fig5 =imtool(imgSecREyeNoShutter,[min(min(imgSecREyeNoShutter)) max(max(imgSecREyeNoShutter))]);
fig6 =imtool(imgSecREyeLShutter,[min(min(imgSecREyeLShutter)) max(max(imgSecREyeLShutter))]);
fig7 =imtool(imgSecLEyeNoShutter,[min(min(imgSecLEyeNoShutter)) max(max(imgSecLEyeNoShutter))]);
fig8 =imtool(imgSecLEyeRShutter,[min(min(imgSecLEyeRShutter)) max(max(imgSecLEyeRShutter))]);

%Average Images together
primary=255;
secondary=0;
background =125;
high =primary - background;
low = secondary-background;

% avgREyeLShutter = (((imgPriREyeLShutter*high)+(imgSecREyeLShutter*low))/countREyeLShutter)+background;
% avgREyeNoShutter = (((imgPriREyeNoShutter*high)+(imgSecREyeNoShutter*low))/countREyeNoShutter)+background;
% avgLEyeRShutter = (((imgPriLEyeRShutter*high)+(imgSecLEyeRShutter*low))/countLEyeRShutter)+background;
% avgREyeNoShutter = (((imgPriLEyeNoShutter*high)+(imgSecLEyeNoShutter*low))/countLEyeNoShutter)+background;

high =1;
low=-1;
addREyeLShutter = (((imgPriREyeLShutter*high)+(imgSecREyeLShutter*low)))+background;
addREyeNoShutter = (((imgPriREyeNoShutter*high)+(imgSecREyeNoShutter*low)))+background;
addLEyeRShutter = (((imgPriLEyeRShutter*high)+(imgSecLEyeRShutter*low)))+background;
addLEyeNoShutter = (((imgPriLEyeNoShutter*high)+(imgSecLEyeNoShutter*low)))+background;

fig9 =imtool(addREyeNoShutter,[min(min(addREyeNoShutter)) max(max(addREyeNoShutter))]);
fig10 =imtool(addREyeLShutter,[min(min(addREyeLShutter)) max(max(addREyeLShutter))]);
fig11 =imtool(addLEyeNoShutter,[min(min(addLEyeNoShutter)) max(max(addLEyeNoShutter))]);
fig12 =imtool(addLEyeRShutter,[min(min(addLEyeRShutter)) max(max(addLEyeRShutter))]);

set (fig1,'Position',[100 314 470 128]);
set (fig2,'Position',[100 526 470 128]);
set (fig3,'Position',[100 738 470 128]);
set (fig4,'Position',[100 950 470 128]);
set (fig5,'Position',[571 314 470 128]);
set (fig6,'Position',[571 526 470 128]);
set (fig7,'Position',[571 738 470 128]);
set (fig8,'Position',[571 950 470 128]);
set (fig9,'Position',[1042 314 470 128]);
set (fig10,'Position',[1042 526 470 128]);
set (fig11,'Position',[1042 738 470 128]);
set (fig12,'Position',[1042 950 470 128]);



