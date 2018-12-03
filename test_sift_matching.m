% copy this script file to the folder that contains siftDemoV4 files and change
% these paths to data files
%% 1. SIFT matching for DataSet0 images

skin1 = './DataSet00/skin1.jpg';
skin2 = './DataSet00/skin2.jpg';
retina1 = './DataSet00/retina1.png';
retina2 = './DataSet00/retina2.png';

skin1_out = './DataSet00/skin1.pgm';
skin2_out = './DataSet00/skin2.pgm';
retina1_out = './DataSet00/retina1.pgm';
retina2_out = './DataSet00/retina2.pgm';

convert2pgm(skin1, skin1_out);
convert2pgm(skin2, skin2_out);
convert2pgm(retina1, retina1_out);
convert2pgm(retina2, retina2_out);

match(skin1_out, skin2_out);
match(retina1_out, retina2_out);

%% 2. SIFT matching for DataSet1 images 

chessboard0 = './DataSet01/00.png';
chessboard1 = './DataSet01/01.png';
chessboard2 = './DataSet01/02.png';

chessboard0_out = './DataSet01/00.pgm';
chessboard1_out = './DataSet01/01.pgm';
chessboard2_out = './DataSet01/02.pgm';

convert2pgm(chessboard0, chessboard0_out);
convert2pgm(chessboard1, chessboard1_out);
convert2pgm(chessboard2, chessboard2_out);

match(chessboard0_out, chessboard1_out);
match(chessboard0_out, chessboard2_out);
