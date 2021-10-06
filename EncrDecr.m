% ENCRYPTION part starts here-----------------------------------------
a1=imread('tank.jpg');% Use your desired plain Image file in this line

ar=size(a1,1);
ac=size(a1,2);
% If the Image has odd number of pixels, we'll truncate the last row and
% (or) last column, because our algorithm block size is 2x2
a1=a1(1:end-mod(ar,2),1:end-mod(ac,2),:);

% Now we'll check the number of layers in the plain Image
if (ndims(a1)==3)
    nlayer=3;% Okay, it has R, G, B layer (Common case)
else
    nlayer=1;% It has only one layer (Rare case)
end

block=zeros(size(a1,1),size(a1,2));
k1=zeros(size(a1,1),size(a1,2),3);

r=1;
for layer=1:nlayer
    for i=1:2:size(a1,1)
        for j=1:2:size(a1,2)
            c=a1(i:i+1,j:j+1,layer);
            c=reshape(c,1,4);
            c=encr(c,r);% Encryption subroutine
            c=reshape(c,2,2);
            block(i:i+1,j:j+1)=c;
            r=r+1;
            if (r>13)
                r=1;
            end
        end
    end
    k1(:,:,layer)=block;
end

k1=uint8(k1);
% We now save the encrypted data
imwrite(k1,'encrypted.png','compression','none','mode','lossless');
% Encryption is done, new file saved as encrypted.png
% ENCRYPTION part ends here-----------------------------------------

% DECRYPTION part starts here---------------------------------------
a2=imread('encrypted.png');% Use the encrypted Image file in this line

% Now we'll check the number of layers in the encrypted Image
if (ndims(a2)==3)
    nlayer=3;% Okay, it has R, G, B layer (Common case)
else
    nlayer=1;% It has only one layer (Rare case)
end

block=zeros(size(a2,1),size(a2,2));
k2=zeros(size(a1,1),size(a1,2),3);

r=1;
for layer=1:nlayer
    for i=1:2:size(a2,1)
        for j=1:2:size(a2,2)
            c=a2(i:i+1,j:j+1,layer);
            c=reshape(c,1,4);
            c=decr(c,r);% Decryption subroutine
            c=reshape(c,2,2);
            block(i:i+1,j:j+1)=c;
            r=r+1;
            if (r>13)
                r=1;
            end
        end
    end
    k2(:,:,layer)=block;
end

k2=uint8(k2);
% We now save the decrypted data
imwrite(k2,'decrypted.png','compression','none','mode','lossless');
% Decryption is done, new file saved as decrypted.png
% DECRYPTION part ends here------------------------------------------

% ENCRYPTION subroutine
function [out]=encr(a,r)
key={'f4' '4d' '7a' '15'...
    'c9' '99' '1a' '9f'...
    '85' '40' 'ff' '23'...
    '98' 'a8' 'b2' 'b1'...
    '52' 'b7' '5d' '11'...
    '54' 'f3' 'f7' 'd3'...
    'c2' 'cc' '2c' '22'...
    '10' '16' '23' '30'};
sbox=[ 12 5 15 0 14 4 9 7 2 10 3 8 6 11 1 13;
    10 4 1 12 5 2 14 3 7 11 6 13 8 0 9 15;
    5 0 10 1 4 9 8 11 15 2 6 12 3 13 14 7;
    15 4 10 0 12 8 3 1 7 9 13 11 5 14 2 6];
keybin=dec2bin(hex2dec(key),8);
keybin=(bin2dec(keybin(:,7:8)))';
b= zeros(1,4);
scdxor= zeros(1,4);
sub= zeros(1,8);
for i=1:4
    b(i)= bitxor(a(i),hex2dec(key(r+i-1)));
end
b=dec2bin(b,8);
c=[b(1,1:4); b(1,5:8); b(2,1:4); b(2,5:8);
    b(3,1:4); b(3,5:8); b(4,1:4); b(4,5:8)];
c=(bin2dec(c))';
for i=1:8
    sub(i)=sbox(keybin(r+i-1)+1,c(i)+1);
end
sub=dec2bin(sub,4);
subcat=[sub(1,:) sub(2,:); sub(3,:) sub(4,:);
    sub(5,:) sub(6,:); sub(7,:) sub(8,:)];
subcat=(bin2dec(subcat));
MDS=[ 2 3 1 1;
    1 2 3 1;
    1 1 2 3;
    3 1 1 2];
subcat_gf=gf(subcat,8);
MDS_gf=gf(MDS,8);
out_gf=MDS_gf*subcat_gf;
subcat=out_gf.x;
subcat=circshift(subcat,-2);
subcat=dec2bin(subcat,8);
for i=1:4
    subcat(i,:)=circshift(subcat(i,:),-r);
end
subcat=(bin2dec(subcat))';
for i=1:4
    scdxor(i)=bitxor(subcat(4-i+1),hex2dec(key(32-r-i+2)));
end
out=scdxor;
return
end

%DECRYPTION subroutine
function [out]=decr(scdxor,r)
key={'f4' '4d' '7a' '15'...
    'c9' '99' '1a' '9f'...
    '85' '40' 'ff' '23'...
    '98' 'a8' 'b2' 'b1'...
    '52' 'b7' '5d' '11'...
    '54' 'f3' 'f7' 'd3'...
    'c2' 'cc' '2c' '22'...
    '10' '16' '23' '30'};
sbox=[ 3 14 8 10 5 1 12 7 11 6 9 13 0 15 4 2;
    13 2 5 7 1 4 10 8 12 14 0 9 3 11 6 15;
    1 3 9 12 4 0 10 15 6 5 2 7 11 13 14 8;
    3 7 14 6 1 12 15 8 5 9 2 11 4 10 13 0];
keybin=dec2bin(hex2dec(key),8);
keybin=(bin2dec(keybin(:,7:8)))';
a=zeros (1,4);
c=zeros (1,8);
subcat=zeros (1,4);
for i=1:4
    subcat(4-i+1)=bitxor(scdxor(i),hex2dec(key(32-r-i+2)));
end
subcat=dec2bin(subcat,8);
for i=1:4
    subcat(i,:)=circshift(subcat(i,:),r);
end
subcat=(bin2dec(subcat))';
subcat=circshift(subcat,2);
MDS=[ 14 11 13 9;
    9 14 11 13;
    13 9 14 11;
    11 13 9 14];
subcat_gf=gf(subcat',8);
MDS_gf=gf(MDS,8);
out_gf=MDS_gf*subcat_gf;
subcat=out_gf.x;
subcat=dec2bin(subcat,8);
sub=[subcat(1,1:4); subcat(1,5:8); subcat(2,1:4); subcat(2,5:8);
    subcat(3,1:4); subcat(3,5:8); subcat(4,1:4); subcat(4,5:8)];
sub=(bin2dec(sub))';
for i=1:8
    c(i)=sbox(keybin(r+i-1)+1,sub(i)+1);
end
c=dec2bin(c,4);
b=[c(1,:) c(2,:); c(3,:) c(4,:);
    c(5,:) c(6,:); c(7,:) c(8,:)];
b=(bin2dec(b))';
for i=1:4
    a(i)=bitxor(b(i),hex2dec(key(r+i-1)));
end
out=a;
return
end
