%% Initialize the texture and useful values
%pkg load image;
InputText = im2double(imread('text1_inpainting.png'));
[h, w, c] = size(InputText);
OutputText = zeros(h, w, c);
FillingMask = zeros(h, w);
InpaintingMask = zeros(h,w);
dilateElement = strel('square', 3);
patchSize= 9;

FillingMask(find(sum(InputText, 3))) = 1;
InpaintingMask(find((sum(InputText, 3)))==0) = 1;
imshow(InpaintingMask);

% we add padding to the mask to handle borders
FillingMask = padarray(FillingMask, [patchHalfSize, patchHalfSize]);
OutputText = padarray(OutputText, [patchHalfSize, patchHalfSize]);
InputText = padarray(InputText, [patchHalfSize, patchHalfSize]);

