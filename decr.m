function [out]=decr(scdxor,r)
% Symmetric-Key Alogorithm: Use the same key for Encryption & Decryption.
% "Decryption" process is same as "Encryption" process, in reverse order.

key={'f4' '4d' '7a' '15'...% 256-bit key, each segment is 8 bit
    'c9' '99' '1a' '9f'...
    '85' '40' 'ff' '23'...
    '98' 'a8' 'b2' 'b1'...
    '52' 'b7' '5d' '11'...
    '54' 'f3' 'f7' 'd3'...
    'c2' 'cc' '2c' '22'...
    '10' '16' '23' '30'};
sbox=[ 12 5 15 0 14 4 9 7 2 10 3 8 6 11 1 13;% Substitution Box
    10 4 1 12 5 2 14 3 7 11 6 13 8 0 9 15;
    5 0 10 1 4 9 8 11 15 2 6 12 3 13 14 7;
    15 4 10 0 12 8 3 1 7 9 13 11 5 14 2 6];
% Now we need the last 2 bits from each key segment.
% MATLAB understands BIN (or HEX) in string format only. That's painful!!!
keybin=dec2bin(hex2dec(key),8);
keybin=(bin2dec(keybin(:,7:8)))';

a=zeros (1,4);
c=zeros (1,8);
subcat=zeros (1,4);

for i=1:4
    % Output Whitening
    subcat(4-i+1)=bitxor(scdxor(i),hex2dec(key(32-r-i+2)));
end
subcat=dec2bin(subcat,8);

for i=1:4
    subcat(i,:)=circshift(subcat(i,:),r);% Bit-wise Rotation
end
subcat=(bin2dec(subcat))';

subcat=circshift(subcat,2);% Byte-wise Rotation
subcat=dec2bin(subcat,8);

% Splitting the output from "Byte-wise Rotation" (below)
sub=[subcat(1,1:4); subcat(1,5:8); subcat(2,1:4); subcat(2,5:8);
    subcat(3,1:4); subcat(3,5:8); subcat(4,1:4); subcat(4,5:8)];
sub=(bin2dec(sub))';

for i=1:8
    % Using the Substitution Box
    [row, column]=find(sbox==sub(i));
    m=find(row==(keybin(r+i-1)+1));
    c(i)=column(m)-1;
end
c=dec2bin(c,4);

% Concatenation of "Substitution Box" output (below)
b=[c(1,:) c(2,:); c(3,:) c(4,:);
    c(5,:) c(6,:); c(7,:) c(8,:)];
b=(bin2dec(b))';

for i=1:4
    % Input Whitening
    a(i)=bitxor(b(i),hex2dec(key(r+i-1)));
end

out=a;
return
end
