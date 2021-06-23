
DHsource = readtable('resources/icubarm_source_dhparams.csv');
DHsource.Properties.VariableNames = {'a', 'd', 'alpha', 'offset', 'min', 'max', 'n'};
RobotSource = Revolute('d', DHsource.d(1), 'a', DHsource.a(1), 'alpha', deg2rad(DHsource.alpha(1)), 'offset', deg2rad(DHsource.offset(1)));
for i=2:height(DHsource)
    RobotSource = RobotSource + Revolute('d', DHsource.d(i), 'a', DHsource.a(i), 'alpha', deg2rad(DHsource.alpha(i)), 'offset', deg2rad(DHsource.offset(i)));
end
RobotSource.name = 'iKin';
RobotSource.base = [0	-1	0	0;
                    0	0	-1	0;
                    1	0	0	0;
                    0	0	0	1];
RobotSource.tool = eye(4);

DHidyn = readtable('resources/icubgenova02_urdf_dhparams.csv');
DHidyn.Properties.VariableNames = {'a', 'd', 'alpha', 'offset', 'min', 'max'};
RobotIDyn = Revolute('d', DHidyn.d(1), 'a', DHidyn.a(1), 'alpha', deg2rad(DHidyn.alpha(1)), 'offset', deg2rad(DHidyn.offset(1)));
for i=2:height(DHsource)
    RobotIDyn = RobotIDyn + Revolute('d', DHidyn.d(i), 'a', DHidyn.a(i), 'alpha', deg2rad(DHidyn.alpha(i)), 'offset', deg2rad(DHidyn.offset(i)));
end
RobotIDyn.name = 'iDynTree';

homtable = readtable('resources/icubgenova02_urdf_h0_hn.txt');
h = zeros(4,4);
k = 2;
for i=1:4
    for j=1:4
        h(i, j) = homtable{1, k};
        k = k+1;
    end
end
RobotIDyn.base = h;
                
k = 2;
for i=1:4
    for j=1:4
        h(i, j) = homtable{2, k};
        k = k+1;
    end
end
RobotIDyn.tool = h;

qdes1 = [0 0 0 0 0 0 60.5 0 0 0];
qdes2 = [0 0 0 0 0 0 90.5 0 0 0];
qdes3 = [0 0 0 0 90 -30 15 0 0 0];
qdes4 = [0 0 0 0 135 0 90.5 -90 -30.6 20.4];

Q = deg2rad(qdes2);

hold on
RobotSource.plot(Q, 'jointcolor', 'b', 'linkcolor', 'r', 'jointdiam', 0.5, ...
    'nojoints', 'workspace', [-1 1 -1 1 -1 1], ...
    'noshading', 'noname', 'noshadow');
    zlim([-1, 1]);

alpha(.5)
hold on
RobotIDyn.plot(Q, 'jointcolor', 'r', 'linkcolor', 'b', 'jointdiam', 0.5,...
    'nojoints', 'workspace', [-1 1 -1 1 -1 1], ...
    'noshading',  'noname', 'noshadow', 'nobase');
    zlim([-0.5, 0.6]);
alpha(.5)

annotation('textbox', [.5 .5 .3 .3], 'String', 'red: iKin   blue: iDynTree','FitBoxToText','on');
exportgraphics(gcf(), 'zeros.png');

RobotIDyn.display
RobotIDyn.fkine(Q)

RobotSource.display
RobotSource.fkine(Q)

errormatrix = sqrt((RobotIDyn.fkine(Q) - RobotSource.fkine(Q)).^2)

model = importrobot('model/model.urdf');
fromtorso = subtree(model, 'root_link');
