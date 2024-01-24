# Log 2024

## E1: January 22, 5:25pm
Created some basic functionality. 

Using a `GameController` class, it operates in the fashion of rendering tiles and mouse position snapped to a grid with size of choosing, and handling their position on the screen with an arrayList. The class also makes sure that only one tile can exist at a given grid position.

The `Tile` class handles the properties of a single tile. Right now it only displays itself at a given position with a given random color, but I plan on changing it to a sprite very soon. The grid system is implemented into the tile class, with a custom integer vector to make them snap to the grid. I also had to override the PVector class to get the functionality of return a integer vector from a PVector.

Next steps are to add some sprites and only allow placement of tiles next to eachother, as in the board game carcassone.

## E2: January 22, 7:39pm
I have added the basic carcassone tile set, consisting of 24 different sprites (without the river expansion). The `Tile` class has been remade to instead of rendering a square with a random color, it now displays a sprite of choosing using the included PImage class. 

In the `GameController` class, I have added a cursor that displays the currently given tile at the mouse position, fixed on the grid as before. When the class is initialized, a random number will be chosen from 0-23, indicating which sprite will be used. I also initialized all the sprites into a PImage array as I thought it would be faster to have them in memory already. Then when the user clicks a Tile object is created with the currently selected tile, and a new tile will be drawn. Not only that but the `addTile()` method now checks for if the selected placement position is neighbouring any tiles north, east, south and west of the position, so that the tiles stay connected.

I am considering the approach of renderering the next tile at the mouse position to be quite cumbersome, as if i add ability of several players (a must for this game) it will be hard to keep an eye on the cursor to see what tile another player is going to place. I have been inspired by the carcassone game on steam to display it in a corner, add the tile to a position and then allow the player to rotate it. Although im a little skeptic about displaying all the possible locations of the tile, as it's an aid that is not found in the real live board game. It could be added as optional functionality though.

Next steps are to move the next tile to the bottom corner, allow preview placement and rotation, and a submit button or cancel button.

## E3: January 23, 6:20pm
I have restructured the `GameController` class to now display the next tile in the upper right corner, and placing a tile now doesn't set it in stone, but allows a preview of the placement. The cursor has also been changed to highlight a grid cell with a grey opaque color if it is a valid cell for a tile to be placed in. Placing the tile in a valid gridcell will create a tile and place it there as a preview. If a preview is enabled, the user can also rotate the tile 90 degrees with the right click button. 

Although this is some great progress, the functionality to set a tile in stone is gone. I am going to add more UI elements such as a confirm tile or cancel preview buttons. Furthermore, i feel like my code is getting more and more cluttered and i need to create some kind of system to keep everything organised. 

## E4: January 24, 3:19pm (2h)
I have yet again restructured the `GameController` class to seperate the graphics methods. I have created two classes, ´GraphicsHandler´ to handle drawing graphics such as tiles and ´UIHandler´ to handle UI elements such as next tile and confirm or cancel placements. Both classes are now fed a reference to the GameController class when they are created in it, so that they can access functions and variables. The UI class now displays a cancel or confirm placement button control in the bottom left corner. The control allows the user to remove the preview, or set it in stone and add the previewTile to the list of placed tiles. The tiles also save their chosen rotation.

Next i need to add a way to check if two tiles can fit together. I think i can do this with a seperate program to add f.ex. roads or city connections to each side of the tile. This way, when we wanna know if two tiles can connect we look up their connections and make a connection? if that makes sense.