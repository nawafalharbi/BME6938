I=imread('C:\Users\nawafalharbi\Desktop\04_g.jpg');

output=Mean_Shift_Main(I,5,14,3);

%%%%claculate dice coffiecnt %%%

dice = 2*nnz(output&I)/(nnz(output)+nnz(I));
disp(dice)