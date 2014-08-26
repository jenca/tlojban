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
    "You find yourself in a bare room with a stool and a printer. There is a door on the north wall.  "
;

+ me: Thing 'you'     
    isFixed = true       
    person = 2
    contType = Carrier
    desc = "The most beautiful girl in the world. I love you babe!"
;

+ stool: Thing 'wooden stool;wood cheap unfurnished'
    "A cheap unfurnished wooden stool. "
    isFixed = true
    contType = On
;

class ColoredKey: Key
    vocab = 'key; painted'
    desc = "A key painted <<color>>. Some paint is chipping away. "
    color = 'silver'
    plausableLockList = [door]
    preinitThing() {
        inherited;
        addVocabWord(color, MatchAdj);
        name = color + ' key';
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

    preinitThing() { inherited; knownLockList = []; }
;

+ printer: Thing 'printer;;'
    "A box with a button ontop and a small slot on the side for paper to come out of. "
    isFixed = true
;

++ button: AttachableComponent, Button 'button;red'
    "A red button ontop of the printer that reads \'Push Me'\. "
    makePushed() {
        paper.moveInto(me);
        "You take a piece of paper as it comes through the slot. ";
    }
;

+ paper: Thing 'piece of paper;white piece of<prep>'
    "A small piece of paper that reads \'lo ckiku ku crino\'. "
    location = nil
;

+ door: Door 'door;wood'
    "A simple door with a handle. "
    lockability = lockableWithKey
    otherSide = self
    destination = unknownDest_
;