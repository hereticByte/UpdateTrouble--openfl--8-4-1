package ;


import Marker.MarkedType;
import openfl.display.SimpleButton;


class SimpleButton_Marker extends SimpleButton implements Marker
{
    @:isVar public var id ( default, null ) : String;
    @:isVar public var type ( default, null ) : MarkedType;


    public function new( id : String, type : MarkedType )
    {
        super();
        this.id = id;
        this.type = type;
    } // public function new( id : String )
} // class SimpleButton_Marker extends SimpleButton implements Marker
