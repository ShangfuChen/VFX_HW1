
height = 768;
width = 1024;
numPics = 13;
zmin = 1;
zmax = 256;
%img = [ width, height, 3, 13];
imgCell = cell( numPics, 1 );

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

% create the image array X(pixel, images)
numPixels = 50;
for i=1:numPixels;
    x = randi(width,1);
    y = randi(height,1);
    for j=1:numPics;
     img = imgCell{j};
     Z(i,j) = img( y, x, 1);
    end
end
%Array of shutter speed
B = zeros(numPixels,numPics);
B(:,1)=log(13); B(:,2)=log(10); B(:,3)=log(4); B(:,4)=log(3.2); B(:,5)=log(1);
B(:,6)=log(0.8); B(:,7)=log(0.3); B(:,8)=log(1/4); B(:,9)=log(1/60); B(:,10)=log(1/80);
B(:,11)=log(1/320); B(:,12)=log(1/400); B(:,13)=log(1/1000);

%[ 13, 10, 4, 3.2, 1, 0.8, 0.3, 1/4, 1/60, 1/80, 1/320, 1/400, 1/1000];

%lamda
l = 1;
%weighting function
w = zeros(1,256);
w(1:128) = (1:128);
w(129:256)=(128:-1:1);
%call functions to solce g, lE
[g, lE] = gsolve(Z,B,l,w);
plot(g)
%img = imread(s);
%size(img);
%imshow(img);

