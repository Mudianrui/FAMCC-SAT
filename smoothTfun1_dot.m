function T1=smoothTfun1_dot(z,dz)
if z>0
    T1=exp((z-1)/z)/(z^2)*dz;
else
    T1=0;
end
