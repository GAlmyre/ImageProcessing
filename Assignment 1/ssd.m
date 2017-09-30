function ssd = ssd(patch1, patch2)
  
  [x,y] = find(patch2(:,:,1).+patch2(:,:,2).+patch2(:,:,3))
  
  ssd = sum((patch1(x,y,1)-patch2(x,y,1)).^2) + sum((patch1(x,y,2)-patch2(x,y,2)).^2) + sum((patch1(x,y,3)-patch2(x,y,3)).^2);
  
endfunction
