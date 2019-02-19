function [I1, labels, num, I2, CC, t1, t2] = timecheck(I, connectivity, V)


tic
CC = bwconncomp(I, connectivity);
I2 = labelmatrix(CC);
t2 = toc;

tic;
[I1, labels, num] = Conncomp(I, connectivity, V);
t1 = toc;

end