function FramePts = readFramePts( fileName, pointsFormat, numCount )
%READFRAMEPTS Summary of this function goes here
%   Detailed explanation goes here
    fileID = fopen(fileName,'r');
    FramePts =[];
    fPtr =1;
    while ~feof(fileID)
        line = fgets(fileID);
        [holder,n,errmsg] =sscanf(line, pointsFormat,[2,numCount]);
        FramePts(fPtr,:,:)=holder';
        fPtr=fPtr+1;
    end
    fclose(fileID);


end

