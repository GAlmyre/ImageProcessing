function patch = getPatch(i, j, halfSize, image)
  
  patch = image(i-halfSize:i+halfSize, j-halfSize:j+halfSize, :);
  
endfunction