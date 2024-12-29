function angles = anglesacc(sacc,eye)

%sacc1 = [sacc(:,4),sacc(:,5)];
%xhat = [1,0];
%angles = acos(dot(sacc1, repmat(xhat, size(sacc1, 1), 1), 2) ./ (vecnorm(sacc1, 2, 2) * norm(xhat)));
angles = sacc(:,9);
polarhistogram(deg2rad(angles),36)
title("Degrees from the x axis, " + eye + " eye" )
subtitle("Mean angle: "+ mean(angles) + " deg, SD: "+ std(angles))

end