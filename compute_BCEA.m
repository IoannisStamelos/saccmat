function [allBCEAs,interval] = compute_BCEA(positions10,conf_int)
buffer = 500;
tempBCEA = zeros(1,10);
BCEAs = zeros(2,5);

k = [1.13943,3.079,5.80914];
intervals = {'65','95','99.7'};

for i = 1:length(positions10)
    x = positions10{i}(:,2);
    x = x(buffer:end);
    y = positions10{i}(:,3);
    y = y(buffer:end);
    std_hor = std(x);
    std_ver = std(y);
    r = corrcoef(x,y);
    
    BCEA = 2*k(conf_int)*pi*std_hor*std_ver*sqrt(1-r(1,2).^2);
    
    tempBCEA(i)= BCEA(1,1);
end

BCEAs(1,:)= tempBCEA([1 3 5 7 9]);
BCEAs(2,:)= tempBCEA([2 4 6 8 10]);
position_names = {'Center','Left','Right','Up','Down'};
eyes = {'Right Eye','Left Eye'};
allBCEAs = array2table(BCEAs,'RowNames',eyes,'VariableNames',position_names);
interval = intervals{conf_int};

end