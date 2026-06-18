using TestItems
using TestItemRunner

@run_package_tests

@testsnippet Setup begin
  using GeoTables
  using Meshes
  using CoordRefSystems
  using Distributions
  using Unitful
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

  a = fill(1.0, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-float.png") viewer(gtb)

  a = fill(1, 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-integer.png") viewer(gtb)
end

@testitem "categorical" setup = [Setup] begin
  rng = StableRNG(123)

  a = rand(rng, ["yes", "no"], 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "categorical.png") viewer(gtb)

  a = fill("test", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-categorical.png") viewer(gtb)
end

@testitem "unitful" setup = [Setup] begin
  rng = StableRNG(123)

  a = rand(rng, 100) * u"m/s"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "unit-float.png") viewer(gtb)

  a = rand(rng, 1:5, 100) * u"°C"
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "unit-integer.png") viewer(gtb)

  a = fill(1.0 * u"m/s", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-unit-float.png") viewer(gtb)

  a = fill(1 * u"°C", 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-unit-integer.png") viewer(gtb)
end

@testitem "distributional" setup = [Setup] begin
  rng = StableRNG(123)

  a = Normal.(rand(rng, 100), rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "normal.png") viewer(gtb)

  a = fill(Normal(), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-normal.png") viewer(gtb)
end

@testitem "compositional" setup = [Setup] begin
end

@testitem "colorful" setup = [Setup] begin
  rng = StableRNG(123)

  a = Gray.(rand(rng, 100))
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "colorful.png") viewer(gtb)

  a = fill(Gray(0.1), 100)
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "const-colorful.png") viewer(gtb)
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

  a = shuffle(rng, [missings; fill("test", 20); rand(rng, ["yes", "no"], 60)])
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

  a = shuffle(rng, [missings; RGB.(rand(rng, 80), rand(rng, 80), rand(rng, 80))])
  gtb = georef((; a), grid)
  @test_reference joinpath(datadir, "invalid-colorful.png") viewer(gtb)
end
