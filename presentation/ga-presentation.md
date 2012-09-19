# Genetic Algorithms

- A problem-solving technique that works like natural evolution (biology-bullshit-bingo: Genomes, Muatation, survival of the fittest)
- If there are any biologists in the room, i'm already sorry for using the terms wrong here (I have no idea what I'm doing - dog)
- Sounds more complicated than it actually is
	- I expected it to be way harder than it turned out to be
	- This was part of an exam in uni and it actually was very hard, but more because we had to use a very shitty C# codebase which over-complicated the whole thing
- As an example we'll use the Travelling Salesman Problem, because it is a NP-hard problem (-> no efficient solution to the problem)
	- Problem: Find the shortest way that connects a set of cities. The Salesman is only allowed to visit each city once. It doesn't matter where he starts. He has to return to the starting point again in the end.
	- picture here

- So how does a GA work / consist of?
	1. Generate a random population of Genomes
	2. Rank the Genomes according to their fitness
	3. Select/ Mate / Mutate population
	4. Repeat at 2

		- It's that simple, right? ;)
		- Let's try this with our Example

- Create a Population- and a Genome-class
- 

