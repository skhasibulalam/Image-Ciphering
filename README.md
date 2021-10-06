# Image-Ciphering
*A simple symmetric-key block cipher for image*

No initialization vector is introduced.

*[initially written in MATLAB R2017b]**
- Simply run the **EncrDecr.m** file. It has 2 subroutines: **encr.m** & **decr.m**
- By default, the script will load "tank.jpg" for encrypting. After encryption, "encrypted.png" will be produced in the directory.
- Then, the script will automatically load "encrypted.png" for decryption. After decryption, "decrypted.png" will be produced in the directory.
- If you want to use different plain image, change "Line #3" in **EncrDecr.m** file. Make sure the plain image is in the same directory.
