function strOut = MyNum2str(num,maxDig)
  strOut = num2str(num);
  origLen = length(strOut);
  for ii = 1 : (maxDig - origLen) 
     strOut = ['0',strOut];
  end
end