using MoM_Visualizing
using Documenter

DocMeta.setdocmeta!(MoM_Visualizing, :DocTestSetup, :(using MoM_Visualizing); recursive=true)

makedocs(;
    modules=[MoM_Visualizing],
    authors="deltaeecs <1225385871@qq.com> and contributors",
    repo="https://github.com/deltaeecs/MoM_Visualizing.jl/blob/{commit}{path}#{line}",
    sitename="MoM_Visualizing.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://deltaeecs.github.io/MoM_Visualizing.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/deltaeecs/MoM_Visualizing.jl",
)