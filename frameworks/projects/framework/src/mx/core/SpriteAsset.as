////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.core
{

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.Matrix;

import mx.core.AdvancedLayoutFeatures;

/**
 *  SpriteAsset is a subclass of the flash.display.Sprite class which
 *  represents vector graphic images that you embed in an application.
 *  It implements the IFlexDisplayObject interface, which makes it
 *  possible for an embedded vector graphic image to be displayed in an Image
 *  control, or to be used as a container background or a component skin.
 *
 *  <p>The vector graphic image that you're embedding can be in an SVG file.
 *  You can also embed a sprite symbol that is in a SWF file produced
 *  by Flash.
 *  In both cases, the MXML compiler autogenerates a class that extends
 *  SpriteAsset to represent the embedded vector graphic image.</p>
 *
 *  <p>You don't generally have to use the SpriteAsset class directly
 *  when you write a Flex application.
 *  For example, you can embed a sprite symbol from a SWF file and display
 *  it in an Image control by writing the following:</p>
 *
 *  <pre>
 *  &lt;mx:Image id="logo" source="&#64;Embed(source='Assets.swf', symbol='Logo')"/&gt;</pre>
 *
 *  <p>Or use it as the application's background image in CSS syntax
 *  by writing the following:</p>
 *
 *  <pre>
 *  &lt;fx:Style&gt;
 *      &#64;namespace mx "library://ns.adobe.com/flex/mx"
 *      mx|Application {
 *          backgroundImage: Embed(source="Assets.swf", symbol='Logo')
 *      }
 *  &lt;fx:Style/&gt;</pre>
 *
 *  <p>without having to understand that the MXML compiler has created
 *  a subclass of BitmapAsset for you.</p>
 *
 *  <p>However, it may be useful to understand what is happening
 *  at the ActionScript level.
 *  To embed a vector graphic image in ActionScript, you declare a variable
 *  of type Class, and put <code>[Embed]</code> metadata on it.
 *  For example, you embed a sprite symbol from a SWF file like this:</p>
 *
 *  <pre>
 *  [Bindable]
 *  [Embed(source="Assets.swf", symbol="Logo")]
 *  private var logoClass:Class;</pre>
 *
 *  <p>The MXML compiler notices that the Logo symbol in Assets.swf
 *  is a sprite, autogenerates a subclass of the SpriteAsset class
 *  to represent it, and sets your variable to be a reference to this
 *  autogenerated class.
 *  You can then use this class reference to create instances of the
 *  SpriteAsset using the <code>new</code> operator, and use APIs
 *  of the Sprite class on them:</p>
 *
 *  <pre>
 *  var logo:SpriteAsset = SpriteAsset(new logoClass());
 *  logo.rotation=45;</pre>
 *
 *  <p>However, you rarely need to create SpriteAsset instances yourself
 *  because image-related properties and styles can simply be set to an
 *  image-producing class, and components will create image instances
 *  as necessary.
 *  For example, to display this vector graphic image in an Image control,
 *  you can set the Image's <code>source</code> property to
 *  <code>logoClass</code>.
 *  In MXML you could do this as follows:</p>
 *
 *  <pre>
 *  &lt;mx:Image id="logo" source="{logoClass}"/&gt;</pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SpriteAsset extends FlexSprite
                         implements IFlexAsset, IFlexDisplayObject, IBorder,
                                    ILayoutDirectionElement
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SpriteAsset()
    {
        super();

        // Remember initial size as our measured size.
        _measuredWidth = width;
        _measuredHeight = height;
        
        if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
            this.addEventListener(Event.ADDED, addedHandler);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    private var layoutFeatures:AdvancedLayoutFeatures;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  x
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get x():Number
    {
        // TODO(hmuller): by default get x returns transform.matrix.tx rounded to the nearest 20th.
        // should do the same here, if we're returning layoutFeatures.layoutX.
        return (layoutFeatures == null) ? super.x : layoutFeatures.layoutX;
    }
    
    /**
     *  @private
     */
    override public function set x(value:Number):void
    {
        if (x == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.x = value;
        }
        else
        {
            layoutFeatures.layoutX = value;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  y
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get y():Number
    {
        return (layoutFeatures == null) ? super.y : layoutFeatures.layoutY;
    }
    
    /**
     *  @private
     */
    override public function set y(value:Number):void
    {
        if (y == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.y = value;
        }
        else
        {
            layoutFeatures.layoutY = value;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  z
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get z():Number
    {
        return (layoutFeatures == null) ? super.z : layoutFeatures.layoutZ;
    }
    
    /**
     *  @private
     */
    override public function set z(value:Number):void
    {
        if (z == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.z = value;
        }
        else
    {
            layoutFeatures.layoutZ = value;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  width
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get width():Number
    {
        return (layoutFeatures == null) ? super.width : layoutFeatures.layoutWidth;
    }
    
    /**
     *  @private
     */
    override public function set width(value:Number):void
    {
        if (width == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.width = value;
        }
        else
        {
            layoutFeatures.layoutWidth = value;
            // Calculate scaleX based on initial width. We set scaleX
            // here because resizing a BitmapAsset normally would adjust
            // the scale to match.
            layoutFeatures.layoutScaleX = measuredWidth != 0 ? value / measuredWidth : 0;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  height
    //----------------------------------
    
    private var _height:Number;
    
    /**
     *  @private
     */
    override public function get height():Number
    {
        return (layoutFeatures == null) ? super.height : _height;
    }
    
    /**
     *  @private
     */
    override public function set height(value:Number):void  
    {
        if (height == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.height = value;
        }
        else
        {
            _height = value;
            // Calculate scaleY based on initial height. We set scaleY
            // here because resizing a BitmapAsset normally would adjust
            // the scale to match.
            layoutFeatures.layoutScaleY = measuredHeight != 0 ? value / measuredHeight : 0;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  rotation
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get rotationX():Number
    {
        return (layoutFeatures == null) ? super.rotationX : layoutFeatures.layoutRotationX;
    }
    
    /**
     *  @private
     */
    override public function set rotationX(value:Number):void
    {
        if (rotationX == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.rotationX = value;
        }
        else
        {
            layoutFeatures.layoutRotationX = value;
            validateTransformMatrix();
        }
    }
    /**
     *  @private
     */
    override public function get rotationY():Number
    {
        return (layoutFeatures == null) ? super.rotationY : layoutFeatures.layoutRotationY;
    }
    
    /**
     *  @private
     */
    override public function set rotationY(value:Number):void
    {
        if (rotationY == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.rotationY = value;
        }
        else
        {
            layoutFeatures.layoutRotationY = value;
            validateTransformMatrix();
        }
    }
    
    /**
     *  @private
     */
    override public function get rotationZ():Number
    {
        return (layoutFeatures == null) ? super.rotationZ : layoutFeatures.layoutRotationZ;
    }
    
    /**
     *  @private
     */
    override public function set rotationZ(value:Number):void
    {
        if (rotationZ == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.rotationZ = value;
        }
        else
        {
            layoutFeatures.layoutRotationZ = value;
            validateTransformMatrix();
        }
    }
    
    /**
     *  @private
     */
    override public function get rotation():Number
    {
        return (layoutFeatures == null) ? super.rotation : layoutFeatures.layoutRotationZ;
    }
    
    /**
     *  @private
     */
    override public function set rotation(value:Number):void
    {
        rotationZ = value;
    }
    
    //----------------------------------
    //  scaleX
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get scaleX():Number
    {
        return (layoutFeatures == null) ? super.scaleX : layoutFeatures.layoutScaleX;
    }
    
    /**
     *  @private
     */
    override public function set scaleX(value:Number):void
    {
        if (scaleX == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.scaleX = value;
        }
        else
        {
            layoutFeatures.layoutScaleX = value;
            layoutFeatures.layoutWidth = value * measuredWidth;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  scaleY
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get scaleY():Number
    {
        return (layoutFeatures == null) ? super.scaleY : layoutFeatures.layoutScaleY;
    }
    
    /**
     *  @private
     */
    override public function set scaleY(value:Number):void
    {
        if (scaleY == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.scaleY = value;
        }
        else
        {
            layoutFeatures.layoutScaleY = value;
            _height = value * measuredHeight;
            validateTransformMatrix();
        }
    }
    
    //----------------------------------
    //  scaleZ
    //----------------------------------
    
    /**
     *  @private
     */
    override public function get scaleZ():Number
    {
        return (layoutFeatures == null) ? super.scaleZ : layoutFeatures.layoutScaleZ;
    }
    
    /**
     *  @private
     */
    override public function set scaleZ(value:Number):void
    {
        if (scaleZ == value)
            return;
        
        if (layoutFeatures == null)
        {
            super.scaleZ = value;
        }
        else
        {
            layoutFeatures.layoutScaleZ = value;
            validateTransformMatrix();
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  layoutDirection
    //----------------------------------
    
    private var _layoutDirection:String = LayoutDirection.LTR;
    
    [Inspectable(category="General", enumeration="ltr,rtl")]
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.1
     */
    public function get layoutDirection():String
    {
        return _layoutDirection;
    }
    
    public function set layoutDirection(value:String):void
    {
        if (value == _layoutDirection)
            return;
        
        _layoutDirection = value;
        invalidateLayoutDirection();
    }

    //----------------------------------
    //  measuredHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the measuredHeight property.
     */
    private var _measuredHeight:Number;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredHeight():Number
    {
        return _measuredHeight;
    }

    //----------------------------------
    //  measuredWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the measuredWidth property.
     */
    private var _measuredWidth:Number;

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get measuredWidth():Number
    {
        return _measuredWidth;
    }

    //----------------------------------
    //  borderMetrics
    //----------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get borderMetrics():EdgeMetrics
    {       
        if (scale9Grid == null)
        {
            return EdgeMetrics.EMPTY;   
        }
        else
        {
            return new EdgeMetrics(scale9Grid.left,
                                   scale9Grid.top,
                                   Math.ceil(measuredWidth - scale9Grid.right),
                                   Math.ceil(measuredHeight - scale9Grid.bottom));  
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.1
     */
    public function invalidateLayoutDirection():void
    {
        var p:DisplayObjectContainer = parent;

        // We check the closest parent's layoutDirection property
        // to create or destroy layoutFeatures if needed.
        while (p)
        {
            if (p is ILayoutDirectionElement)
            {
                // mirror is true if our layoutDirection differs from our parent's.
                var mirror:Boolean = (_layoutDirection != null) &&
                    (_layoutDirection != ILayoutDirectionElement(p).layoutDirection);
                
                // If our layoutDirection is different from our parent's and if it used to
                // be the same, create layoutFeatures to handle mirroring.
                if (mirror && layoutFeatures == null)
                {
                    initAdvancedLayoutFeatures();
                    layoutFeatures.mirror = mirror;
                    validateTransformMatrix();
                }
                else if (!mirror && layoutFeatures)
                {
                    // If our layoutDirection is not different from our parent's and if
                    // it used to be different, then recover our matrix and remove layoutFeatures.
                    layoutFeatures.mirror = mirror;
                    validateTransformMatrix();
                    layoutFeatures = null;
                }
                
                break;
            }
            
            p = p.parent;
        }
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function move(x:Number, y:Number):void
    {
        this.x = x;
        this.y = y;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setActualSize(newWidth:Number, newHeight:Number):void
    {
        width = newWidth;
        height = newHeight;
    }
    
    /**
     *  @private
     */
    private function addedHandler(event:Event):void
    {
        invalidateLayoutDirection();
    }
    
    /**
     *  @private
     *  Initializes AdvancedLayoutFeatures for this asset when mirroring.
     */
    private function initAdvancedLayoutFeatures():void
    {
        var features:AdvancedLayoutFeatures = new AdvancedLayoutFeatures();
        
        features.layoutScaleX = scaleX;
        features.layoutScaleY = scaleY;
        features.layoutScaleZ = scaleZ;
        features.layoutRotationX = rotationX;
        features.layoutRotationY = rotationY;
        features.layoutRotationZ = rotation;
        features.layoutX = x;
        features.layoutY = y;
        features.layoutZ = z;
        features.layoutWidth = width;  // for the mirror transform
        _height = height;  // for backing storage
        layoutFeatures = features;
    }
    
    /**
     *  @private
     *  Applies the transform matrix calculated by AdvancedLayoutFeatures 
     *  so that this bitmap will not be mirrored if a parent is mirrored.
     */
    private function validateTransformMatrix():void
    {
        if (layoutFeatures != null)
        {
            if (layoutFeatures.is3D)
                super.transform.matrix3D = layoutFeatures.computedMatrix3D;
            else
                super.transform.matrix = layoutFeatures.computedMatrix;
        }
    }
}

}
