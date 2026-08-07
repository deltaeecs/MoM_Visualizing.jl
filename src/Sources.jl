
"""
绘图函数，将源绘制出来
"""
function plotSource(ary::AT; kwargs...) where {AT<:AbstractAntennaArray}
    
    # 各单元中心位置
    cs  =   reshape([convert(GLMakie.Point3f, md.centergb) for md in ary.antennas], :)
    rvecs  =   reshape([GLMakie.Vec3(eulerZunit(md.orient..., :rad)...) .* (Params.λ_0/ 10) for md in ary.antennas], :)
    # 框架值
    framemax    =   maximum(abs, maximum(cs))
    # 颜色
    colors      =   reshape([real(antenna.Iml) for antenna in ary.antennas], :)

    fig = arrows(cs, rvecs; axis=(type=GLMakie.Axis3,aspect = :data, limits = ((-framemax, framemax),(-framemax, framemax),(-framemax, framemax))), fxaa=true, # turn on anti-aliasing
            linecolor = colors, arrowcolor = colors, colormap    =   colorschemes[:rainbow1],
            linewidth = 0.1*Params.λ_0, arrowsize = GLMakie.Vec3f(0.2*Params.λ_0, 0.2*Params.λ_0, 0.2*Params.λ_0), kwargs)

    c1  =   fig.figure.content[1]
    c1.elevation    =   π/6
    c1.azimuth      =   π/6

    fig
end


"""
绘图函数，将源绘制出来
"""
function plotSource(md::MagneticDipole; kwargs...)
    r̂ = 0.3Params.λ_0.* GLMakie.Point3f(eulerZunit(md.orient..., :rad))
    arrows([convert(GLMakie.Point3f, md.centerlc)], [r̂], axis=(type=Axis3,aspect = :data, limits = ((-0.5,0.5),(-0.5, 0.5),(-0.5, 0.5))), fxaa=true, # turn on anti-aliasing
            linecolor = :blue, arrowcolor = :blue,
            linewidth = 0.1*Params.λ_0, arrowsize = GLMakie.Vec3f(0.2*Params.λ_0, 0.2*Params.λ_0, 0.2*Params.λ_0))
end

"""
绘图函数，将源绘制出来
"""
function plotSource!(ax, md::MagneticDipole; kwargs...)
    r̂ = 0.1 .* GLMakie.Point3f(eulerZunit(md.orient..., :rad))
    arrows!(ax, [convert(GLMakie.Point3f, md.centerlc)], [r̂], fxaa=true, # turn on anti-aliasing
            linecolor = :blue, arrowcolor = :blue,
            linewidth = 0.05*Params.λ_0, arrowsize = GLMakie.Vec3f(0.15*Params.λ_0, 0.15*Params.λ_0, 0.05*Params.λ_0),)
end