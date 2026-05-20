function zeta=LowComplexityFun(z,rho)

if abs(z)<rho
    zeta = log((1+z/rho)/(1-z/rho));
else
    error(['Error from LowComplexityFun = ',num2str(z),' is out of ',num2str(rho)]);
end
