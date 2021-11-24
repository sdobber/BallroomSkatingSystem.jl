```@meta
CurrentModule = BallroomSkatingSystem
```

# BallroomSkatingSystem

Documentation for [BallroomSkatingSystem](https://github.com/sdobber/BallroomSkatingSystem.jl).

This package implements the skating system of compiling scores in ballroom dance competitions. 


!!! warning "Disclaimer"
    This package has not been tested against all corner cases that might emerge in real dancing tournaments. 

!!! note
    No sanity checks are performed on the data, like ensuring the correct number of judges for every dance, or making sure that starter numbers coincide. Make sure to feed sanitized data to the functions.


## Installation

BallroomSkatingSystem.jl is *not* a registered package. To install, type `]` at the Julia REPL to enter package mode, and type
```
add https://github.com/sdobber/BallroomSkatingSystem.jl
```


## Exported Functions

```@docs
skating_single_dance
skating_combined 
```


## More Information

* [Wiki page for the Skating system](https://en.wikipedia.org/wiki/Skating_system)
* [WDSF pdf file of the rules](https://www.worlddancesport.org/Document/99473179446/The_Skating_System.pdf) (see also [this page](https://www.worlddancesport.org/Rule/Competition/General/Judging_Systems))
* [Description of the rules (in German)](https://tso.turnierprotokoll.de/tso_anh2.htm)
