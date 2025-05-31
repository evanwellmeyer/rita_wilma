untar('sfc.200510.tar')

clear all; clc;
fid = fopen('sfc.anl.2005102000.ieee');

%% BUS Data
Line_String_Complete=fgetl(fid); Line_String_Complete=fgetl(fid);
Bus_Data=[]; No_of_Buses=0;
while ischar(Line_String_Complete)
    Line_String_Complete=fgetl(fid);
%     disp(['#' Line_String_Complete '#'] );
    if(strcmp(Line_String_Complete(1:4),'-999')==1); break; end
    index=15; Line_String_Numeric=Line_String_Complete(index:end);    
    Line_Numeric=str2num(Line_String_Numeric);
    No_of_Buses=No_of_Buses+1;
    Bus_Data=[Bus_Data; [No_of_Buses Line_Numeric] ];
end

%% Line Data
Line_String_Complete=fgetl(fid);
Line_Data=[]; No_of_Lines=0;
while ischar(Line_String_Complete)
    Line_String_Complete=fgetl(fid);
%     disp(['#' Line_String_Complete '#'] );
    if(strcmp(Line_String_Complete(1:4),'-999')==1); break; end
    index=1; Line_String_Numeric=Line_String_Complete(index:end);    
    Line_Numeric=str2num(Line_String_Numeric);
    No_of_Lines=No_of_Lines+1;
    Line_Data=[Line_Data; [No_of_Lines Line_Numeric]];
end
fclose(fid);

X = hex2num('sfc.anl.2005102000.ieee');