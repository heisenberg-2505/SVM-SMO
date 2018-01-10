function y=svm2mat(s)
fid = fopen(s);
i=1;

    fprintf('\nExtracting Data ...');
    dots = 12;
while ~feof(fid) % not end of the file 
    
       s = fgetl(fid); % get a line 
       s1=[];  j=1;
       while (j<=length(s))
           
             while(j<=length(s)&& s(j)~=' ')
                   s1=[s1 s(j)];
                   j=j+1;   
             end  
             j=j+1;   
             s1=[s1 ' '];              
             while ( (j<length(s)) && (s(j)~=':') )   
                    j=j+1;   
             end             
             j=j+1;   
       end
        s2=str2num(s1) ;
        if (i==1)
            yy=zeros(1,length(s2));
        end
        a1=size(yy);
        a2=size(s2);
        if(a1(2)==a2(2))
        yy=[yy ; s2];
        i=i+1;      
        end
        
        q=mod(i,100);
        if q==0
         fprintf('.');
    dots = dots + 1;
        if dots > 100
        dots = 0;
        clc;
        fprintf('\nExtracting Data ...');
        end
        end
        if(a1(1)>30000)
            break;
        end
end
yy(1,:)=[];
y=yy;

fprintf(' Done! \n\n');