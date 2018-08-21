function [img] = recmedfilt2(img,mask)
%RECMEDFILT2 Summary of this function goes here
%   Detailed explanation goes here
    m=mask;
    im=mask(1);
    jm=mask(2);
    if(~ismatrix(img))
        img=rgb2gray(img);
    end
    tic;
    while(~isempty(find(img==0, 1)))
        for i=1:size(img,1)
            for j=1:size(img,2)
               if(img(i,j)==0)
                   count=0;
                   sum=0;
                   for ii=max(1,i-im):min(size(img,1),i+im)
                       for jj=max(1,j-jm):min(size(img,2),j+jm)
                           if(img(ii,jj)>0)
                               sum=sum+uint64(img(ii,jj));
                               count=count+1;
                           end
                       end
                   end
                   img(i,j)=round(sum/count);
               end
            end
        end
    end
    disp(toc);
end

