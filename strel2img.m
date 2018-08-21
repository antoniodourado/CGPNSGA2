function [out] = strel2img(se,img)
%STREL2IMG Summary of this function goes here
%   Detailed explanation goes here
    sen=se.Neighborhood;
    out=repmat(sen,floor(size(img,1)/size(sen,1)),floor(size(img,2)/size(sen,2)));
    coldiff=size(img,2)-size(out,2);
    lindiff=size(img,1)-size(out,1);
    if(coldiff > 0)
        out=[out zeros(size(out,1),coldiff)];
        out(:,end-coldiff+1:end)=out(:,1:coldiff);
    end
    if(lindiff > 0)
        out=[out; zeros(lindiff,size(out,2))];
        out(end-lindiff+1:end,:)=out(1:lindiff,:);
    end
end