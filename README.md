# Image Ciphering
*A simple symmetric-key block cipher for image*

[*initially written in MATLAB R2017b*]
- Simply run the **EncrDecr.m** file. It has 2 subroutines: *encr* & *decr*.
- By default, the script will load "tank.jpg" for encrypting. After encryption, "encrypted.png" will be produced in the directory.
- Then, the script will automatically load "encrypted.png" for decryption. After decryption, "decrypted.png" will be produced in the directory.
- If you want to use different plain image, change "Line #2" in the script. Make sure the plain image (JPG) is in the same directory.

N.B. No initialization vector is employed here.
