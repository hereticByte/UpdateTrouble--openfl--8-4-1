package ;


@:enum abstract MarkedType ( Int )
{
    public var sprite_marker = 0;
    public var textField_marker = 1;
    public var bitmap_marker = 2;
    public var simpleButton_marker = 3;
} // @:enum abstract MarkedType ( Int )

interface Marker
{
    @:isVar public var id ( default, null ) : String;
    @:isVar public var type ( default, null ) : MarkedType;
} // interface Marker
