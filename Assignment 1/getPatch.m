function patch = getPatch(i, j, patchSize, image)
  
  halfSize = floor(patchSize/2)
  patch = image(i-halfSize:i+halfSize, j-halfSize:j+halfSize, :);
  
endfunction