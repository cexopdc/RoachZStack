function amps = get_amp_vals()
    dn = 0:1:255;
    Rg = (100000)*dn./256 + 180;
    A  = 3000./Rg;
    
    

    idx = 1; size = length(A);
    while(idx < 256)
       if((A(idx) > 2) || (A(idx) < 0.05))
           A(idx) = '';
           size = size - 1;
       if idx == size
               break;
       end
       else
           idx = idx + 1;
       end
    end
    A = num2str(A,' %0.3f');    
    amps = regexp(A, ' ', 'split'); % Changed to fit MATLAB R2012a
%     A = num2str(A);
%    A = strsplit(A, ' ');
%    A = remove_dups(A);
%     amps = A;
end

