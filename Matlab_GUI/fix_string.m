temp = '1    2    3    4    5    6    7    8    9   10   11   12   13   14 16   18   20   24   29   37   53   88  278';

len = length(temp);
tempA = []; newA  = [];
counter = 1;
for i = drange(1, len)
   if(temp(i) ~= ' ')
       tempA = [tempA, temp(i)];
   else
       if(length(tempA) > 0)
           newA(counter) = tempA;
           tempA = [];
           counter = counter + 1;
       end
   end
end
len = length(newA);
final(len + 1) = tempA;

