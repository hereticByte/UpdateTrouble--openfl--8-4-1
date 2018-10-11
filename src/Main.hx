package ;

import openfl.display.DisplayObject;
import flash.text.TextFormatAlign;
import flash.display.IGraphicsData;
import openfl.display.Stage;

import openfl.display.DisplayObject;
import lime.system.Display;
import haxe.Timer;
import openfl.text.TextFieldType;
import openfl.display.Graphics;
// import flash.text.engine.GraphicElement;
import openfl.display.Shape;
// import flash.geom.Rectangle;
import openfl.display.Loader;
import openfl.display.BlendMode;
import Marker.MarkedType;
import openfl.events.IEventDispatcher;
import openfl.events.EventDispatcher;
import openfl.display.DisplayObject;
import openfl.text.TextFormat;
import openfl.text.TextField;
import openfl.events.MouseEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.Assets;
import openfl.display.SimpleButton;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

// using layout.LayoutCreator;


#if (debug && cpp)
import debugger.Local;
import debugger.HaxeRemote;
#end

// Source: https://keyreal-code.github.io/haxecoder-tutorials/07_how_to_make_a_pong_game_in_haxe_and_openfl_part_1.html


class Main extends Sprite
{

    #if (debug && cpp)
    static public var remoteDebugger(default,default) : HaxeRemote;
    static public var localDebugger(default,default) : Local;
    #end


    public static function startDebugger():Void
    {
        #if (debug && cpp)
        var startDebugger:Bool = false;
        var debuggerHost:String = "";
        var argStartDebugger:String = "-start_debugger";
        var pDebuggerHost:EReg = ~/-debugger_host=(.+)/;

        for (arg in Sys.args()) {
            if(arg == argStartDebugger){
                startDebugger = true;
            }
            else if(pDebuggerHost.match(arg)){
                debuggerHost = pDebuggerHost.matched(1);
            }
        }

        if(startDebugger){
            if(debuggerHost != "") {
                trace("Connecting to remote debug session at " + debuggerHost);
                var args:Array<String> = debuggerHost.split(":");
                remoteDebugger = new debugger.HaxeRemote(true, args[0], Std.parseInt(args[1]));
            }
            else {
                trace("Starting local debug session.");
                localDebugger = new debugger.Local(true);
            }
            trace("Debugger is ready.");
        } else {
            trace("No debug session requested.");
        }
        #else
            #if debug
                trace("Not a C++ target - skipping hxcpp debugger.");
            #end
        #end
    } // public static function startDebugger():Void

    var inited:Bool;

    var button01 : SimpleButton;
    var button02 : SimpleButton;
    var button03 : SimpleButton;

    var buttonMap : Map<String,SimpleButton>;

    var buttonIdentification : TextField;

   // var layout : Layout;

    var clickCounter : Int = 0;

    var hintTextfield : TextField;
    var circleSprite : Sprite;
    var circleMoved : Bool = false;
    var squareMoved : Bool = false;

    /* ENTRY POINT */

    private function resize( e )
    {
        if (!inited)
            init();

        // layout.resize( Lib.current.stage.stageWidth, Lib.current.stage.stageHeight );


        // else (resize or orientation change)

    } // function resize( e )


    /*
        Projectstructure:

            Module
                Haxe

                    Compile with:
                        OpenFL

                    Target:
                        Windows

                    Project Macros:
                        HXCPP_DEBUGGER
                        debug
                        cpp
                        Ddbug

                    OpenFl arguments:
                    -- none --

                    OpenFL Project XML:
                        -- path to project.xml ---

                    Automaticall synchronize dependencies and settings:
                        true

                    Skip compilation
                        false

                    Flex SDK for Flash applications debugging
                        [Invalid]


        Debugger
            Edit configuration:
                Debugger Listener Port: 6972


        Todo: HINT
        Use the version 1.1.0 of the hxpp-debugger ( although it's  not the current one )!
        */

    private static inline function buildButtonStateSprite( color : Int ) : Sprite
    {
        var bitmapData : BitmapData = Assets.getBitmapData( "assets/close_button.png" );

        var bitmapUp : Bitmap = new Bitmap( bitmapData );

        // bitmapUp.opaqueBackground = 0xff0000;



        var background : Shape = new Shape();
        var graphics : Graphics = background.graphics;
        graphics.beginFill( color );
        graphics.drawRect( 0, 0, 128, 128 );
        graphics.endFill();

        var returnMasterSprite : Sprite = new Sprite();

        returnMasterSprite.addChild( background );
        returnMasterSprite.addChild( bitmapUp );
        
        return returnMasterSprite;
    } // private static inline function buildButtonStateSprite( color : Int ) : Sprite

    @:access( openfl.display.BitmapData )
    private function createButton( id : String ) : SimpleButton // SimpleButton_Marker
    {
        // var loader : Loader = new Loader();

        var returnButton : SimpleButton = new SimpleButton();
        addChild( returnButton );
        
        buttonMap.set( id, returnButton );


        returnButton.visible = true;
        // returnButton.focusRect = true;


        var upStateMasterSprite : Sprite = buildButtonStateSprite( 0x26701d );
        returnButton.upState = upStateMasterSprite;

        var downStateMasterSprite : Sprite = buildButtonStateSprite( 0x1040a0 );
        returnButton.downState = downStateMasterSprite;
        // xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


        var overStateMasterSprite : Sprite = buildButtonStateSprite( 0x29792f );
       //  bitmapDown.opaqueBackground = 0x29792f;

        returnButton.overState = overStateMasterSprite;



// HitTest state is used to respond on the mouse click. So set the same displayObject
// like the over state has.
        returnButton.hitTestState = overStateMasterSprite;

        returnButton.width = 30.0;
        returnButton.height = 30.0;

        returnButton.opaqueBackground = 0x29792f;
        return returnButton;
        
    } // private function createButton( id : String ) : SimpleButton_Marker



   /* private inline static function setButtonLayout( button : LayoutItem,
                                                    layout : Layout,
                                                    horizontalLayout : LayoutType,
                                                    verticalLayout : LayoutType ) : Void
    {
        button.horizontalLayout = horizontalLayout;
        button.verticalLayout = verticalLayout;


        // var rand : Float = Math.random();



//        button.marginLeft = 30.0;
//        button.marginTop = 30.0;
//        button.marginRight = 30.0;
//        button.marginBottom= 30.0;

        button.rigidHorizontal = true;
        button.rigidVertical = true;

        button.setMargins( 30.0, 30.0, 30.0, 30. );





        layout.addItem( button );
        // layout.layoutItems();
    } // private inline static function setButtonLayout( button : SimpleButton ) : Void

*/
    @:access( openfl.display.BitmapData )
    @:access( openfl.display.DisplayObject )
    private function init() : Void
    {
        if (inited) return;

        inited = true;

        button01 = createButton( "button01" );
        button02 = createButton( "button02" );
        button03 = createButton( "button03" );

        button01.name = "button01x";

        button01.x = 15.0;
        button01.y = 15.0;
//
//        button01.set_rotation( 45.0 );
//        button02.rotation = 45.0;


        button02.name = "button02x";

        button02.x = 150.0;
        button02.y = 15.0;

        button03.name = "button03x";

        button03.x = 290.0;
        button03.y = 15.0;


        buttonIdentification = new TextField();
        buttonIdentification.text = "No button clicked.";

        var textFormat : TextFormat = new TextFormat( "Verdana" );

        textFormat.size =  12;
        textFormat.color = 0x000000;

        buttonIdentification.defaultTextFormat = textFormat;

//        buttonIdentification.y = 250;
//        buttonIdentification.x = 215;

        addChild( buttonIdentification );


        this.graphics.beginFill( 0x29792f );
        this.graphics.drawRect( 0, 350, 200, 200 );
        this.graphics.endFill();

        var sprite : Sprite = new Sprite();
        addChild( sprite );

       //  sprite.mask =

//        this.graphics.beginFill( 0x0829af );
//        this.graphics.drawCircle( 250, 250, 120.0 );
//        this.graphics.endFill();

        var openTextfield : TextField = new TextField();
        openTextfield.text = "Great!";
        addChild( openTextfield );

        openTextfield.width = 140.0;

        openTextfield.x = 15;
        openTextfield.y = 340;

        openTextfield.focusRect = true;
        openTextfield.defaultTextFormat = textFormat;

        openTextfield.type = TextFieldType.INPUT;
        // openTextfield.mouseEnabled = false;

        trace( "this.width: " + this.width );
        trace( "this.height: " + this.height);
        trace( "this.x: " + this.x);
        trace( "this.y: " + this.y);
        this.addEventListener( MouseEvent.CLICK, clickCB, false );


        // layout.resize( layout.width, layout.height );

        buttonIdentification.x = 20;
        buttonIdentification.y = 75;


        circleSprite = new Sprite();

        circleSprite.graphics.beginFill( 0x0511a0 );
        circleSprite.graphics.drawCircle( 0, 0, 60 );
        circleSprite.graphics.endFill();

        circleSprite.x = 0;
        circleSprite.y = 0;


        circleSprite.addEventListener( MouseEvent.CLICK, moveCircleAway );

        this.addChild( circleSprite );


        var crossSprite : Sprite = new Sprite();
        crossSprite.graphics.beginFill( 0x000000 );
        crossSprite.graphics.drawRect( -10.0, 0.5, 20, 1 );
        crossSprite.graphics.drawRect( 0.5, -10.0, 1, 20 );
        crossSprite.graphics.endFill();

        this.addChild( crossSprite );

        var crossSpriteX : Int = 120;
        var crossSpriteY : Int = 400;

        crossSprite.x = crossSpriteX;
        crossSprite.y = crossSpriteY;



        var textFormat02 : TextFormat = new TextFormat( "Verdana" );

        textFormat02.size =  12;
        textFormat02.color = 0x000000;
        textFormat02.leftMargin = 0;
        textFormat02.rightMargin = 0;
        textFormat02.align = TextFormatAlign.LEFT;



        var crossSpriteText : TextField = new TextField();
        crossSpriteText.defaultTextFormat = textFormat02;

        crossSpriteText.text = "{ x : 20, y : 400 }";

        crossSpriteText.x = crossSpriteX;
        crossSpriteText.y = crossSpriteY;

        this.addChild( crossSpriteText );

        trace( "crossSpriteText.width: " + crossSpriteText.width );

        trace( "--------------------" );
        trace( "hintTextfield.textWidth: " + hintTextfield.textWidth );
        trace( "hintTextfield.textHeight: " + hintTextfield.textHeight );


        var zeroStretchSprite : Sprite = new Sprite();
        zeroStretchSprite.x = 5;
        zeroStretchSprite.y = 5;

        zeroStretchSprite.width = 0;
        zeroStretchSprite.height = 0;

        addChild( zeroStretchSprite );


        var button03Origin : openfl.geom.Point = new openfl.geom.Point( button03.x, button03.y );
        var globalButtonOrigin : openfl.geom.Point = button03.localToGlobal( button03Origin );

        trace( "globalButtonOrigin: " + globalButtonOrigin );

        var borderSprite : Sprite = new Sprite();

        addChild( borderSprite );
        borderSprite.x = 350;
        borderSprite.y = 350;


        borderSprite.graphics.lineStyle( 3, 0xaa0000, 1.0 );
        var stage : Stage = Lib.current.stage;

        borderSprite.graphics.lineTo( stage.width/ 2, stage.height/ 2 );
        borderSprite.graphics.drawRect( 0, 0, 50.0, 50.0 );



       /* borderSprite.graphics.beginFill( 0, 0.5 );
        borderSprite.graphics.drawRect( 0, 0, 300.0, 300.0 );
        borderSprite.graphics.endFill();*/

        // borderSprite.graphics.lineStyle( 3, 0xaa0000, 1.0 );
        // borderSprite.graphics.line( 3, 0xaa0000, 1.0 );






/*
// Todo: Reactivate if necessary   ( inheritance of relative coordinates and width and height )  ...
// How does displayObj.localToGlobal(...) work?
button03.x = -10.0;
button03.y = -10.0;
button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "globalButtonOrigin after moving: " + globalButtonOrigin );

var button03ParentSprite : Sprite = new Sprite();

this.addChild( button03ParentSprite );



button03ParentSprite.addChild( button03 );

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "globalButtonOrigin after relinking: " + globalButtonOrigin );
trace( "default button03ParentSprite.width: " + button03ParentSprite.width );

button03ParentSprite.width = 0;
button03ParentSprite.height = 0;

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "globalButtonOrigin after resizing parent to zero: " + globalButtonOrigin );


button03.x = -10.0;
button03.y = -10.0;

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "... and then setting button03 to a negative point again: " + globalButtonOrigin );


var button03GrandParentSprite : Sprite = new Sprite();
this.addChild( button03ParentSprite );
button03GrandParentSprite.addChild( button03ParentSprite );

button03GrandParentSprite.x = 0;
button03GrandParentSprite.y = 0;

button03GrandParentSprite.width = 0;
button03GrandParentSprite.height = 0;

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "... when to parent sprites have an extend of 0: " + globalButtonOrigin );

button03.x = 10.0;
button03.y = 10.0;

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "... when the parent has an extend of 0 and the displayObject is moved to a positive point: " + globalButtonOrigin );

this.addChild( button03ParentSprite );
this.removeChild( button03GrandParentSprite );

button03ParentSprite.width = 100;
button03ParentSprite.height = 100;

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "... when the parent extends are for example 100: " + globalButtonOrigin );

button03ParentSprite.width = 500;
button03ParentSprite.height = 500;

button03Origin = new openfl.geom.Point( button03.x, button03.y );
globalButtonOrigin = button03.localToGlobal( button03Origin );

trace( "... increasing the extends to 500: " + globalButtonOrigin );
*/



        // var stage : Stage = Lib.current.stage;


        // code



/*
var sprite : Sprite = new Sprite();
addChild( sprite );


sprite.graphics.beginFill( 0xff1125 );
sprite.graphics.drawRect( 0, 0, 20, 20 );
sprite.graphics.endFill();

sprite.x = 200;
sprite.y = 200;

var circle : Sprite = new Sprite();
sprite.addChild( circle );
circle.x = -40;
circle.y = -40;

sprite.graphics.beginFill( 0xff1125 );
sprite.graphics.drawCircle( 0, 0, 10 );
sprite.graphics.endFill();
*/

    } // private function init() : Void

    public function moveCircleAway( mouseEvent : MouseEvent ) : Void
    {
        if( !circleMoved )
        {
            trace( "moveAway()" );
            var eventDispatcher : IEventDispatcher = mouseEvent.target; // mouseEvent.currentTarget; // cast( mouseEvent, DisplayObject );
            var displayObject : DisplayObject = cast( eventDispatcher, DisplayObject );
            displayObject.x = 250;
            displayObject.y = 250;


            var squareSprite  : Sprite = new Sprite();
            squareSprite.graphics.beginFill( 0xa21411 );
            squareSprite.graphics.drawRect( 0, 0, 120, 120 );
            squareSprite.graphics.endFill();

            this.addChild( squareSprite );

            squareSprite.addEventListener( MouseEvent.CLICK, moveSquareAwayCB );

            circleSprite.removeEventListener( MouseEvent.CLICK, moveCircleAway );

            circleMoved = true;
        } // if( circleMoved )

    } // public function moveAway( mouseEvent : MouseEvent ) : Void

    public function moveSquareAwayCB( mouseEvent : MouseEvent ) : Void
    {
        var eventDispatcher : IEventDispatcher = mouseEvent.target; // mouseEvent.currentTarget; // cast( mouseEvent, DisplayObject );
        var squareSprite : Sprite = cast( eventDispatcher, Sprite );

        if( !squareMoved )
        {

            squareSprite.x = 250;
            squareSprite.y = 250;

            hintTextfield.text = "HINT: The origine of the sprite holding a rectangle is topLeft.";
            squareMoved = true;
        } // if( !squareMoved )
        else
        {
            trace( "squareSprite.height: " + squareSprite.height );
            squareSprite.scaleY = 1.5;
            trace( "squareSprite.height: " + squareSprite.height );
        } // else
    } // public function moveSquareAway( mousEvent : MouseEvent ) : Void


    private function clickCB( mouseEvent : MouseEvent ) : Void
    {
        // mouseEvent.target
        var eventDispatcher : IEventDispatcher = mouseEvent.target; // mouseEvent.currentTarget; // cast( mouseEvent, DisplayObject );
        // mouseEvent.currentTarget;

        var text : String = "";

        var displayObject : DisplayObject = cast( eventDispatcher, DisplayObject );
        text = displayObject.name;

        buttonIdentification.text = text + " - Clicked: " + clickCounter; // displayObject.name;

        ++clickCounter;
    } // private function clickCB( mouseEvent : MouseEvent ) : Void

    /* SETUP */


    public function new() : Void
    {

        super();

        startDebugger();

        addEventListener(Event.ADDED_TO_STAGE, added);
        buttonMap = new Map<String, SimpleButton>();

        var hint : TextField = new TextField();
        var hintTextFormat : TextFormat = new TextFormat( "Arial", 12, 0x000000 );
        hint.defaultTextFormat = hintTextFormat;
        hintTextfield = hint;

        hint.text = "HINT: Without an offset when drawing a circle ( { x : 0, y : 0 } ) the sprite's origine lies at the radial center.";

        this.addChild( hint );
        hint.x = 20;
        hint.y = 150;


       //  layout = new Layout( 600, 400 );


hintTextFormat.color = 0xff0000;


    } // public function new() : Void



    function added( e )
    {

        removeEventListener( Event.ADDED_TO_STAGE, added );
        stage.addEventListener( Event.RESIZE, resize );

        #if ios
		    haxe.Timer.delay(init, 100); // iOS 6
		#else
            init();
        #end

    } //  function added( e )



    public static function main() : Void
    {
        // static entry point

        Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
        Lib.current.addChild(new Main());

        //

    } // public static function main() : Void

} // class Main extends Sprite


