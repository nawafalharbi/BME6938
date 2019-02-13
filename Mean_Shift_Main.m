%%% implementing means shift image segmentation %%%%
function output = Mean_Shift_Main(input_image,Hs,Hr,Th)
%inputs 
% Hs>> spatial range as window for computing (spatial bandwith) %WITHIN HOW
% MANY NEIGHBORS.
% Hr>>  RGB range (color bandwith)
%Th>> threshold for convergance %WITHIN HOW MANY PIXELS WE WANT TO PUT
%THRESHOLD FOR CONVERGANCE 
%output >> segmented image 
input1=input_image;
input=input1;
%%%%% get color histogram of image %%%%%%%%%%
I=input;
nbins=10;  % number of bins for histogram
H1=zeros([nbins nbins nbins ]);  % creat empthy matrix to store histogram values. 
ct=0;    % counter intialiaztion 
for i=1:size(I,1)
    for j=1:size(I,2)
        p=double(reshape(I(i,j,:),[1 3]));  % get the pixels of image 
        p=floor(p/(256/nbins))+1;        %normalize it to nbins and rgb 256
        ct=ct+1;
        H1(p(1),p(2),p(3))= H1(p(1),p(2),p(3))+1;
        
    end 
end 
H1=H1(:); 
H1=H1./sum(H1);                      % calculate the normalized H1
                                       %by dividing by the sum of counts in
                                       %all the bins of H1
H_all=reshape(H1,[nbins,nbins,nbins]);  %histogram values of all R,G,B colors 
%%%% mean shift %%%%%%%%%%%%
H=size(input,1); % hieht of image 
W= size(input,2); % width of image 
output=input;
tic % clculate computation time
for i=1:H
    for j=1:W
     p_y=i;
     p_x=j; 
     r1=p_x-Hs; r2=p_x+Hs;       %rows of spatial bandwith in both direction x&y
     c1=p_y-Hs; c2=p_y+Hs;       % coloums of spatial bandwith in both direction x&y
        %%% chech boundries for region %%%%   
     if (r1<1)r1 =1; end 
     if (c1<1)c1 =1; end
     if (r2<H)r2 =H; end
     if (c2<W)c2 =W; end 
     
     R=input(p_y,p_x,1);    %partition R, G , B color spatial coordinates 
     G=input(p_y,p_x,2);
     B=input(p_y,p_x,3);
     factor=256/nbins;   %normaliaze it to nbins and image bytes 256;
     bin_r=ceil(double(R)/factor);
     bin_g=ceil(double(G)/factor);
     bin_b=ceil(double(B)/factor);
     old_bins= [bin_r bin_g bin_b ];    % stor old bins;
     
     dist = Th+1;
     while (dist>Th)
     
     hr=min(nbins,(bin_r+Hr));lr=max(1,(bin_r-Hr));
     hg=min(nbins,(bin_g+Hr));lg=max(1,(bin_g-Hr));
     hb=min(nbins,(bin_b+Hr));lb=max(1,(bin_b-Hr));
     s_r=0;s_g=0; s_b=0;    %intilaition for 
     weigth=0;     
     for k=lr:hr
         for l=lg:hg
             for m= lb:hb
             s_r=s_r+k*H_all(k,l,m);
             s_g=s_g+l*H_all(k,l,m);     %loop over to fill spatial coordinates of R,G,B based on H_all histogram bins;
             s_b=s_b+m*H_all(k,l,m);
             weigth=weigth+H_all(k,l,m);   %weclaculate the wheigthed mean of the histogram
             end 
         end 
     end 
     s_r=s_r/weigth;   %normalize it to weigth;
     s_g=s_g/weigth;   
     s_b=s_b/weigth;
     rd=(s_r-bin_r);
     gd=(s_g-bin_g);
     bd=(s_b-bin_b);
     dist=sqrt(rd^2+gd^2+bd^2);  %calculate distance for R,G,B coordinates 
     bin_r=round(s_r);
     bin_g=round(s_g);
     bin_b=round(s_b);     
     end 
     %%%%%%%compute color to be assigned 
     color_r=bin_r*(256/nbins);
     color_g=bin_g*(256/nbins);
     color_b=bin_b*(256/nbins);
     output(i,j,1)=color_r;
     output(i,j,2)=color_g;
     output(i,j,3)=color_b;
    end 
end 
fprintf('\n time of meanshipft computation=%f',toc);
figure(1),subplot(1,2,1), imshow(input);title('origional image');
subplot(1,2,2),imshow(output); title('segmented image');
     
     
     


        
