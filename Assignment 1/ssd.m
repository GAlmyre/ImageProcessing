function ssd = ssd(patch1, patch2)
  
  %ssd = sum((patch1-patch2).^2);
  ssd = sum(sum(sum((patch1 - patch2).^2)));
  
endfunction
