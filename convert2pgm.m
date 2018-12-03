function convert2pgm(file_in, file_out)
%convert2pgm Converts images to pgm
%   file_in is the name of the input image,
%   file_out is the name of the output image to be saved
    img_to_convert = imread(file_in);
    imwrite(img_to_convert, file_out);
end

