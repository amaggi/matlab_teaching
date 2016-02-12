function [latvec, lonvec, mvec] = readSihexData(filename)
  format = '%*s %*s %*s %f %f %*s %*s %*s %f';
  [latvec, lonvec, mvec] = textread(filename,format,'headerlines',4);
end