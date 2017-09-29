%% Initialize the texture and useful values

InputText = im2double(imread('text1.jpg'));
[h, w, c] = size(InputText);
OutputText = zeros(h, w, c);
FillingMask = zeros(h, w, 1);

PatchSize = 3;
% useful to have a mask image 1 for filled and 0 for not filled
% imdilate
% find function can tell which pixels are 1  find(M-imdilate(M,...)) (a
% square is good for structuring element

%% Get a random 3*3 patche from the sample image

x = randi([1 h-PatchSize], 1);
y = randi([1 w-PatchSize], 1);
figure(1)
RandomPatch = InputText(x:x+PatchSize-1, y:y+PatchSize-1, :);
imagesc(RandomPatch); 
imwrite(RandomPatch, 'RandomPatch', 'PNG');

%% copy the patch at the center of the outputText

OutputText(h/2-1:h/2+1, w/2-1:w/2+1, :) = RandomPatch;
figure(2)
imagesc(OutputText);
imwrite(OutputText, 'OutputText', 'PNG');
FillingMask(find(OutputText(:,:,1)+OutputText(:,:,2)+OutputText(:,:,3))) = 1;

FillingMask = FillingMask-imdilate(FillingMask);

%% while the image is not filled
while(find(FillingMask))
    
end