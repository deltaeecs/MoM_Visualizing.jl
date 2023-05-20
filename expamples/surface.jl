

using MoM_Basics, MoM_Kernels
using MoM_Visualizing
using CairoMakie
using LaTeXStrings

SimulationParams.SHOWIMAGE = true
setPrecision!(Float64)
inputParameters(;frequency = 20e8, ieT = :CFIE)
# set_Interpolation_Method!(:LbTrained1Step)


filename = joinpath(@__DIR__, "..", "meshfiles/Tri.nas")
# 网格
meshData, εᵣs   =  getMeshData(filename; meshUnit=:mm);
# 基函数
ngeo, nbf, geosInfo, bfsInfo =  getBFsFromMeshData(meshData; sbfT = :RWG)

# 八叉树
nLevels, octree     =   getOctreeAndReOrderBFs!(geosInfo, bfsInfo; nInterp = 4);

# 叶层
leafLevel   =   octree.levels[nLevels];
# 计算近场矩阵CSC
ZnearCSC     =   calZnearCSC(leafLevel, geosInfo, bfsInfo);

# 构建矩阵向量乘积算子
Zopt    =   MLMFAIterator(ZnearCSC, octree, geosInfo, bfsInfo);

## 根据近场矩阵和八叉树计算 SAI 左预条件
Zprel   =   sparseApproximateInversePl(ZnearCSC, leafLevel)

source  =   PlaneWave(π, 0, 0f0, 1f0)
# source  =   MagneticDipole(;Iml = 1., phase = 0., orient = (π/2, π/2, 0))

V    =   getExcitationVector(geosInfo, size(ZnearCSC, 1), source);

ICoeff, ch   =   solve(Zopt, V; solverT = :gmres, Pl = Zprel);

convergence_plot(ch)

## 观测角度
θs_obs  =   LinRange{Precision.FT}(  0, π,  181)
ϕs_obs  =   LinRange{Precision.FT}(  0, 2π,  361)

# RCS
_, _, _, RCSdB = radarCrossSection(θs_obs, ϕs_obs, ICoeff, geosInfo)

# 2D 绘图
fig2d = farfield2D(θs_obs, RCSdB, [L"\phi = %$(ϕ/π*180)^{\circ}" for ϕ in ϕs_obs]; x_unit = :rad)
save(joinpath(SimulationParams.resultDir, "farfield2d.pdf"), fig2d)

fig2d = farfield2D(θs_obs, RCSdB, RCSdB, [L"A (\phi = %$(ϕ/π*180)^{\circ})" for ϕ in ϕs_obs], 
                    [L"B (\phi = %$(ϕ/π*180)^{\circ})" for ϕ in ϕs_obs]; x_unit = :rad)
save(joinpath(SimulationParams.resultDir, "farfield2dCompare.pdf"), fig2d)

# 3D 绘图
fig3d = farfield3D(θs_obs, ϕs_obs, RCSdB)
save(joinpath(SimulationParams.resultDir, "farfield3d.png"), fig3d)
