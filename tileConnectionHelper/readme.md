# Tile Connection Helper
The tile connection helper allows you to define how carcassone tile sprites can connect to eachother, and save that data as a JSON file. 

## Functionality
* Load all sprites from the *'resources/sprites/'*, as well as load any saved tile objects and match them to the correct sprites
* Display a sprite we are currently working on, as well as their ID, port types and port connections.
* Cycle through all connected sprites
* Change port types for all directions
* Change which directions a port connects to. Note you can never enable a port connection to the current port.
* Lock and unlock a sprite we have finished edited on
* Save every locked sprite into a json file

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

## Design
![Tile object](https://github.com/SolidSoups/Processing-Carcassone/blob/main/tileConnectionHelper/TileObjectRepresentation.png "TileConnectionHelperImage")

The program loads the sprites from the *'resources/sprites/'* directory into a list of PImages, each sprite recieving an index like so *'sprite_01.jpg'*. If there are any tile objects saved, their information will be added to the sprites when their id's match. 

For each sprite, a `Tile` object is created. It is designed so that each side is represented by a port. Ports can have different types, such as Grass, Road or City. Tiles can only connect to other tiles the ports in between them are the same; grass port with grass port, city port with city port, vice versa. But when connecting features together, ports can travel through tiles to other ports of the same time. Therfore we need to store information about where a port travels to within a tile. I call this port connections. If a port has 0 port connections, the feature ends at that tile. If it has two, the feature connects to two other tiles. The maximum amount of port connections a port can have is three, because it cannot connect to itself. Even if this is the case, the boolean array for each port will still have 4 indexes to make my life easier. This is the main idea of how tiles can connect to eachother.

To summarize:
The `tile` object will store information such as:
* The ID of the tile, an integer.
* The lock state of the tile, allowing us to lock editing of it, as a boolean (true being locked).
* A list of the 4 port types on the sprite, as a list of enums; NORTH (0), EAST (1), SOUTH (2), WEST (3).
* A 2D boolean array representing the connections allowed for each port

### Window elements
![Window Elements](https://github.com/SolidSoups/Processing-Carcassone/blob/main/tileConnectionHelper/WindowElements.jpg)

The program window conists of the following elements:
1. The current sprite we are editing, **displayed in the center of the window**.
2. The current sprites ID, **displayed in the top left corner**. It is colored green if we haven't locked editing, and red otherwise.
3. The current port we are editing, **displayed as a rectangle next to the port we are editing**. It rotates to another port if we change which port we are editing.
4. The port type, **displayed as a text on each side of the square sprite in a blue color**.
5. A text list of port connections, **displayed under the port type text in a greenish color**. The program will only ever display as many connections as a port has, so if it has none it will display none. 