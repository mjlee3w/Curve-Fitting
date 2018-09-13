function [pdfCount] = savePlot2pdf( pdfName, pdfCount, FIGURE )
% saves CURRENT plot to pdf

fileName = strcat(pdfName,int2str(pdfCount),'.pdf');
saveas(FIGURE, fileName);

end

