function imFrame = getImFrame(FramePts, frameNum,stimWidth)
    SE = strel('square',stimWidth);
    fSize = [110,148];
    fCenter =fSize/2;
    img = zeros(110,148);
    for j =1:size(FramePts,2) %For Primary
       if((-fCenter(2)<FramePts(frameNum,j,1))&& ...
               (FramePts(frameNum,j,1)<fCenter(2))&& ...
               (-fCenter(1)<FramePts(frameNum,j,2))&& ...
               (FramePts(frameNum,j,2)<fCenter(1)))
           x=FramePts(frameNum,j,1)+fCenter(2);
           y=FramePts(frameNum,j,2)+fCenter(1);
           img(y,x)=img(y,x)+1; %flipped in images.... 
       end
    end
    imFrame = imdilate(img,SE);
end
