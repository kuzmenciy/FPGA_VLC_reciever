pic = imread('U:\Desktop\test\real_n3.bmp');

k = 1;
for i = 350:-1:1
    for j = 1:180
            a(k)=pic(i,j,1);
            a(k+1)=pic(i,j,2);
            a(k+2)=pic(i,j,3);
            k=k+3;
    end
end

fid = fopen('U:\Desktop\test\real_n3.hex', 'wt');
fprintf(fid, '%x\n', a);
disp('done');
fclose(fid);
            
