function [rimg1,rimg2] = imgalign(f1,f2,iter)

imgCell = cell(iter,2);
imgCell{iter,1} = imread (f1);
imgCell{iter,2} = imread (f2);
for i = 1:iter-1;
    imgCell{iter-i,1} = imresize(imgCell{iter-i+1,1},0.5);
    imgCell{iter-i,2} = imresize(imgCell{iter-i+1,2},0.5);
end
% imgCell(1,n) is the smallest, (5,n) is the biggest 
mh = 0;
mw = 0;
% mh : movement in height direction, mw : movement in width direction
% according to the result of smaller img, move the bigger img to a new initial
% place.

for i = 1:iter;
    mh = 2 * mh;
    mw = 2 * mw;
    imgCell{i,2} = imtranslate(imgCell{i,2},[mh,mw]);
    % [imgCell{i,1},imgCell{i,2}] = cutimg(imgCell{i,1},imgCell{i,2},[mh,mw]);
    gimg1 = rgb2gray(imgCell{i,1});
    gimg2 = rgb2gray(imgCell{i,2});

    thres1 = median(gimg1(:));
    thres2 = median(gimg2(:));
    N = 10;

    bitmap1 = zeros(size(gimg1));
    bitmap2 = zeros(size(gimg2));
    excmap1 = ones(size(gimg1));
    excmap2 = ones(size(gimg2));

    [h w] = size(gimg1);
    for j = 1:h*w ;
        if gimg1(j) > thres1; bitmap1(j) = 1; end;
        if gimg2(j) > thres2; bitmap2(j) = 1; end;
        if gimg1(j) > thres1 - N && gimg1(j) < thres1 + N; excmap1(j) = 0; end;
        if gimg2(j) > thres2 - N && gimg2(j) < thres2 + N; excmap2(j) = 0; end;
    end;
    move = zeros(9,1,2);
    move(1,:) = [-1,-1];
    move(2,:) = [0,-1];
    move(3,:) = [1,-1];
    move(4,:) = [-1,0];
    move(5,:) = [0,0];
    move(6,:) = [1,0];
    move(7,:) = [-1,1];
    move(8,:) = [0,1];
    move(9,:) = [1,1];

    for j = 1:9;
        difference = xor(bitmap1,imtranslate(bitmap2,move(j,:))) & excmap1 & excmap2;
        value(j) = sum(difference(:));
    end
    [minValue,index] = min(value);
    mh = mh + move(index,:,1);
    mw = mw + move(index,:,2);
    imgCell{i,2} = imtranslate(imgCell{i,2},move(index,:));
end
    % [rimg1,rimg2] = cutimg(imgCell{iter,1},imgCell{iter,2},[mh,mw]); 
end

function [r1,r2] = cutimg(img1,img2,m)
    % height lower bound = hlb
    mh = m(1);
    mw = m(2);
    hlb = 1; wlb = 1;
    hub = size(img1,1);
    wub = size(img1,2);
    if mh > 0;
        hlb = hlb + mh;
    end
    if mh < 0;
        hub = hub + mh;
    end
    if mw > 0;
        wlb = wlb + mw;
    end
    if mw < 0;
        wub = wub + mw;
    end
    r1 = img1(hlb:hub,wlb:wub,:);
    r2 = img2(hlb:hub,wlb:wub,:);
end

