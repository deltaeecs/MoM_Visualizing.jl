using MoM_Basics:getBFTfromCellT
using MoM_Kernels:geoElectricJCal

"""
可视化目标与信息（如电流）分布
"""
function visualizeMesh(meshData, vars = LinRange(0, 1, meshData.geonum);
    size_in_inches = (4, 3.5), dpi = 600, legendlabel = "Current(A/m)", args...)

    GLMakie.activate!()
    set_theme!(theme3d)
    # 创建画布
    size_in_pixels = size_in_inches .* dpi
    fig = Figure(resolution = size_in_pixels)
    ax11    =   Axis3(fig[1, 1], aspect = :data; args...)

    # 点分布
    points  =   map(p -> Meshes.Point(p...), eachcol(meshData.node))

    # 创建网格连接
    # 分别创建三角形、四面体、六面体连接后绘图
    # 三角形
    meshData.trinum > 0 && begin
        # 连接
        triconnects     =   connect.(Tuple.(eachcol(meshData.triangles    )), Triangle    )
        tri_simple_mesh     =   SimpleMesh(points, triconnects)
        # 绘制变量
        trivars     =   vars[1:meshData.trinum]
        # 绘图可视化
        viz!(ax11, tri_simple_mesh,     color = trivars, colorscheme    = colormap3d   )
    end
    # 四面体
    meshData.tetranum > 0 && begin
        # 连接
        tetraconnects   =   connect.(Tuple.(eachcol(meshData.tetrahedras  )), Tetrahedron )
        tetra_simple_mesh   =   SimpleMesh(points, tetraconnects)
        # 绘制变量
        tetravars   =   vars[(meshData.trinum + 1):(meshData.trinum + meshData.tetranum)]
        # 绘图可视化
        viz!(ax11, tetra_simple_mesh,   color = tetravars, colorscheme    = colormap3d   )
    end
    # 六面体
    meshData.hexanum > 0 && begin
        # 连接
        hexaconnects    =   connect.(Tuple.(eachcol(meshData.hexahedras   )), Hexahedron  )
        hexa_simple_mesh    =   SimpleMesh(points, hexaconnects)
        # 绘制变量
        hexavars     =   vars[(meshData.trinum + meshData.tetranum + 1):(meshData.geonum)]
        # 绘图可视化
        viz!(ax11, hexa_simple_mesh,    color = hexavars, colorscheme    = colormap3d   )
    end

    # 三角形、四面体、六面体要绘制的变量
    @views begin
        trivars     =   vars[1:meshData.trinum]
        tetravars   =   vars[(meshData.trinum + 1):(meshData.trinum + meshData.tetranum)]
        hexavars    =   vars[(meshData.trinum + meshData.tetranum + 1):(meshData.geonum)]
    end

    Colorbar(fig[1, 2], limits = (minimum(vars), maximum(vars)), colormap    = colormap3d   , label = legendlabel)
    
    # 修改字体大小，轴粗细
    c1 = fig.content[1]
    c1.xlabelsize   =   dpi*10/72
    c1.ylabelsize   =   dpi*10/72
    c1.zlabelsize   =   dpi*10/72
    c1.xspinewidth  =   dpi*2/72
    c1.xtickwidth   =   dpi*2/72
    c1.yspinewidth  =   dpi*2/72
    c1.ytickwidth   =   dpi*2/72
    c1.zspinewidth  =   dpi*2/72
    c1.ztickwidth   =   dpi*2/72

    c1.xticklabelsize   =   dpi*6/72
    c1.yticklabelsize   =   dpi*6/72
    c1.zticklabelsize   =   dpi*6/72

    c2 = fig.content[2]
    # c2.ticks        =   LinRange(0., maximum(vars), 4)
    c2.labelsize    =   dpi*8/72
    c2.ticksize     =   dpi*8/72
    c2.ticklabelsize    =   dpi*8/72
    c2.tickwidth    =   dpi*1/72
    c2.width        =   dpi*8/72
    c2.spinewidth   =   dpi*1/72

    fig
end

"""
为方便正视图保存要改掉一些可视化量
"""
function changeVisual4Fig(fig)
    c1  =   fig.content[1]
    c1.elevation    =   0
    c1.azimuth      =   0
    c1.xgridvisible =   false
    c1.xlabelvisible    =   false
    c1.xticksvisible    =   false
    c1.xticklabelsvisible   =   false
    c1.xspinesvisible       =   false
    c1.ygridvisible =   false
    c1.ylabelvisible    =   false
    c1.yticksvisible    =   false
    c1.yticklabelsvisible   =   false
    c1.yspinesvisible       =   false
    c1.zgridvisible =   false
    c1.zlabelvisible    =   false
    c1.zticksvisible    =   false
    c1.zticklabelsvisible   =   false
    c1.zspinesvisible       =   false
    fig.scene
end

"""
为方便可视化视图要改回一些可视化量
"""
function unChangeVisual4Fig(fig)
    c1  =   fig.content[1]
    c1.elevation    =   π/4
    c1.azimuth      =   π/12
    c1.xgridvisible =   true
    c1.xlabelvisible    =   true
    c1.xticksvisible    =   true
    c1.xticklabelsvisible   =   true
    c1.xspinesvisible       =   true
    c1.ygridvisible =   true
    c1.ylabelvisible    =   true
    c1.yticksvisible    =   true
    c1.yticklabelsvisible   =   true
    c1.yspinesvisible       =   true
    c1.zgridvisible =   true
    c1.zlabelvisible    =   true
    c1.zticksvisible    =   true
    c1.zticklabelsvisible   =   true
    c1.zspinesvisible       =   true
    fig.scene
end

"""
输入电流系数，计算电流分布并绘图
"""
function visualizeCurrent(meshData, geosInfo::AbstractVector{VST}, ICoeff::ICT; str = "", args...) where {VST<:VSCellType, ICT<:AbstractVector}
    # 基函数类型
    bfT =   getBFTfromCellT(eltype(geosInfo))
    # 高斯求积点电流权重乘积
    Jgeos   =   geoElectricJCal(ICoeff, geosInfo, bfT)
    # 电流实部绘图
    Jreal   =   norm.(eachcol(real(Jgeos)))
    figreal =   visualizeMesh(meshData, Jreal; args...)
    # 电流幅值绘图
    Jamp    =   norm.(eachcol(Jgeos))
    figamp  =   visualizeMesh(meshData, Jamp; args...)
    # 保存结果
    save(SimulationParams.resultDir*"figureReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureAmp$str.png",  figamp)

    # 正视图保存
    # 正视图保存
    for fig in [figreal, figamp]
        changeVisual4Fig(fig)
        fig.scene
    end
    
    save(SimulationParams.resultDir*"figureFrontViewReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureFrontViewAmp$str.png",  figamp)

    for fig in [figreal, figamp]
        unChangeVisual4Fig(fig)
    end
    figreal
end

"""
输入电流系数，计算电流分布并绘图
"""
function visualizeCurrent(meshData, geosInfo::AbstractVector{VT}, ICoeff::ICT; str = "", args...) where {VT<:AbstractVector, ICT<:AbstractVector}
    # 面网格、体网格
    tris    =   geosInfo[1]
    geosV   =   geosInfo[2]
    sbfT    =   getBFTfromCellT(eltype(tris))
    vbfT    =   getBFTfromCellT(eltype(geosV))
    # 高斯求积点电流权重乘积
    Jtris       =   geoElectricJCal(ICoeff, tris,  sbfT)
    JgeoVs      =   geoElectricJCal(ICoeff, geosV, vbfT)
    # 电流实部绘图
    Jreal   =   append!(norm.(eachcol(real(Jtris))), norm.(eachcol(real(JgeoVs))))
    figreal =   visualizeMesh(meshData, Jreal; args...)
    # 电流幅值绘图
    Jamp    =   append!(norm.(eachcol(Jtris)), norm.(eachcol(JgeoVs)))
    figamp  =   visualizeMesh(meshData, Jamp; args...)
    # 保存结果
    save(SimulationParams.resultDir*"figureReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureAmp$str.png",  figamp)
    # 正视图保存
    for fig in [figreal, figamp]
        changeVisual4Fig(fig)
        fig.scene
    end
    
    save(SimulationParams.resultDir*"figureFrontViewReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureFrontViewAmp$str.png",  figamp)

    for fig in [figreal, figamp]
        unChangeVisual4Fig(fig)
    end
    figreal
end


"""
输入电流系数，计算电流分布并绘图
"""
function visualizeCurrent(meshData, Jgeos::JCT; str = "", args...) where {T<:Number, JCT<:AbstractArray{T, 2}}
    # 电流实部绘图
    Jreal   =   norm.(eachcol(real(Jgeos)))
    figreal =   visualizeMesh(meshData, Jreal; args...)
    # 电流幅值绘图
    Jamp    =   norm.(eachcol(Jgeos))
    figamp  =   visualizeMesh(meshData, Jamp; args...)
    # 保存结果
    save(SimulationParams.resultDir*"figureReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureAmp$str.png",  figamp)
    # 正视图保存
    for fig in [figreal, figamp]
        changeVisual4Fig(fig)
        fig.scene
    end
    
    save(SimulationParams.resultDir*"figureFrontViewReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureFrontViewAmp$str.png",  figamp)
    
    for fig in [figreal, figamp]
        unChangeVisual4Fig(fig)
    end
    figreal
end

"""
输入电流系数，计算电流分布并绘图
"""
function visualizeCurrent(meshData, Jtris::JCT, JgeoVs::JCT; str = "", args...) where {T<:Number, JCT<:AbstractArray{T, 2}}
    # 电流实部绘图
    Jreal   =   append!(norm.(eachcol(real(Jtris))), norm.(eachcol(real(JgeoVs))))
    figreal =   visualizeMesh(meshData, Jreal; args...)
    # 电流幅值绘图
    Jamp    =   append!(norm.(eachcol(Jtris)), norm.(eachcol(JgeoVs)))
    figamp =   visualizeMesh(meshData, Jamp; args...)
    # 保存结果
    save(SimulationParams.resultDir*"figureReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureAmp$str.png",  figamp) 
    # 正视图保存
    for fig in [figreal, figamp]
        changeVisual4Fig(fig)
        fig.scene
    end
    
    save(SimulationParams.resultDir*"figureFrontViewReal$str.png", figreal) 
    save(SimulationParams.resultDir*"figureFrontViewAmp$str.png",  figamp)
        
    for fig in [figreal, figamp]
        unChangeVisual4Fig(fig)
    end
    figreal
end

"""
输入几何信息文件名和电流系数，计算电流分布并绘图
"""
function visualizeCurrent(filename::AbstractString, ICoeff::ICT; str = "", args...) where {ICT<:AbstractVector}
    # 网格
    meshData, geosInfo  =   values(load(filename))
    # 绘图
    figreal =   visualizeCurrent(meshData, geosInfo, ICoeff; str = str, args...)

    return figreal
end


"""
输入几何信息文件名和电流系数，计算电流分布并绘图
"""
function visualizeCurrent(meshDatafn::AbstractString, JCurrentfn::AbstractString; str = "", args...)
    # 网格
    meshData    =   first(values(load(meshDatafn)))
    # 电流
    Jgeos       =   first(values(load(JCurrentfn)))
    # 绘图
    figreal     =   visualizeCurrent(meshData, Jgeos; str = str, args...)

    return figreal
end
