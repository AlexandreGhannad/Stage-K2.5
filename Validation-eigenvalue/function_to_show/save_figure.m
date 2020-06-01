% Short function to save a figure in pdf, resolution 800 DPI, maximized
% screen size, landscape orientation
% A warning could appear because the chosen size for the "PaperSize" option
% is shorter than the complete graphic and trim the edges.

function save_figure(fig, filename)
orient(fig, "landscape")
set(fig,'PaperSize',[45 25], "WindowState", "maximized"); %set the paper size to what you want
print(fig, filename,'-dpdf', "-r800")
end