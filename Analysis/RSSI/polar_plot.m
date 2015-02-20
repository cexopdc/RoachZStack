function polar_plot(input_file)
if nargin < 1
    disp('Please give one input file');
    return;
end

input = load(input_file);

theta = 0:pi/18:(2*pi-pi/18);

%{
rho = ones(1,36);
%theta2 = 0:pi/4:7*pi/4;
%rho2 = [-76 -74 -56 -75 -77 -58 -79 -72];
rho2 = 0.5*ones(1,36);
rho3 = 0.25*ones(1,36);
figure
polar(theta,rho)
hold on
polar(theta,rho2,'r')
polar(theta,rho3,'y')
legend('mean','std','max');