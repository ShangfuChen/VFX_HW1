%% Input image
height = 768;
width = 1024;
numPics = 13;
zmin = 1;
zmax = 256;
imgCell = cell( numPics, 1 );
t = cputime;
%img = [ width, height, 3, 13];

for i=1:numPics;
 s1 = 'ex_pic/img';
 s2 = [ int2str(i) ];
 if( i < 10 )
     s2 = [ '0' s2 ];
 end
 s3 = '.jpg';
 s = [ s1 s2 s3 ];
 imgCell{i} = imread(s);
end

%% calculate g function
% create the image array X(pixel, images)
numPixels = 50;
for i=1:numPixels;
    x = randi(width);
    y = randi(height);
    for j=1:numPics;
        img = imgCell{j};
        Zr(i,j) = img(y,x,1);
        Zg(i,j) = img(y,x,2);
        Zb(i,j) = img(y,x,3);
    end
end
%Array of shutter speed
B = zeros(numPics,1);
B(1)=log(13); B(2)=log(10); B(3)=log(4); B(4)=log(3.2); B(5)=log(1);
B(6)=log(0.8); B(7)=log(0.3); B(8)=log(1/4); B(9)=log(1/60); B(10)=log(1/80);
B(11)=log(1/320); B(12)=log(1/400); B(13)=log(1/1000);

%[ 13, 10, 4, 3.2, 1, 0.8, 0.3, 1/4, 1/60, 1/80, 1/320, 1/400, 1/1000];

%lamda
l = 1;
%weighting function
w = zeros(1,256);
w(1:128) = (1:128);
w(129:256)=(128:-1:1);
%call functions to solce g, lE
[gr, lEr] = gsolve(Zr,B,l,w);
[gg, lEg] = gsolve(Zg,B,l,w);
[gb, lEb] = gsolve(Zb,B,l,w);
gcell = cell(3,1);
gcell{1} = gr;
gcell{2} = gg;
gcell{3} = gb;


hdrImg = zeros(height,width,3);
for c = 1:3;
    for i = 1:height;
        for j = 1:width;
            wij = 0;
            lEg = 0;
            for k = 1:numPics;
                lE = gcell{c}(imgCell{k}(i,j,2)+1) - B(k);
                lEg = w(imgCell{k}(i,j,2)+1)*lE + lEg;
                wij = wij + w(imgCell{k}(i,j,2)+1); 
            end
            lEg = lEg/wij;
            hdrImg(i,j,c) = exp(lEg);
        end
    end
end
minPix = min(min(min(hdrImg)));
hdrImg = hdrImg/minPix;


imshow(hdrImg)
colormap (jet)
caxis auto
timeCost = cputime - t;
%max(max(hdrImg))
%min(min(hdrImg))
%% Tone mapping
for c = 1:3;
    hdr = hdrImg(:,:,c);
    mapImg(:,:,c) = toneMapping(hdr);
end
%max(max(mapImg))
%min(min(mapImg))
mapImg = round(mapImg*256);
mapImg = uint8(mapImg);
hdr = mapImg(:,:,2);
imshow(hdr)
imshow(mapImg)
imwrite(mapImg, 'hdrImg.bmp');

%colormap (jet)
caxis auto
% plot(gr,'r')
% figure
% plot(gg,'g')
% figure
% plot(gb,'b')

%img = imread(s);
%size(img);
%imshow(img);

