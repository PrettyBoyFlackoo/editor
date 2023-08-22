package editor;

import hxd.Key;
import h2d.Scene;
import h2d.Graphics;
import h2d.col.Point;

using hxd.Math;

class Workspace {

    var g:Graphics;

    var isReady:Bool;
    var mousemovemnt = new Point();
    var lastMouse = new Point();
    var relMousePos = new Point();
    var absMousePos = new Point();

    var gridLoc = new Point();

    var worldSizeX:Float = 2000;
    var worldSizeY:Float = 2000;

    var parent:Scene;

    public function new(worldSizeX:Float = 2000, worldSizeY:Float = 2000) {
        this.worldSizeX = worldSizeX;
        this.worldSizeY = worldSizeY;

        parent = Main.inst;

        g = new Graphics(parent);
    }

    function init():Void {

    }

    public function update():Void {

        relMousePos.set(parent.mouseX, parent.mouseY);

        mousemovemnt.x = relMousePos.x - lastMouse.x;
        mousemovemnt.y = relMousePos.y - lastMouse.y;

        lastMouse.x = relMousePos.x;
        lastMouse.y = relMousePos.y;

        if (Key.isPressed(Key.MOUSE_LEFT) && !isReady) {
            isReady = true;
        }

        if (Key.isDown(Key.MOUSE_LEFT) && isReady) {

            gridLoc.x += mousemovemnt.x;
            gridLoc.y += mousemovemnt.y;
        }

        if (Key.isReleased(Key.MOUSE_LEFT) && isReady) {
            isReady = false;
        }

        gridLoc.x = Math.clamp(gridLoc.x, -worldSizeX + parent.camera.viewportWidth, 0);
        gridLoc.y = Math.clamp(gridLoc.y, -worldSizeY + parent.camera.viewportWidth, 0);

        trace(getGridLoc());

        draw();
    }

    function draw() {

        g.clear();

        ///Draw Bg
        g.beginFill(0x141414);
        g.drawRect(0, 0, worldSizeX, worldSizeY);
        g.endFill();

        ///Draw small grid
        var gridSizeSmall:Float = 32;
        var gridSizeLinesX:Int = Math.round(worldSizeX / gridSizeSmall);
        var gridSizeLinesY:Int = Math.round(worldSizeY / gridSizeSmall);

        g.lineStyle(1, 0x202020);
        
        ///From top to bottom
        for (i in 0...gridSizeLinesX) {
            g.moveTo(gridLoc.x + i * gridSizeSmall, 0);
            g.lineTo(gridLoc.x + i * gridSizeSmall, worldSizeY);
        }

        ///From left to right
        for (i in 0...gridSizeLinesY) {
            g.moveTo(0, gridLoc.y + i * gridSizeSmall);
            g.lineTo(worldSizeX, gridLoc.y + i * gridSizeSmall);
        }
        

        ///Draw Large grid
        var gridSizeLarge:Float = gridSizeSmall * 2;
        var gridSizeLinesX:Int = Math.round(worldSizeX / gridSizeLarge);
        var gridSizeLinesY:Int = Math.round(worldSizeY / gridSizeLarge);

        g.lineStyle(1, 0x303030);
        
        ///From top to bottom
        for (i in 0...gridSizeLinesX) {
            g.moveTo(gridLoc.x + i * gridSizeLarge, 0);
            g.lineTo(gridLoc.x + i * gridSizeLarge, worldSizeY);
        }

        ///From left to right
        for (i in 0...gridSizeLinesY) {
            g.moveTo(0, gridLoc.y + i * gridSizeLarge);
            g.lineTo(worldSizeX, gridLoc.y + i * gridSizeLarge);
        }
    }

    function getGridLoc():Point {
        return new Point(Math.abs(gridLoc.x), Math.abs(gridLoc.y));
    }
}