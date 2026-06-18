using TestItems
using TestItemRunner

@run_package_tests

@testsnippet Setup begin
  using GeoTables
  using Meshes
  using Unitful
  using Distributions
  using CoDa
  using Colors
  using ReferenceTests
  using StableRNGs
  using Random

  import CairoMakie as Mke

  datadir = joinpath(@__DIR__, "data")

  grid = CartesianGrid(10, 10)
end

@testitem "numerical" setup = [Setup] begin
  rng = StableRNG(123)

  a = rand(rng, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "float.png") viewer(gtb)

  a = rand(rng, 1:5, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "integer.png") viewer(gtb)
end

@testitem "categorical" setup = [Setup] begin
  rng = StableRNG(123)

  a = rand(rng, ["yes", "no"], 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "categorical.png") viewer(gtb)
end

@testitem "unitful" setup = [Setup] begin
  rng = StableRNG(123)

  a = rand(rng, 100) * u"m/s"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "unit-float.png") viewer(gtb)

  a = rand(rng, 1:5, 100) * u"°C"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "unit-integer.png") viewer(gtb)
end

@testitem "distributional" setup = [Setup] begin
  rng = StableRNG(123)

  a = Normal.(rand(rng, 100), rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "normal.png") viewer(gtb)

  a = Dirac.(rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "dirac.png") viewer(gtb)

  a = Bernoulli.(rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "bernoulli.png") viewer(gtb)

  a = Categorical.([rand(rng, Dirichlet([1/3, 1/3, 1/3])) for _ in 1:100])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "categdist.png") viewer(gtb)
end

@testitem "compositional" setup = [Setup] begin
  rng = StableRNG(123)

  a = rand(rng, Composition{2}, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "compositional-1.png") viewer(gtb)

  a = rand(rng, Composition{3}, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "compositional-2.png") viewer(gtb)
end

@testitem "colorful" setup = [Setup] begin
  rng = StableRNG(123)

  a = Gray.(rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "colorful.png") viewer(gtb)
end

@testitem "invalid" setup = [Setup] begin
  rng = StableRNG(123)

  missings = fill(missing, 20)
  a = shuffle(rng, [missings; rand(rng, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-float-1.png") viewer(gtb)

  a = shuffle(rng, [fill(NaN, 20); rand(rng, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-float-2.png") viewer(gtb)

  a = shuffle(rng, [fill(missing, 10); fill(NaN, 10); rand(rng, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-float-3.png") viewer(gtb)

  a = shuffle(rng, [missings; rand(rng, 1:5, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-integer.png") viewer(gtb)

  a = shuffle(rng, [missings; rand(rng, ["yes", "no"], 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-categorical-1.png") viewer(gtb)

  a = shuffle(rng, [missings; rand(rng, 'a':'e', 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-categorical-2.png") viewer(gtb)

  a = shuffle(rng, [missings; rand(rng, 80)]) * u"m/s"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-unit-float.png") viewer(gtb)

  a = shuffle(rng, [missings; rand(rng, 1:5, 80)]) * u"°C"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-unit-integer.png") viewer(gtb)

  a = shuffle(rng, [missings; Normal.(rand(rng, 80), rand(rng, 80))])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-distributional.png") viewer(gtb)

  a = shuffle(rng, [missings; rand(rng, Composition{3}, 80)])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-compositional.png") viewer(gtb)

  a = shuffle(rng, [missings; RGB.(rand(rng, 80), rand(rng, 80), rand(rng, 80))])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-colorful.png") viewer(gtb)
end

@testitem "constant" setup = [Setup] begin
  a = fill(1.0, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-float.png") viewer(gtb)

  a = fill(1, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-integer.png") viewer(gtb)

  a = fill("test", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-categorical.png") viewer(gtb)

  a = fill(1.0 * u"m/s", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-unit-float.png") viewer(gtb)

  a = fill(1 * u"°C", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-unit-integer.png") viewer(gtb)

  a = fill(Normal(), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-distributional.png") viewer(gtb)

  a = fill(Composition(0.2, 0.5, 0.3), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-compositional.png") viewer(gtb)

  a = fill(Gray(0.1), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-colorful.png") viewer(gtb)
end
