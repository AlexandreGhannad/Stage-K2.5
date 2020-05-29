function save_figure(fig, filename)
orient(fig, "landscape")
set(fig,'PaperSize',[45 25], "WindowState", "maximized"); %set the paper size to what you want
print(fig, filename,'-dpdf', "-r800")
end