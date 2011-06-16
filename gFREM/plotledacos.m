% this plots var(d) for 'improper' treatment of the blinking situation (not
% integrating out the intensities)
% results vard from teh function varianceFREM.m
q=8;plot(l2(q:end),(bsxfun(@times, [1 2],vard(q:end,:))))
xlabel('d [pixels]')
ylabel('var(d) [pixels^2]')
setforsave(gcf,2)
setfontsizefigure(12)
legend({'{(1,1)}', '{(1,1),(1,0),(0,1),(0,0)}'})
if savethis
    SaveImageFULL('images/VarianceDistanceEqualVsBlinking')
end