function [R,G,B] = rainbow_generator(N)
% generates a rainbow color stairs from black to white in N steps
    
    % set color grad

    k=1;     % black
    r=round(N/7);   % red
    y=round(2*N/7); % yellow
    g=round(3*N/7); % green
    l=round(4*N/7); % light-blue
    b=round(5*N/7); % blue
    p=round(6*N/7); % pink
    w=round(N);     % white
    
    red(k:r,1) = (0:1/(r-k):1)';
    red(r:y,1) = 1;
    red(y:g,1) = flip(0:1/(g-y):1)';
    red(g:l,1) = 0;
    red(l:b,1) = 0;
    red(b:p,1) = (0:1/(p-b):1)';
    red(p:w,1) = 1;
    
    green(k:r,1) = 0;
    green(r:y,1) = (0:1/(y-r):1)';
    green(y:g,1) = 1;
    green(g:l,1) = 1;
    green(l:b,1) = flip(0:1/(b-l):1)';
    green(b:p,1) = 0;
    green(p:w,1) = (0:1/(w-p):1)';
    
    blue(k:r,1) = 0;
    blue(r:y,1) = 0;
    blue(y:g,1) = 0;
    blue(g:l,1) = (0:1/(l-g):1)';
    blue(l:b,1) = 1;
    blue(b:p,1) = 1;
    blue(p:w,1) = 1;
    
    rainbow = [red green blue];
    
    R = rainbow(:,1);
    G = rainbow(:,2);
    B = rainbow(:,3);

end