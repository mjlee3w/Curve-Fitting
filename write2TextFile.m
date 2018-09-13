function [ ] = write2TextFile( inputString, fileName )
%UNTITLED2 Writes to a textfile for logging interactions

fileID = fopen(fileName, 'a'); %which file you want to save to
fprintf(fileID, inputString);
fclose(fileID);


end

