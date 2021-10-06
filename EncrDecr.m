%% 
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

c=zeros(2,2);
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

%% 
% DECRYPTION part starts here---------------------------------------
a2=imread('encrypted.png');% Use the encrypted Image file in this line

% Now we'll check the number of layers in the encrypted Image
if (ndims(a2)==3)
    nlayer=3;% Okay, it has R, G, B layer (Common case)
else
    nlayer=1;% It has only one layer (Rare case)
end

c=zeros(2,2);
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
