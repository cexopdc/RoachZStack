
function seq = remove_dups(seq)

idx = 1;
size = length(seq);

while(idx < size)
    
   if seq(idx) == seq(idx+1)
       seq(idx+1) = '';
       size = size - 1;
   else
       idx = idx+1;
   end
end
end
