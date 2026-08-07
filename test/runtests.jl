using MoM_Visualizing
using Test

@testset "MoM_Visualizing.jl" begin
    include(joinpath(@__DIR__, "..", "expamples/surface.jl"))
    @test true
    rm(SimulationParams.resultDir, force=true, recursive=true)
end
