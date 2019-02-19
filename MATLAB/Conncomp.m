function [cc, labels, num] = Conncomp(I, connectivity, V)
%This function is to find the connected components in a 

Iin = I;
I(ismember(Iin,V)) = 1;  % Binarizing the image by using V
I(~(ismember(Iin,V))) = 0;

label_no =1; %Labeling starts from 2
label_list=[[0 0]]; % This list stores the pairs of labels that are connected with each other
                    % and [0 0] is a dummy element

for i = 1: size (I, 1)
    for j = 1 : size (I, 2)
        if (I(i,j)==1)
            if i ~= 1   % Not the first column
                if j~= 1    % i~=1, j~=1 -> Not the top row, not left column
                    up = I(i-1,j);
                    left = I(i,j-1);
                    
                    %Here, we first check for 4-connectivity
                    if (up~=0)
                        I(i,j)=up;
                        if (left~=0 & left <up) % Up and Left (Left<Up)
                            I(i,j)=left;
                            [~,index1] = ismember([left up], label_list,'rows'); % Checking if the pair is already there in label_list
                            [~,index2] = ismember([up left], label_list,'rows');
                            if( (index1 == 0) & (index2 == 0))
                                label_list= vertcat(label_list,[left , up]);
                            end
                        elseif  (left~=0 & left > up) %Up and Left (Left>Up)
                            I(i,j)= up;
                            [~,index1] = ismember([left, up], label_list,'rows');   % Checking if the pair is already there in label_list
                            [~,index2] = ismember([up, left], label_list,'rows');   % Checking if the pair is already there in label_list
                            if( (index1 == 0) & (index2 == 0))
                                label_list= vertcat(label_list,[up , left]);
                            end
                            
                        elseif left~=0  % Only left
                            I(i,j)=left;
                        end
                    
                    elseif(left ~=0)  %Only left is nonzero or both left and up are equal and nonzero
                        I(i,j)= left;
                        %label_list =label_list;%label_list will not change here;
                        
                    elseif(connectivity == 4) % None (from left and up) for 4-connectivity
                        label_no=label_no+1;
                        I(i,j)=label_no; 
                        
                    end
                    if (connectivity == 8)  %8-connectivity
                        if (j~=size(I,2))  % Not the last column
                            tl = I(i-1,j-1);    % tl = top left value
                            tr = I(i-1,j+1);    % tr = top right value
                            if (tl ~=0 & tr ~=0)    % Top Left and Top Right are both nonzero
                                if (I(i,j) == 1) % I(i,j) has no label assigned yet (from top and left)
                                    I(i,j) = min([tl, tr]); % Taking the minimum of the labels
                                    if(tr ~= tl)    %If yes, then, we will add this pair to label_list
                                        [~,index1] = ismember([tl, tr], label_list,'rows'); % Checking if the pair is already there in label_list
                                        [~,index2] = ismember([tr, tl], label_list,'rows');
                                        if( (index1 == 0) & (index2 == 0))
                                            label_list = vertcat(label_list,[tl,tr]);
                                        end
                                    end
                                    I(i,j) = min([tl, tr]);
                                elseif(I(i,j) > 1) % I has been assigned a label already
                                    if  (I(i,j) ~= tr)  % Checking with top right
                                        [~,index1] = ismember([tr, I(i,j)], label_list,'rows'); % Checking if the pair is already there in label_list
                                        [~,index2] = ismember([I(i,j), tr], label_list,'rows');
                                        if( (index1 == 0) & (index2 == 0))
                                            label_list = vertcat(label_list, [tr,I(i,j)]);
                                        end
                                    end
                                    if  (I(i,j) ~= tl)  % Checking with top left
                                        [~,index1] = ismember([tl, I(i,j)], label_list,'rows'); % Checking if the pair is already there in label_list
                                        [~,index2] = ismember([I(i,j), tl], label_list,'rows');
                                        if( (index1 == 0) & (index2 == 0))
                                            label_list = vertcat(label_list, [tl,I(i,j)]);
                                        end
                                    end
                                    I(i,j) = min([tl, tr, I(i,j)]);
                                end
                                
                            elseif(tl ~=0)  % Top Left is nonzero and top right is zero
                                if (I(i,j) == 1) %I(i,j) has no label assigned yet
                                    I(i,j) = tl;
                                    % no change required for label_list
                                elseif(I(i,j) > 1 & I(i,j) ~= tl) % I has already been assigned a label
                                    [~,index1] = ismember([tl, I(i,j)], label_list,'rows'); % Checking if the pair is already there in label_list
                                    [~,index2] = ismember([I(i,j), tl], label_list,'rows');
                                    if( (index1 == 0) & (index2 == 0))
                                        label_list= vertcat(label_list,[ tl , I(i,j)]);
                                    end
                                    I(i,j) = min([tl, I(i,j)]);
                                end
                                
                            elseif(tr ~=0)  %Top Right is nonzero and top left is zero
                                if (I(i,j) == 1) %I(i,j) has no label assigned yet
                                    I(i,j) = tr;
                                    % label_list = label_list => no change required 
                                elseif(I(i,j) > 1 & I(i,j) ~= tr) % I has already been assigned a label
                                    [~,index1] = ismember([tr, I(i,j)], label_list,'rows'); % Checking if the pair is already there in label_list
                                    [~,index2] = ismember([I(i,j), tr], label_list,'rows');
                                    if( (index1 == 0) & (index2 == 0))
                                        label_list =vertcat(label_list,[tr, I(i,j)]);
                                    end
                                    I(i,j) = min([tr, I(i,j)]);
                                    
                                end
                            else    % There are no surrounding nonzero pixels of interest
                                if (I(i,j) == 1)    % I has not been assigned a label yet
                                    label_no = label_no + 1;
                                    I(i,j) = label_no;
                                    % No change for label_list 
                                end
                                %Otherwise, it has has already been assigned a
                                %label from its 4-neighbours of interest
                            end
                            
                          
                        else    % Last Column => there is no top right pixel
                            tl = I(i-1,j-1);
                            if(tl ~=0)  %Top Left is nonzero
                                if (I(i,j) == 1) %I(i,j) has no label assigned yet
                                    I(i,j) = tl;
                                    % No change for label_list
                                elseif(I(i,j) > 1  & I(i,j) ~= tl) % I has already been assigned a label
                                    [~,index1] = ismember([tl, I(i,j)], label_list,'rows'); % Checking if the pair is already there in label_list
                                    [~,index2] = ismember([I(i,j), tl], label_list,'rows');
                                    if( (index1 == 0) & (index2 == 0))
                                        label_list = vertcat(label_list,[tl , I(i,j)]);
                                    end
                                    I(i,j) = min([tl, I(i,j)]);
                                    
                                end
                            else    % There are no surrounding nonzero pixels of interest
                                if (I(i,j) == 1)    % I has not been assigned a label yet
                                    label_no = label_no + 1;
                                    I(i,j) = label_no;
                                    % No change for label_list
                                end
                                %Otherwise, it has has already been assigned a
                                %label from its 4-neighbours of interest
                            end
                        end
                    end
%---------------------------------------------------------                    
                else    % First Column without top left corner (i ~= 1, j = 1)  => Left pixel and top left pixel are not there
                    up = I (i-1,j);
                    if (up~=0)
                        I(i,j)= up;
%                       %No change to label_list
                    elseif( connectivity == 4)
                        label_no =label_no+1;
                        I(i,j)= label_no;
                    end
                    
                    if (connectivity == 8)
                        tr = I(i-1, j+1);
                        if(tr ~=0)  %Top Right is nonzero
                            if (I(i,j) == 1) %I(i,j) has no label assigned
                                I(i,j) = tr;
                                % No change to label_list
                            elseif(I(i,j) > 1 & I(i,j) ~= tr) % I has already been assigned a label
                                [~,index1] = ismember([tr, I(i,j)], label_list,'rows'); % Checking if the pair is already there in label_list
                                [~,index2] = ismember([I(i,j), tr], label_list,'rows');
                                if( (index1 == 0) & (index2 == 0))
                                    label_list= vertcat(label_list,[tr, I(i,j)]);
                                end
                                I(i,j) = min([tr, I(i,j)]);
                                % No change to label_list
                            end
                        else    % There are no surrounding nonzero pixels of interest
                            if (I(i,j) == 1)    % I has not been assigned a label yet
                                label_no = label_no + 1;
                                I(i,j) = label_no;
%                                 label_list = 0; New label No need
                            end
                            %Otherwise, it has has already been assigned a
                            %label from its 4-neighbours of interest 
                        end
                    end   
                end
        %------
            else    % First Row ( i = 1 )
                if(j~=1)    % Not first pixel/column
                    left = I(i,j-1);
                    if (left ~=0)
                        I(i,j)=left;
                        % No change for label_list
                    else 
                        label_no =label_no+1;
                        I(i,j)=label_no;
                        % No change for label_list
                    end
                    
                else    % First row and 1st column => first pixel
                    label_no =label_no+1;   % Label becomes 2
                    I(i,j)= label_no;
                    % No change for label_list
                end
                
            end
        end
    end
end

B = I;

ll = label_list(2:size(label_list,1),:);    % Removing the dummy element
    % Now, ll will store the equivalent labels

A = zeros(1,label_no);
A_start = zeros(1,label_no);    % Stoing the initial form of A
flags = zeros(1,label_no);      % flags stores data about whether a label has already occured earlier
                                % flag(n): 1 - means n occured earlier, 0 - means has not occurred
                                
for i = 1:size(ll,1)
    n1 = ll(i,1);
    n2 = ll(i,2);
    
    if (flags(n1) == 0 & flags(n2) == 0)    % n1 and n2 have not occurred earlier
        flags(n1) = 1;
        flags(n2) = 1;
        if (size(A) == size(A_start) & A(1,1) == 0) % Checking whether A has changed yet (at least once) or not
            A = [n1, n2, zeros(1, label_no-2)];
        else
            A = vertcat(A, [n1, n2, zeros(1, label_no-2)]); % Adding a new set/class of connected components
        end
        
        
    elseif (flags(n1) == 1 & flags(n2) == 0)    % Only n1 has occurred earlier
        flags(n2) = 1;
        for j = 1:size(A,1)
            if (any(A(:) == n1))
                for k = 1:size(A,2)
                    if (A(j,k) == 0)
                        A(j,k) = n2;
                        break
                    end
                end
                break
            end
        end
        
    elseif (flags(n1) == 0 & flags(n2) == 1)    % Only n2 has occurred earlier
        flags(n1) = 1;
        for j = 1:size(A,1)     % This for loop is to add n1 to the end of the row (set/class) containing n2
            if (any(A(:) == n2))
                for k = 1:size(A,2)
                    if (A(j,k) == 0)
                        A(j,k) = n1;
                        break
                    end
                end
                break
            end
        end
    
    else    % Both n1 and n2 have occurred earlier
        c = 0;
        r1 = -1;
        r2 = -1;
        for j = 1:size(A,1)     % This for loop is to find the positions of n1 and n2 in A
            if ( (any(A(:) == n1)) & (r1 ~= -1) )
                r1 = j;
                c = c + 1;
                if (c == 2)
                    break
                end
            end
            if (  (any(A(:) == n2))  & (r1 ~= -1) )
                r2 = j;
                c = c + 1;
                if (c == 2)
                    break
                end
            end
        end
        
        if(r1 ~= r2)
            m1 = min([r1, r2]);
            m2 = max([r1, r2]);
            c = 1;
            zeroflag = 0;   % This is used to find where a row ends and the rest of the entries
                            % in that row are zero
            for j = 1:size(A,2)
                if (zeroflag == 0 & A(m1, j) == 0)
                    zeroflag = 1;
                    if(~(any(A(m1,:) == A(m2,c))))
                        A(m1,j) = A(m2,c);
                    end
                    A(m2,c) = 0;
                    c = c + 1;
                elseif (zeroflag == 1)
                    if A(m2,c) == 0
                        break
                    end
                    if(~(any(A(m1,:) == A(m2,c))))
                        A(m1,j) = A(m2,c);
                    end
                    A(m2,c) = 0;
                    c = c + 1;
                end
                
            end
        end
    end        
end


Amin = A(:,1);     % First column of A

% This for loop re-labels all the labels to the minimum of its connected label group 
for i = 1:size(A,1)
    if (Amin(i) ~= 0)
        for j = 1:size(A,2)
            if (A(i,j) == 0)
                break
            elseif (A(i,j) < Amin(i))
                Amin(i) = A(i,j);
            end
        end
    end
end

cc = B;
labels = Amin';
for i = 1:size(cc,1)
    for j = 1:size(cc,2)
        val = cc(i,j);
        if (val ~= 0)
            found_flag = 0;
            for k = 1:size(A,1)
                if (any( A(k,:) == val))
                    cc(i,j) = Amin(k);
                    found_flag = 1;
                    break
                end
            end
            if ( (found_flag == 0) & (~(ismember(labels,val )))  )
                labels = [labels, val];
            end
        end
    end
end

%R = A(:,1:10);
label_list = label_list;
s = size(label_list);
Amin = Amin;
B = B;
labels = sort(labels);
num = size(unique(labels),2);
end