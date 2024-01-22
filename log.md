# Log 2024

## E1: January 22, 5:25
Created some basic functionality. 

Using a `GameController` class, it operates in the fashion of rendering tiles and mouse position snapped to a grid with size of choosing, and handling their position on the screen with an arrayList. The class also makes sure that only one tile can exist at a given grid position.

The `Tile` class handles the properties of a single tile. Right now it only displays itself at a given position with a given random color, but I plan on changing it to a sprite very soon. The grid system is implemented into the tile class, with a custom integer vector to make them snap to the grid. I also had to override the PVector class to get the functionality of return a integer vector from a PVector.

Next steps are to add some sprites and only allow placement of tiles next to eachother, as in the board game carcassone.