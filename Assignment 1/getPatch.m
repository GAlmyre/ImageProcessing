function patch = getPatch(i, j, patchSize, image)
  
  halfSize = floor(patchSize/2)
  if (i > halfSize && j > halfSize && i < size(image(1)-1) && j < size(image(2)-1))
    patch = image(i-halfSize:i+halfSize, j-halfSize:j+halfSize, :);
  else
    patch = zeros(size(image));
  endif
  
endfunction