#charset "us-ascii"
#include <tads.h>
#include "advlite.h"

/* The header, shown above, tells TADS to include some essential files. */

versionInfo: GameID
    IFID = ''
    name = ''
    byline = 'by YOUR NAME'
    htmlByline = 'by <a href="mailto:YOUR@ADDRESS.com">
                  YOUR NAME</a>'
    version = '1'
    authorEmail = 'YOUR NAME <YOUR@ADDRESS.com>'
    desc = ''
    htmlDesc = ''
;

/* Notice that each object definition, including versionInfo, ends with a semicolon. */

gameMain: GameMainDef
    /* The initial player character is an object called 'me', which will be defined shortly. */
    initialPlayerChar = me
;

startRoom: Room 'Start'
    "You find yourself in a small closet like room. A small device stands atop a slender pole mounted to the floor. The device has a large red button on top and a small slot on the side. A door is to the north. "
    north = startDoor
;

+ startDoor: Door 'simple door; wood wooden north'
    "A simple door with a handle. "
    otherSide = startDoorOther
    lockability = lockableWithoutKey
    isLocked = true
;

+ me: Thing 'you'     
    isFixed = true       
    person = 2
    contType = Carrier
;

+ printer: Thing 'small device;metal;'
    "A small metal box attached to a pole rising from the floor waist high. There is a single button on top and a small slot on the side. "
    isFixed = true
;

++ slot: AttachableComponent 'small slot;;'
    "The small slot is empty"
;

++ button: AttachableComponent, Button 'button;large red device printer;print'
    "A large red button atop the printer that reads 'Print'. "
    pushed = nil
    makePushed() {
        if (pushed == nil) {
            paper.moveInto(me);
            pushed = true;
            "The device beeps twice and begins to emit a soft mechanical whirling. ";
            "After a moment you take a small slip of paper as it appears in the slot. ";
            startDoor.makeOpen(true);
            "You hear a click come from the door's handle.";
        } else {
            "The button depresses but the device doesn't respond.";
        }
    }
;

+ paper: Thing 'slip of paper;small slip of<prep>'
    "The small piece of paper reads: \'lo ckiku ku crino\'. "
    location = nil
;

Doer 'read paper' {
    exec(curCmd) { doInstead(Examine, gDobj); }
}

testChamber: Room 'Test Chamber 1'
    "You stand in a bare room with a small wooden stool. There are doors to the south and north.  "
    south = startDoorOther
;

+ startDoorOther: Door 'door;wood simple south southern'
    "A simple door with a handle. "
    otherSide = startDoor
;

+ stool: Thing 'small wooden stool;cheap unfurnished wood'
    "A small cheap unfurnished wooden stool. "
    isFixed = true
    contType = On
;

class ColoredKey: Key
    vocab = 'key; painted'
    desc = "A key painted in <<color>> paint. "
    color = 'silver'
    plausableLockList = [door]
    preinitThing() {
        inherited;
        addVocabWord(color, MatchAdj);
        name = color + ' key';
    }

    iobjFor(UnlockWith) {
        verify() { return nonObvious; }
    }
    iobjFor(Unlock) {
        verify() { return nonObvious; }
    }
;

++ redKey: ColoredKey
    color = 'red'
;

++ blueKey: ColoredKey
 color = 'blue'
;

++ greenKey: ColoredKey
    color = 'green'
    actualLockList = [door]

    iobjFor(UnlockWith) {
        action() { finishGameMsg('Congrats, you solved the puzzle!', []); }
    }
;

+ door: Door 'door;wood simple north northern'
    "A simple door with a handle. Below the handle is a small keyhole. "
    lockability = lockableWithKey
    otherSide = self
    destination = unknownDest_
;

++ handle : AttachableComponent 'door handle;brass small;'
   "A small brass handle."
;

Doer
    cmd = 'unlock door'
    exec(curCmd) {
        "What do you want to unlock it with?";
        abort;
    }
;

