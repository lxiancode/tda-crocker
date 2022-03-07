function data = vicsek(eta,outfile)

% Set parameters
L = 25;         % Box size
%L=6;            %Box size (to agree with M and Devin's poster)
v0 = 0.03;      % Speed
dt = 1;         % Time step
r = 1;          % Interaction radius
%eta = 0.02;      % Noise amplitude
N = 300;        % Number of agents
steps = 2000;   % Number of time steps

% Set IC
x = rand(N,1).*L;
y = rand(N,1).*L;
z = x+ i*y;
theta = 2*pi*rand(N,1);
v = v0*exp(i*theta);

% Initialize data
time0 = zeros(N,1);
data = [time0,x,y,theta];

% Main loop
% HueAld2008 is helpful in implementing
% Still some question about proper scaling of noise

for j = 1:steps;

    % Calculate new heading
    [Z1,Z2] = meshgrid(z,z);
    sep = abs(Z1-Z2);
    closeenough = sep <= r;
    V =  repmat(v.',[N,1]);
    neighborV = sum(V.*closeenough,2);
    newtheta = angle(neighborV) + eta*(rand(N,1)-1/2);
    newv = v0*exp(i*newtheta);
    
    % Calculate new position with old heading, accounting for wraparound
    z = z + v*dt;
    x = mod(real(z),L);
    y = mod(imag(z),L);
    z = x + i*y;

    % Update heading data
    v = newv;
    theta = newtheta;
    
    % Store the data
    time = dt*j*ones(N,1);
    data = [data;[time,x,y,theta]];
    
    %plot
%     if mod(j,4) == 0
%         cla
%         set(gcf,'doublebuffer','on')
%         quiver(real(z),imag(z),real(v),imag(v),0.3,'b');
%         axis([0 L 0 L]);
%         drawnow;% pause(0.05);
%     end
end

dlmwrite(outfile,data);

end