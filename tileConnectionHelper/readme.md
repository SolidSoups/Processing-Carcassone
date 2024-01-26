# Tile Connection Helper
A utility for designing connections between Carcassone game tiles and exporting them as a JSON file.

## Problem
In the popular board game *Carcassone*, players get a single tile each turn and have to place it on the table. The way the players are allowed to place these tiles must always follow this ruleset:
1. A tile has to always be placed next to another tile.
2. Each four sides of the tile will have one feature of the types *Grass*, *Road* or *City*. Tiles can only be placed next to eachother if the sides where they meet have the same features.


On the tile, the feature is represented by an illustration with a clear boundary between other features and an open boundary on the side of the tile it occupies. Tiles can also have features that connect to other sides of the tile. When a set of tiles features are connected to eachother in series, that feature expands. When a feature has closed all its boundaries, i.e that they are connected to eachother in one or several closed loops, and if the inside of that feature is filled in, the feature is said to be completed. A completed feature will score points for a player.

As I am making a Carcassone game, I needed a utility to classifify a tile's features on each side and how those features are connected to other sides of the tile.

## Solution
![Tile Port Visualization](https://github.com/SolidSoups/Processing-Carcassone/blob/main/tileConnectionHelper/TilePortVisualization.png "Tile Port Visualization")
<br />
The way I have chosen to go about this problem, is to catagorize each side of the tile as a port (see image above). Each port will have a these sets of properties:
* A **Port Type**, being either *Grass*, *Road* or *City*.
* Any **Port Connections**, being which ports it can connect to

With this idea, I created a class called `Tile`. The tile object will store properties such as the **sprite ID**, **lock state**, **port types** for every compass direction and a **connection table** table for what connections can be made. Let me go into detail about how the two latter work.

![Tile Object Representation](https://github.com/SolidSoups/Processing-Carcassone/blob/main/tileConnectionHelper/TileObjectRepresentation.png "Tile Object Representation")

**Port types** is an integer array that stores 4 values. The indexes for that array will range from 0 to 3. Therefore I created an enum for every compass direction, which ranges from 0 (being North) to 3 (being West). This will make my life a lot easier. The array will store values from 0 to 2, representing the three port types we can have. I have also created a enum in the same fashion for the port types.

The **Port Connection** table, is a 2 dimensional 4x4 boolean array which stores statements about if a port at a certain compass direction can make a connection to another port at another direction. A port can never make a connection to the itself, so for every port they will have a connection that is never enabled.

## Design

### Window elements
![Window Elements](https://github.com/SolidSoups/Processing-Carcassone/blob/main/tileConnectionHelper/WindowElements.png)

The program window concists of the following elements:
1. The current sprite we are editing, **displayed in the center of the window**.
2. The current sprites ID, **displayed in the top left corner**. It is colored green if we haven't locked editing, and red otherwise.
3. The current port we are editing, **displayed as a rectangle next to the port we are editing**. It rotates to another port if we change which port we are editing.
4. The port type, **displayed as a text on each side of the square sprite in a blue color**.
5. A text list of port connections, **displayed under the port type text in a greenish color**. The program will only ever display as many connections as a port has, so if it has none it will display none. 


### Functionality
* Loads sprites from the *'resources/sprites/'*, as well as load any saved tile objects and match them to the correct sprites
* Display a sprite we are currently working on, as well as their ID, port types and port connections table.
* Cycle through all connected sprites
* Change port types for all directions
* Change which directions a port connects to. Note you can never enable a port connection to the current port.
* Lock and unlock a sprite we have finished edited on
* Save every locked sprite into a JSON file

### Keyboard shortcuts
* <kbd>e</kbd> : Cycle through sprites in ascending order
* <kbd>q</kbd> : Cycle through sprites in descending order
* <kbd>p</kbd> : Lock/Unlock editing on sprite
* <kbd>b</kbd> : Save all locked sprites data into a JSON file


* <kbd>&larr;</kbd> : Cycle through current port clockwise
* <kbd>&larr;</kbd> : Cycle through current port counter-clockwise
* <kbd>&uarr;</kbd> : Change port type for current port
* <kbd>w</kbd> : Enable port connection to north
* <kbd>d</kbd> : Enable port connection to east
* <kbd>s</kbd> : Enable port connection to south
* <kbd>a</kbd> : Enable port connection to west