function [mapImg]=toneMapping(img)
   m = size(img);
   height = m(1);
   width = m(2); 
   img = exp(1)*img;
   %min(min(img))
   N = height*width;
   Lw = 0;
   for i = 1:height;
       for j = 1:width;
           Lw = log( img(i,j) ) + Lw;
       end
   end
   Lw = Lw/N;
   a = 0.18;
   Lm = a*img/Lw;
  
   Lwhite = max(max(Lm));
   %
  
   for i = 1:height;
       for j = 1:width;
           Lm(i,j) = Lm(i,j)/(1+Lm(i,j));
       end
   end
   %
   mapImg = Lm;
end