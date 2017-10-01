%% Initialize the texture and useful values
pkg load image;
InputText = im2double(imread('text1.jpg'));
%InputText = imread('text1.jpg');
[h, w, c] = size(InputText);
OutputText = zeros(h, w, c);
FillingMask = zeros(h, w);
dilateElement = strel("square", 3);
seedSize = 3;
patchSize = 9;

%% Get a random 3*3 patche from the sample image

x = randi([1 h-seedSize], 1);
y = randi([1 w-seedSize], 1);
figure(1)
RandomPatch = InputText(x:x+seedSize-1, y:y+seedSize-1, :);
imagesc(RandomPatch); 
imwrite(RandomPatch, 'RandomPatch', 'PNG');

%% copy the patch at the center of the outputText

OutputText(h/2-1:h/2+1, w/2-1:w/2+1, :) = RandomPatch;
figure(2)
imagesc(OutputText);
imwrite(OutputText, 'OutputText', 'PNG');

FillingMask(find(OutputText(:,:,1)+OutputText(:,:,2)+OutputText(:,:,3))) = 1;
patchHalfSize = floor(patchSize/2);

% we add padding to the mask
FillingMask = padarray(FillingMask, [patchHalfSize, patchHalfSize]);
OutputText = padarray(OutputText, [patchHalfSize, patchHalfSize]);

% Main loop 
%while
Layer = imdilate(FillingMask, dilateElement) - FillingMask;
[x,y] = find(Layer);

for i = 2:size(InputText(1)-1)
  for j = 2:size(InputText(2)-1)
  Spatch = getPatch(i, j, 3, InputText);
  Tpatch = getPatch(x, y, 3, OutputText);
  ssd = ssd(Spatch, Tpatch);
  endfor
endfor
%% while the image is not filled
%while(find(FillingMask))
%end
