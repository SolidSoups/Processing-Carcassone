# Log 2024

## E1: January 22, 5:25pm
Created some basic functionality. 

Using a `GameController` class, it operates in the fashion of rendering tiles and mouse position snapped to a grid with size of choosing, and handling their position on the screen with an arrayList. The class also makes sure that only one tile can exist at a given grid position.

The `Tile` class handles the properties of a single tile. Right now it only displays itself at a given position with a given random color, but I plan on changing it to a sprite very soon. The grid system is implemented into the tile class, with a custom integer vector to make them snap to the grid. I also had to override the PVector class to get the functionality of return a integer vector from a PVector.

Next steps are to add some sprites and only allow placement of tiles next to eachother, as in the board game carcassone.

![missing image](https://github.com/SolidSoups/Processing-Carcassone/blob/main/captures/Capture1.PNG "Basic functionality such as adding tiles.")

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

![missing image](https://github.com/SolidSoups/Processing-Carcassone/blob/main/captures/Capture2.PNG "Image showing tiles with sprites, and a cancel and confirm placement control.")

## E5: January 24, 8.40pm (3h 50min)
I have constructed a tool to classify every connection that is able to be made for a tile. The plan is that i can quickly go through a list of tiles and classify their differnet connections. The program works by having `connections` class that handles every tile. In every connections class there is four `port` classes, which each hold information about the connection able to be made in every direction, and where they connect to. Now i just have to find a way to save JSON files and then upload them to my main program. This new program is a little weird and clunky and probably handles data not too well, but at least im saving the data im processing. Im also wondering if it wouldve been easier to write things by hand...

![missing image](https://github.com/SolidSoups/Processing-Carcassone/blob/main/captures/Capture3.PNG "Program for adding connections between tiles")

## E6: January 25, 12.20pm (1h)
I have completely restructured the entire tile helper program. I feel like it is a lot simpler and more put together now. I removed just about anything and started from scratch. 

From this point, the current sprite we can edit can be cycled through with:
* <kbd>q</kbd> - to cycle back one sprite
* <kbd>e</kbd> - to cycle forward one sprite

So I added a class called `Tile`, which will handle the ports of all four sides of the tile in different types such as `Grass`, `Road`, and `City` (stored as finals). Then it also has a 2 dimensional boolean array, which stores the directions a tile can connect as four lists, ordered from left to right as the ports beginning direction (`North`, `East`, `South`, `West` also stored as finals), and withing each first index we have a list of four booleans, each item in the list representing if we can connect to either North, East, South or West.

I have designed the program so you can only edit one port at a time, switching between them with these keyboard shortcuts:
* <kbd>&rarr;</kbd> - to cycle through current port clockwise
* <kbd>&larr;</kbd> - to cycle through current port counter-clockwise


To change the port type of the current port:
* <kbd>&uarr;</kbd> - cycle through port types of current port


And finally to enable a connection to be made from the current port to a chosen direction:
* <kbd>w</kbd> - to enable a North connection
* <kbd>e</kbd> - to enable a East connection
* <kbd>s</kbd> - to enable a South connection
* <kbd>a</kbd> - to enable a West connection

I have also made sure to add so you can't connect to the same port you're editing. This system is a lot more elegant than what i hacked together last night.

**Next steps are to be able to save this data as a json file, and then figure out how im going to import this data into my game**

![missing image](https://github.com/SolidSoups/Processing-Carcassone/blob/main/captures/Capture4.PNG "TileConnectionHelperImage")

[*see 'recording4.mp4' for reference*](https://github.com/SolidSoups/Processing-Carcassone/blob/main/captures/Recording4.mp4)

## E7: January 25, 7:06pm (5h)
In the tile connection helper program, i added the ability to lock editing on sprites, so that i couldnt make any mistakes once i was sure it was done. There after i added the ability to save every sprite that has been locked into a json file. When the program starts up next time, it will load the json file and match the data to each sprite, so that we can continue to work on it. The save button is 'b'. 

I found it surprisingly easy to save data as a JSON file and will continue to use this for the foreseeable future.

**Next steps are to process all the tile connections, import it into the main game, and create a rule system for how tiles can connect to eachother**

[*see 'readme.md' for reference on how the program works*](https://github.com/SolidSoups/Processing-Carcassone/tree/main/tileConnectionHelper/readme.md)

## E8: January 26, 6:00pm (3h 10min)
Redid the entire readme.md file for the tile helper utility, as i thought it was quite messy. 

## E9: January 30, 9:07pm (2h)
I have started implementation of a method that checks for all possible rotations in a given grid position that validly connect to other tiles. it is having some problems though where some locations arent generating the right rotations. 

## E10: January 30, 11:16pm (30min)
I figured out what i did wrong. Let me explain how the method works. 

It recieves inputs of a grid location on the tile map. It then checks every neighbouring block, and if it exists, it figures out what face is facing the grid location. This is where i went wrong, i wasnt accounting for the rotation of the neighbouring tile as it can affect what port is facing the main location. I then collect all the ports facing the grid location and create a list from North to West of all those types of faces. Then i get a list of the next tiles ports, and i try to match those lists by periodically rotating the tile. The method returns a boolean list with a length of 4 depicting what rotation (which is the index) is allowed.


## E11: January 31, 11:12am (1h)
The tiles now finally are only allowed to be placed at a given position IF: 
* there is no other tile there
* it is right next to a tile
* the tile and neighbouring tile can make any connections

I have made some improvements to the debug mode. The UI will now show every location where a placement is possible, and how many placements are possible at that location. 

**Next i am planning to restructure, recycle and clean my code**

## E12: January 31, 4:00pm (2h)
I have implemented a functionality to both programs that allows the creation of a "*tile deck*", given a certain distribution property assigned by the **tile utility** program (previously tile connection helper). Every tile is assigned a count, which is how many of that tile will be in the deck. It saves it in the same JSON file, and in the main program that json file is loaded as normal. But now the `TileData` class has a int proprerty for that tiles specific count. When the main game loads up, it fills a deck with the specified distribution. I am planning on adding a distribution multiplier, so that you can change how long and big the game will be. Maybe you could have infinite with a timer, and cards are drawn based on their chance. So far its working good, but the game doesnt know to stop when the card deck is out, so it keeps recycling the same last tile over and over again.

**Next i think i will need to implement a stop game functionality**

## E13: January 31, 7:22pm (1h 20min)
I have cleaned up the code just about everywhere. Variables have been given better names and methods and functions have been organized into group. I have also added a function for DEBUG_MODE where you can see the ditribution of the deck.

## E14: February 1, 4:18pm
Restructured the `drawDeckDistribution` method, allowing it to highlight the tile that was recently drawn in red, and displaying it as 0 if there are none left. I also moved this debug to the left side.

## E15: February 2, 8pm
I created a method that recursively goes through a recently placed tile and all the road features connected to it, and returns true if the feature is closed. I then use that in the `placeTile()` method and add a score to the game.

## E16: February 4, 1:40pm
I finally got the method working for detecting if a road feature has been completed. Suffice to say it has been a long journey, and i finnally feel like i understand it to some extent. Now i gotta simplify the code as much as possible... im not excited for the city feature control, or even the farms...

## E17: February 4, 6:48pm
I reorganized the entire directory, splitting up code from the `gameController.pde` file into severel new files to handle different things. For example, the `features` class will handle completed features (and in the feature assign the features to players), the `move` class handles player moves, like where a tile is placed and what orientation and whatnot. The `Deck` class handles the creation of a deck, as well as drawing cards and checking the amount of remaining cards.