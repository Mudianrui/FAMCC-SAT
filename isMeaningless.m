function [] = isMeaningless(varargin)
for i=1:nargin %总输入参数个数，varargin是可变数量参数的对象
    if ~isreal(varargin{i}) || isnan(varargin{i})
        error(['isMeaningless ',num2str(i),' ',num2str(varargin{i})]);
    end
end