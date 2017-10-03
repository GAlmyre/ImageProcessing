%% Initialize the texture and useful values
%pkg load image;
InputText = im2double(imread('text1.jpg'));
[h, w, c] = size(InputText);
OutputText = zeros(h, w, c);
FillingMask = zeros(h, w);
dilateElement = strel('square', 3);
seedSize = 63;
seedHalfSize = floor(seedSize/2);
patchSize = 9;

%% Get a random 3*3 patche from the sample image

x = randi([1 h-seedSize], 1);
y = randi([1 w-seedSize], 1);
RandomPatch = InputText(x:x+seedSize-1, y:y+seedSize-1, :);

%% copy the patch at the center of the outputText

OutputText(h/2-seedHalfSize:h/2+seedHalfSize, w/2-seedHalfSize:w/2+seedHalfSize, :) = RandomPatch;

FillingMask(find(OutputText(:,:,1)+OutputText(:,:,2)+OutputText(:,:,3))) = 1;
patchHalfSize = floor(patchSize/2);

% we add padding to the mask to handle borders
paddedFillingMask = padarray(FillingMask, [patchHalfSize, patchHalfSize]);
OutputText = padarray(OutputText, [patchHalfSize, patchHalfSize]);
Layer = imdilate(FillingMask, dilateElement) - FillingMask;
% Main loop 
while nnz(~FillingMask) > 0

  [x,y] = find(Layer);
  x = x(:,:,:)+patchHalfSize;
  y = y(:,:,:)+patchHalfSize;
  % for every pixel at 1 in the layer
  for it=1:size(x)
      %x(it)-patchHalfSize
      %y(it)-patchHalfSize
    %we create a patch from the outputText
    outputPatch = getPatch(x(it),y(it),patchHalfSize,OutputText);
    patch_mask = getPatch(x(it),y(it),patchHalfSize,paddedFillingMask);
    bestSSD = intmax;
    bestI = 0; 
    bestJ = 0;
    
    % we search the best patch in the input texture
    for i=patchHalfSize + 1:w - patchHalfSize
      for j=patchHalfSize + 1:h - patchHalfSize
        % we get the patch and * by the mask to have zeroes where we don't want the ssd to be relevant
        inputPatch = getPatch(i,j,patchHalfSize,InputText).*patch_mask;
        currentSSD = ssd(inputPatch, outputPatch);
        
        % update the best ssd and indices found if needed
        if currentSSD < bestSSD
          bestSSD = currentSSD;
          bestI = i;
          bestJ = j;
        end
      end
    end
    FillingMask(x(it)-patchHalfSize,y(it)-patchHalfSize) = 1;
    paddedFillingMask(x(it),y(it)) = 1;
    OutputText(x(it),y(it),:) = InputText(bestI,bestJ,:);
      Layer = imdilate(FillingMask, dilateElement) - FillingMask;
    imshow(FillingMask)
  end
end

%we get rid of the borders to display the final image
OutputText = OutputText(1+patchHalfSize:w+patchHalfSize, 1+patchHalfSize:h +patchHalfSize, :);
figure(3);
imagesc(OutputText);