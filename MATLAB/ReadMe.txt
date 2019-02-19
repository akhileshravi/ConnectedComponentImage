Conncomp.m
[cc, labels, num] = concompf_upd_new(I, connectivity, V)

This function is used to find the connected components in an image based on 4-connectivity or 8-connectivity and label the connected components.

Input:
I - Greyscale image - 2D M x N matrix
connectivity - 4 or 8 should be the input
V - Set of foreground intensity values (all values not in this list will be considered as the background)

Output:
cc - Matrix depicting connected components
labels - List of labels in cc matrix
num - Number of connected components


timecheck.m
[I1, labels, num, I2, CC, t1, t2] = timecheck(I, connectivity, V)

Used to compare the time between Conncomp and bwconncomp.

I, connectivity, V -> same as the parameters for Conncomp

I1, labels, num -> same as outputs for Conncomp
CC - Output of bwconncomp
I2 - Output of labelmatrix
t1 - Time taken for Conncomp
t2 - Time taken for bwconncomp