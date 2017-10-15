function output = computeFromOffset(input, offsetMap, patchSize)
  
  [h,w,c] = size(offsetMap);
  for i = 1:h
    for j = 1:w
      output(i,j,:) = input(offsetMap(i,j,1),offsetMap(i,j,2),:);
    end
  end
  
end