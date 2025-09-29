filename = 'Plots_and_Results/microgrid_simulation.gif';

figure;
for t = 1:10:length(time)
    plot(time(1:t)/60, SOC_array(1:t), 'LineWidth', 2);
    xlabel('Time (min)');
    ylabel('Battery SOC (%)');
    title('Microgrid SOC over Time');
    grid on;
    
    drawnow;
    
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    if t == 1
        imwrite(imind,cm,filename,'gif','Loopcount',inf,'DelayTime',0.1);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0.1);
    end
end
