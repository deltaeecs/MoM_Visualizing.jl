
"""
三角形网格画图
"""
function meshplot()

    meshData    =   getNodeTriTetraHexa(SimulationParams.meshfilename, SimulationParams.meshunit)

    node        =   meshData.node
    triangles   =   meshData.triangles .- 1
    mesh    = PlotlyJS.mesh3d(
            x = node[1,:], y = node[2,:], z = node[3,:], 
            i = triangles[1,:], j = triangles[2,:], k = triangles[3,:])

    plt = PlotlyJS.plot(mesh)

    SimulationParams.SHOWIMAGE  && display(plt)
end

"""
三角形网格画图，带电流
"""
function meshplot(meshData, JEtri::Array{CT}) where{CT<:Complex}

    # 点信息
    node        =   meshData.node
    # 构成三角形点的序号，java第1个索引为0，故此处修正
    triangles   =   meshData.triangles .- 1
    # 计算电流对应的颜色, 将电流归一化到自大最小区间内
    Jnorm       =   norm.(eachcol(real(JEtri)))
    # Jdiff       =   Jminmax[2] - Jminmax[1]
    # intensities =   (Jnorm .- Jminmax[1]) ./ Jdiff
    # Jrgb1       =   Jdiff/255
    # Jrgb        =   [Int.(div.(Jnormcol - Jmin, Jrgb1)) for Jnormcol in eachcol(Jnorm)]

    # facescolor  =   ["rgb($(cl[1]), $(cl[2]), $(cl[3]))" for cl in Jrgb]
    colorscales =   [[0. , "blue"], [0.5, "gold"], [1 , "red"]]

    meshReal    = PlotlyJS.mesh3d(
                    x = node[1,:], y = node[2,:], z = node[3,:], 
                    colorbar_title = "J(A/m)", #colorbar_x = -0.1,
                    i = triangles[1,:], j = triangles[2,:], k = triangles[3,:], 
                    intensity = Jnorm, intensitymode="cell", 
                    colorscale = colorscales)
            
    layoutReal  =   PlotlyJS.Layout(title = "电流瞬时值", scene=attr(aspectmode="data"))
    
    pltReal = PlotlyJS.plot(meshReal, layoutReal)
    SimulationParams.SHOWIMAGE && display(pltReal)
    PlotlyJS.savefig(pltReal, SimulationParams.resultDir*"CurrentReal.html")

    Jnormall        =   norm.(eachcol(JEtri))

    meshAll    = PlotlyJS.mesh3d(
                    x = node[1,:], y = node[2,:], z = node[3,:], 
                    colorbar_title = "J(A/m)",
                    i = triangles[1,:], j = triangles[2,:], k = triangles[3,:], 
                    intensity = Jnormall, intensitymode="cell", 
                    colorscale = colorscales)
    layoutAll  =   PlotlyJS.Layout(title = "电流幅值", scene=attr(aspectmode="data"))

    pltAll = PlotlyJS.plot(meshAll, layoutAll)

    # pltCurrents =  [pltReal pltAll]

    SimulationParams.SHOWIMAGE && display(pltAll)
    PlotlyJS.savefig(pltAll, SimulationParams.resultDir*"CurrentAmp.html")

end