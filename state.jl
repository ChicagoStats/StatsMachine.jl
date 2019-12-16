# STATES #


abstract type State end
abstract type Transision end
InvalidState = ArgumentError
@enum Ingredient eggs flour sugar water butter baking_soda

struct NeedIngredients <: State
    gathered::Set{Ingredient}
    NeedIngredients() = new(Set())
end
struct Gather <: Transision
    ingredient::Ingredient
end

struct MixBatter <: State
    remaining::Array{Ingredient}
    MixBatter()=new([flour, sugar, baking_soda, water, eggs, butter])
end

struct Add <: Transision
    ingredient::Ingredient
end
    
struct RuinedBatter <: State end
struct RawBatter <: State end

struct Bake <: Transision
    temp::UInt64    
end

struct TastyCake <: State end
struct BurntCake <: State end

step(::State, ::Transision) = throw(InvalidState)

function step(state::NeedIngredients, transision::Gather)
    push!(state.gathered, transision.ingredient)
    state.gathered != Set(Ingredient) ? state : MixBatter()
end

function step(state::MixBatter, transision::Add)
    if state.remaining[1] == transision.ingredient
        popfirst!(state.remaining)
        isempty(state.remaining) ? RawBatter() : state
    else
        RuinedBatter()
    end
end

step(::RawBatter, transision::Bake) = transision.temp > 350 ? BurntCake() : TastyCake()

# ~~~~~~~~~~~~~~~
step(NeedIngredients(), Gather(eggs))

step(NeedIngredients(), Add(water))

recipe = [
           Gather(flour)
           Gather(eggs)
           Gather(water)
           Gather(baking_soda)
           Gather(butter)
           Gather(sugar)
           Add(flour)
    Add(sugar)
    Add(baking_soda)
    Add(water)
    Add(eggs)
    Add(butter)
    Bake(325)
         ]
