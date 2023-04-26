
"""
    convergencePlot(ys, labels; xlabel = "θ(°) (ϕ = 90°)", ylabel = "dB", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)
    
    绘制单线或多线收敛图，一般用于不

"""
function convergencePlot(ys, labels; xlabel = "θ(°) (ϕ = 90°)", ylabel = "dB", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)
    
    CairoMakie.activate!( type = "pdf")

    set_theme!(theme)

    size_pt = 72 .* size_inches
    f   =   Figure(resolution = size_pt)
    ax  =   Axis(f[1, 1], xlabel = xlabel, ylabel = ylabel, yticklabelrotation = π/2,
                    xgridstyle = :dot, ygridstyle = :dot, xgridwidth = 0.5, ygridwidth = 0.5, 
                    xtickalign = 1, ytickalign = 1, xticksize = 3, yticksize = 3)
    for i in eachindex(labels)
        scatterlines!(ax, xs, ys[:, i], linewidth = 1, linestyle = linestyles[i], 
                        marker = markers[i % length(markers) + 1], markersize = 6, label = labels[i], color = colormap[i])
    end

    !isnothing(xlim) && xlims!(ax, xlim...)
    !isnothing(ylim) && ylims!(ax, ylim...)

    showlegend && axislegend(ax; position = legendposition, patchsize = (20, 6), 
                rowgap = 0, labelsize = 8, bgcolor = :transparent, 
                framevisible = false, padding = (2., 2., 2., 2.))
    
    current_figure()

    f

end