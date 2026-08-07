@doc raw"""
    farfield2D(args...; xlabel = L"\theta (^{\circ})", 
    ylabel = L"\text{RCS (dBsm)}", x_unit = :deg, kargs...)

绘制单线或多线/点线图，一般用于不同 ϕ 面上的远场分布绘图、比较图等。
"""
function farfield2D(args...; xlabel = L"\theta(^{\circ})", 
    ylabel = L"\text{RCS (dBsm)}", x_unit = :deg, kargs...)

    xs = if length(args) in [3, 5] && x_unit == :rad
        args[1] .* 180 / π
    else
        args[1]
    end

    linesplot(xs, args[2:end]...; xlabel = xlabel, ylabel = ylabel, kargs...)

end

"""
    farfield3D(θs, ϕs, data; xlabel = "θ(°) (ϕ = 90°)", ylabel = "dB", size_inches = (3.5, 2.4), legendposition = :lt, 
    xlim = nothing, ylim = nothing, showlegend = true)

绘制单线或多线图，一般用于不同 ϕ 面上的远场分布绘图
"""
function farfield3D(θs, ϕs, data; size_inches = (3.5, 2.4), label = "RCS(dB)",
    xlim = nothing, ylim = nothing, zlim = nothing, showlegend = true, dpi = 300, cmap = colormap3d)
    
    GLMakie.activate!()
    set_theme!(theme3d)

    # xyz网格坐标
    x = [sin(θ) * sin(ϕ) for θ in θs, ϕ in ϕs]
    y = [sin(θ) * cos(ϕ) for θ in θs, ϕ in ϕs]
    z = [cos(θ) for θ in θs, _ in ϕs]

    #
    size_in_pixels = size_inches .* dpi
    fig = Figure(size = size_in_pixels, fontsize = 3.2/25.4*dpi, theme = theme_light())
    axs = Axis3(fig[1, 1], aspect = :data)

    data_normalized = data .- minimum(data)

    pltobj = surface!(axs, data_normalized .* x, data_normalized .* y, data_normalized .* z; color = data, colormap = cmap, 
                        lightposition = CairoMakie.Vec3f(0, 0, 0), ambient = CairoMakie.Vec3f(0.65, 0.65, 0.65),
                        backlight = 5.0f0, shading = MultiLightShading)
    Colorbar(fig[1, 2], pltobj, label = label, tickwidth = 2, tickalign = 1, width = 25, ticksize = 3.2/25.4*dpi, height = Relative(0.5))

    # hidedecorations!(axs)

    current_figure()
    colsize!(fig.layout, 1, Aspect(1, 1.0))

    display(GLMakie.Screen(), fig)
    fig

end