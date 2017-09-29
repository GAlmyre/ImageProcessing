Image1 = imread('test.png');
Image2 = imread('text1.jpg');

%% Get 4 random 9*9 patches drom an image
[h, w, c] = size(Image2);
Patch = Image2(1:9, 1:9, :);

for i=1:1:4                 
    x = randi([1 h-9], 1);
    y = randi([1 w-9], 1);
    figure(i)
    RandomPatch = Image2(x:x+9, y:y+9, :);
    imagesc(RandomPatch); 
    imwrite(RandomPatch, strcat('RandomPatch', num2str(i)), 'PNG');
end

%% Compute the similarities between the patches
