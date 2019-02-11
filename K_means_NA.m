%implementation of k-means image segmentation 

%intailaization 

tic
clc
clear all
close all
%%%% read image to matlab and show its info %%%%%
I=imread('C:\Users\nawafalharbi\Desktop\images\08_dr.jpg');
size(I);

%%%%%% convert image to double precision and get color featurs into matrix M*n*3 %%%%%
I =im2double(I);
F = reshape(I,size(I,1)*size(I,2),3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% K-means%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = 6;                %number of clusters
CENTS = F(ceil(rand(K,1)*size(F,1)) , :);    %generate centroids same size as image 
DAL = zeros(size(F,1),(K+2));                % generate empthy matrix to store distance and labels 
KMI = 7;                                   %number of iteriations 
for n=1:KMI
    for i= 1:size(F,1)
        for j = 1:K
            DAL(i,j)=norm(F(i,:)-CENTS(j,:));
        end 
        [Distance , CN] = min(DAL(i,1:K));        %1:K are distances from cluster centers  
        DAL(i,K+1)= CN;                            % K+1 is cluster label 
        DAL(i,K+2) = Distance;                  % K+2 is minimum Distance 
    end 
    for i = 1:K 
        A = (DAL(:,K+1) == i);                % Cluster K Points
         CENTS(i,:) = mean(F(A,:));            % New Cluster Centers
         if sum(isnan(CENTS(:))) ~= 0                    % If CENTS(i,:) Is Nan Then Replace It With Random Point
         NC = find(isnan(CENTS(:,1)) == 1);           % Find Nan Centers
         for Ind = 1:size(NC,1)
         CENTS(NC(Ind),:) = F(randi(size(F,1)),:);
         end
      end
   end
end
X = zeros(size(F));                     % creat emthpy matrix to store segmented image 
for i = 1:K                              % loop over matrix to fill it with new segmented image numbers 
idx = find(DAL(:,K+1) == i);
X(idx,:) = repmat(CENTS(i,:),size(idx,1),1); 
end
T = reshape(X,size(I,1),size(I,2),3);
%%%%% claculating dice coffiecent
dice = 2*nnz(T&I)/(nnz(T) + nnz(I));
%%%%%%%%%%% show image %%%%%%%%%%%%
figure()
subplot(121); imshow(I); title('original')
subplot(122); imshow(T); title('segmented')
disp('number of segments ='); disp(K)
disp(dice)
disp(toc)
toc