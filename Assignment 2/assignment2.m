% create image target with pixels from source
 
%pkg load image;
patchSize = 10;
target = im2double(imread('a.png'));
source = im2double(imread('b.png'));

% we create a padded image to handle the borders
padTarget = padarray(target, [patchSize patchSize], 'symmetric');
padSource = padarray(source, [patchSize patchSize], 'symmetric');
[h, w, c] = size(target);
[hS, wS, cS] = size(source);
offsetMap = zeros(h,w,2);

min_i = 2;
max_i = h;
min_j = 2;
max_j = w;

minBound = 1;
maxBound_i = hS;
maxBound_j = wS;

% initialize the offsetMap to random values :
offsetMap(:,:,1) = randi([minBound maxBound_i], [h,w,1]);
offsetMap(:,:,2) = randi([minBound maxBound_j], [h,w,1]);

nbPath = 8;
loopDone = 0;

startI = 0;
startJ = 0;
endI = 0;
endJ = 0;

for k = 1:nbPath

  % scanline order
  if mod(loopDone, 2) == 0
    startI = min_i;
    startJ = min_j;
    endI = max_i;
    endJ = max_j;
    offset = -1;
  % reverse scanline order
  else
    endI = min_i-1;
    endJ = min_j-1;
    startI = max_i-1;
    startJ = max_j-1;
    offset = +1;
  end

  for i = startI:-offset:endI
    for j = startJ:-offset:endJ

      x = min(maxBound_i, max(minBound, offsetMap(i,j,1)));
      y = min(maxBound_j, max(minBound, offsetMap(i,j,2)));
      
      % compute the SSD of the current patch
      currentPatch = getPatch(i+patchSize,j+patchSize,patchSize,padTarget);
      currentCandidate = getPatch(x+patchSize,y+patchSize,patchSize,padSource);
      bestSSD = ssd(currentPatch, currentCandidate);

      % compute the SSD of the top or bottom candidate
      
      x = min(maxBound_i, max(minBound,offsetMap(i+offset,j,1)-offset));
      y = min(maxBound_j, max(minBound,offsetMap(i+offset,j,2)));
      topOrBottomCandidate = getPatch(x+patchSize,y+patchSize,patchSize,padSource);
      testSSD = ssd(currentPatch, topOrBottomCandidate);
      if testSSD < bestSSD
        offsetMap(i,j,1) = x;
        offsetMap(i,j,2) = y;
        bestSSD = testSSD;
      end
      
      % compute the SSD of the left  or right candidate
      x = min(maxBound_i, max(minBound,offsetMap(i,j+offset,1)));
      y = min(maxBound_j, max(minBound,offsetMap(i,j+offset,2)-offset));
      leftOrRightCandidate = getPatch(x+patchSize,y+patchSize,patchSize,padSource);
      testSSD = ssd(currentPatch, leftOrRightCandidate);
      if testSSD < bestSSD
        offsetMap(i,j,1) = x;
        offsetMap(i,j,2) = y;
        bestSSD = testSSD;
      end
    end
  end
% reconstruct the image for each iteration
loopDone = loopDone+1;
output = computeFromOffset(source, offsetMap, patchSize);
imshow(output);
end



