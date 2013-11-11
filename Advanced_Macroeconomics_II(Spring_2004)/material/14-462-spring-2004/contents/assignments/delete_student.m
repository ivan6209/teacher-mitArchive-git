function y=delete_student(inputfile);

fid=fopen(inputfile,'rb');
file_content=char(fread(fid)');
fclose(fid);
file_content=strrep(file_content,'Student Version of MATLAB','');

fid=fopen(inputfile,'wb');
fwrite(fid,double(file_content)');
fclose(fid);
y=0;

