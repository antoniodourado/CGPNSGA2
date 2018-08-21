function [out] = cgpTestImage(img,pop,ind)
%CGPTESTIMAGE Summary of this function goes here
%   Detailed explanation goes here
    global params;
    gt=pop(ind,:);
    if(isequal(params.inputs.colorscheme,'bw') && size(img,3)>1)
        img=imbinarize(rgb2gray(img));
    elseif(isequal(params.inputs.colorscheme,'gray') && size(img,3)>1)
        img=rgb2gray(img);
    end
    inpbackup=params.inputs.input;
    params.inputs.input=img;
    out=funcobj1rec(params.gtsize,gt,params);
    params.inputs.input=inpbackup;
    imshow(out);
end

