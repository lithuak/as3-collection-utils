/*
*
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
* 
*  The Original Code is [ Adobe Flex SDK ]
* 
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2005-2007 
*  Adobe Systems Incorporated. All Rights Reserved. 
* 
*  Contributor(s): Adobe Systems Incorporated
*                  Ilya Persky <ilya.persky@gmail.com>
*
*/
package com.oitar.collections
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	import mx.collections.IList;
	import mx.core.IMXMLObject;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

/**
 *  Dispatched when the ICollectionMap has been updated in some way.
 *
 *  @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
 */
[Event(name="collectionChange", type="mx.events.CollectionEvent")]

/**
 * The ListCollectionMap lets you create the mapping of some IList object    
 * as a collection. It acts the same way as ListCollectionView, but instead
 * of sorting and filtering ListCollectionMap allows you to define
 * 'map' function that will evaluate mapping opperation for each item of the source
 * list. 
 * 
 * ListCollectionMap implements IList interface and can be linked in chains
 * with other ICollectionView and ICollectionMap objects.
 * 
 * ListCollectionMap provides read-only interface, any attempts to change
 * the resulting collection will end up throwing an exception. 
 * 
 * However you can change 
 * the source collection and it will make the resulting collection update automatically.     
 */
public class ListCollectionMap extends Proxy
	implements ICollectionMap, IList, IMXMLObject
{
	protected static const ILLEGAL_OP_MSG:String = "ListCollectionMap is immutable" 
	
	//--------------------------------------------------------------------------
	//
	// Private variables
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 *  <code>localIndex</code> property contains the array of mapped items
	 */
	private var localIndex:Array
	
	/**
	 * @private
	 *  <code>indexMap</code> contains the mapping of indexes of source list
	 * items to indexes of mapped items in localIndex
	 */
	private var indexMap:Array
	
	/**
	 *  @private
	 *  Internal event dispatcher.
	 */
	private var eventDispatcher:EventDispatcher;
	
	/**
	 *  @private
	 *  Used for accessing localized Error messages.
	 */
	private var resourceManager:IResourceManager =
		ResourceManager.getInstance();

	//--------------------------------------------------------------------------
	//
	// Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  The ListCollectionMap constructor.
	 *
	 *  @param mapFunction the function that will perform mapping for each item.
	 *  @param list the IList this ListCollectionView is meant to wrap.
	 *  
	 */
	public function ListCollectionMap(mapFunction:Function, list:IList = null)
	{
		super();

		eventDispatcher = new EventDispatcher(this);

		this.list = list
		this.mapFunction = mapFunction
		
		internalRefresh(false)
	}

	//----------------------------------
	//  list
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the list property.
	 */
	private var _list:IList;
	
	[Inspectable(category="General")]
	[Bindable("listChanged")]
	
	/**
	 *  The IList that this collection view wraps.
	 */
	public function get list():IList
	{
		return _list;
	}
	
	/**
	 *  @private
	 */
	public function set list(value:IList):void
	{
		if(_list == value)
			return
			
		var oldHasItems:Boolean;
		var newHasItems:Boolean;
		if (_list)
		{
			_list.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
				listChangeHandler);
			oldHasItems = _list.length > 0;
		}
		
		_list = value;
		
		if (_list)
		{
			_list.addEventListener(CollectionEvent.COLLECTION_CHANGE,
				listChangeHandler, false, 0, true);
			newHasItems = _list.length > 0;
		}
		
		if (oldHasItems || newHasItems)
			internalRefresh(true)

		dispatchEvent(new Event("listChanged"))
	}
	

	//----------------------------------
	//  mapFunction
	//----------------------------------
	
	/**
	 *  @private
	 *  Storage for the filterFunction property.
	 */
	private var _mapFunction:Function;
	
	[Inspectable(category="General")]
	[Bindable("mapFunctionChanged")]
	
	/**
	 *  @inheritDoc
	 */
	public function get mapFunction():Function
	{
		return _mapFunction;
	}

	/**
	 *  @private
	 */
	public function set mapFunction(value:Function):void
	{
		// *! chnage to TypeError #2007
		if(value == null || !(value is Function))
			throw new ArgumentError("mapFunction can't be undefined");
		
		if(_mapFunction == value)
			return

		_mapFunction = value
		
		dispatchEvent(new Event("mapFunctionChanged"))

		internalRefresh(true)
	}

	/**
	 * @inheritDoc 
	 */
	public function refresh():void 
	{
		internalRefresh(true)	
	}
	
	//--------------------------------------------------------------------------
	//
	// IList Methods
	//
	//--------------------------------------------------------------------------

	[Bindable("collectionChange")]

	/**
	 *  The number of items in this collection. 
	 *  0 means no items while -1 means the length is unknown. 
	 */  
	public function get length():int
	{

		return localIndex.length
	}

	[Bindable("collectionChange")]

	/**
	 * @inheritDoc 
	 */  
	public function getItemAt(index:int, prefetch:int = 0):Object
	{
		if (index < 0 || index >= length)
		{
			var message:String = resourceManager.getString(
				"collections", "outOfBounds", [ index ]);
			throw new RangeError(message);
		}
		
		if (localIndex)
		{
			return localIndex[index];
		}
		
		return null;
	}

	/**
	 * @inheritDoc 
	 */  
	public function getItemIndex(item:Object):int
	{
		for (var i:int = 0; i < localIndex.length; i++)
		{
			if (localIndex[i] == item)
				return i;
		}
		
		return -1;
	}

	/**
	 * @inheritDoc 
	 */  
	public function toArray():Array
	{
		return localIndex.concat()
	}
	
	/**
	 * This method of IList interface should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	public function itemUpdated(item:Object, 
								property:Object = null,
								oldValue:Object = null,
								newValue:Object = null):void
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
	
	/**
	 * This method of IList interface should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	public function setItemAt(item:Object, index:int):Object
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
	
	/**
	 * This method of IList interface should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	public function addItem(item:Object):void
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
	
	/**
	 * This method of IList interface should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	public function addItemAt(item:Object, index:int):void
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
		
	/**
	 * This method of IList interface should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	public function removeItemAt(index:int):Object
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
	
	/**
	 * This method of IList interface should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	public function removeAll():void
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
	
	//--------------------------------------------------------------------------
	//
	// IMXMLObject
	//
	//--------------------------------------------------------------------------

	/**
	 *  Called automatically by the MXML compiler when the ListCollectionMap
	 *  is created using an MXML tag.  
	 *  If you create the ListCollectionMap through ActionScript, you 
	 *  must call this method passing in the MXML document and 
	 *  <code>null</code> for the <code>id</code>.
	 *
	 *  @param document The MXML document containing this ListCollectionMap.
	 *
	 *  @param id Ignored.
	 */
	public function initialized(document:Object, id:String):void
	{
		refresh()
	}

	//--------------------------------------------------------------------------
	//
	// EventDispatcher methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc 
	 */  
	public function addEventListener(type:String,
									 listener:Function,
									 useCapture:Boolean = false,
									 priority:int = 0,
									 useWeakReference:Boolean = false):void
	{
		eventDispatcher.addEventListener(type, listener, useCapture,
			priority, useWeakReference);
	}
	
	/**
	 * @inheritDoc 
	 */  
	public function removeEventListener(type:String,
										listener:Function,
										useCapture:Boolean = false):void
	{
		eventDispatcher.removeEventListener(type, listener, useCapture);
	}
	
	/**
	 * @inheritDoc 
	 */  
	public function dispatchEvent(event:Event):Boolean
	{
		return eventDispatcher.dispatchEvent(event);
	}
	
	/**
	 * @inheritDoc 
	 */  
	public function hasEventListener(type:String):Boolean
	{
		return eventDispatcher.hasEventListener(type);
	}
	
	/**
	 * @inheritDoc 
	 */  
	public function willTrigger(type:String):Boolean
	{
		return eventDispatcher.willTrigger(type);
	}

	//--------------------------------------------------------------------------
	//
	// Proxy methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Attempts to call getItemAt(), converting the property name into an int.
	 */
	override flash_proxy function getProperty(name:*):*
	{
		if (name is QName)
			name = name.localName;
		
		var index:int = -1;
		try
		{
			var n:Number = parseInt(String(name));
			if (!isNaN(n))
				index = int(n);
		}
		catch(e:Error) // localName was not a number
		{
		}
		
		if (index == -1)
		{
			var message:String = resourceManager.getString(
				"collections", "unknownProperty", [ name ]);
			throw new Error(message);
		}
		else
		{
			return getItemAt(index);
		}
	}
	
	/**
	 * This method of Proxy class should not be called
	 * for ListCollectionMap. You have to modify the underlying
	 * list to affect the resulting collection.
	 * 
	 * @throws IllegalOperationError 
	 */  
	override flash_proxy function setProperty(name:*, value:*):void
	{
		throw IllegalOperationError(ILLEGAL_OP_MSG)
	}
	
	/**
	 *  @private
	 *  This is an internal function.
	 *  The VM will call this method for code like <code>"foo" in bar</code>
	 *  
	 *  @param name The property name that should be tested for existence.
	 */
	override flash_proxy function hasProperty(name:*):Boolean
	{
		if (name is QName)
			name = name.localName;
		
		var index:int = -1;
		try
		{
			var n:Number = parseInt(String(name));
			if (!isNaN(n))
				index = int(n);
		}
		catch(e:Error) // localName was not a number
		{
		}
		
		if (index == -1)
			return false;
		
		return index >= 0 && index < length;
	}
	
	/**
	 *  @private
	 */
	override flash_proxy function nextNameIndex(index:int):int
	{
		return index < length ? index + 1 : 0;
	}
	
	/**
	 *  @private
	 */
	override flash_proxy function nextName(index:int):String
	{
		return (index - 1).toString();
	}
	
	/**
	 *  @private
	 */
	override flash_proxy function nextValue(index:int):*
	{
		return getItemAt(index - 1);
	}    
	
	/**
	 *  @private
	 *  Any methods that can't be found on this class shouldn't be called,
	 *  so return null
	 */
	override flash_proxy function callProperty(name:*, ... rest):*
	{
		return null;
	}
	
	//--------------------------------------------------------------------------
	//
	// Internal methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private function internalRefresh(dispatch:Boolean):void {
		
		if(_mapFunction == null)
			return
		
		localIndex = []

		indexMap = []
			
		if(_list != null)
		{
			for(var i:uint = 0; i < _list.length; i++)
			{
				var item:Object = _list[i]
				
				var result:Object = _mapFunction(item)
				
				if(result is ListCollectionMapResult)
				{
					for each(var newItem:Object in result) 
					{
						localIndex.push(newItem)
						indexMap.push(i)
					}
				}
				else 
				{
					localIndex.push(result)
					indexMap.push(i)
				}
			}
		}

		if (dispatch)
		{
			var refreshEvent:CollectionEvent =
				new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			refreshEvent.kind = CollectionEventKind.REFRESH;
			dispatchEvent(refreshEvent);
		}
	}

	/**
	 *  @private
	 */
	private function listChangeHandler(event:CollectionEvent):void
	{
		switch (event.kind)
		{
			case CollectionEventKind.ADD:
				addItemsToMap(event.items, event.location);
				break;
			
			case CollectionEventKind.RESET:
				reset();
				break;

			case CollectionEventKind.REFRESH:
				internalRefresh(true)
				break;
			
			case CollectionEventKind.REMOVE:
				removeItemsFromMap(event.items, event.location);
				break;
			
			case CollectionEventKind.REPLACE:
				replaceItemsInMap(event.items, event.location);
				break;
			
			case CollectionEventKind.UPDATE:
				handlePropertyChangeEvents(event.items);
				break;
			
			default:
				dispatchEvent(event);
		} 
	}
	
	/**
	 *  @private
	 */
	private function addItemsToMap(items:Array, sourceLocation:int, dispatch:Boolean = true):void {
		
		var addedItems:Array = []

		var mappedLocation:int = indexMap.indexOf(sourceLocation)

		if(mappedLocation == -1)
			mappedLocation = indexMap.length
			
		var index:int = mappedLocation
		var sourceIndex:int = sourceLocation 

		for each(var item:Object in items) {

			var mappedItem:Object = _mapFunction(item)
			
			var result:Array = mappedItem is ListCollectionMapResult
							 ? mappedItem as Array
							 : [ mappedItem ];

			for each(var newItem:Object in result) 
			{
				localIndex.splice(index, 0, newItem) 
				indexMap.splice(index, 0, sourceIndex)
				addedItems.push(newItem)
				index++
			}

			// we have to increment all following indexes in indexMap
			for(var j:int = index; j < indexMap.length; j++)
				indexMap[j]++

			sourceIndex++
		}

		if (dispatch && addedItems.length > 0)
		{
			var event:CollectionEvent =
				new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.ADD;
			event.location = mappedLocation;
			event.items = addedItems;
			dispatchEvent(event);
		}
	}

	/**
	 *  @private
	 */
	private function removeItemsFromMap(items:Array, sourceLocation:int, dispatch:Boolean = true):void 
	{
		var len:int = items.length

		var startIndex:int = indexMap.indexOf(sourceLocation)
		var endIndex:int = indexMap.lastIndexOf(sourceLocation + len - 1)
		
		if(startIndex == -1 || endIndex == -1)
			throw RangeError("No such index to remove")

		var removedItems:Array = localIndex.slice(startIndex, endIndex + 1)
		localIndex.splice(startIndex, endIndex - startIndex + 1)
		indexMap.splice(startIndex, endIndex - startIndex + 1)
			
		for(var j:int = startIndex; j < indexMap.length; j++)
			indexMap[j]--

		if (dispatch && removedItems.length > 0)
		{
			var event:CollectionEvent =
				new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.REMOVE;
			event.location = startIndex
			event.items = removedItems;
			dispatchEvent(event);
		}
	}

	/**
	 *  @private
	 */
	private function reset():void
	{
		internalRefresh(false);

		var event:CollectionEvent =
			new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
		event.kind = CollectionEventKind.RESET;
		dispatchEvent(event);
	}

	/**
	 *  @private
	 */
	private function replaceItemsInMap(items:Array, sourceLocation:int, dispatch:Boolean = true):void 
	{
		var len:int = items.length;
		var oldItems:Array = [];
		var newItems:Array = [];
		for (var i:int = 0; i < len; i++)
		{
			var propertyEvent:PropertyChangeEvent = items[i];
			oldItems.push(propertyEvent.oldValue);
			newItems.push(propertyEvent.newValue);
		}
		removeItemsFromMap(oldItems, sourceLocation, dispatch);
		addItemsToMap(newItems, sourceLocation, dispatch);
	}
	
	/**
	 *  @private
	 */
	private function handlePropertyChangeEvents(items:Array):void 
	{
		for each(var event:PropertyChangeEvent in items) 
		{
			var item:Object = event.target
			var sourceLocation:int = _list.getItemIndex(item)

			if(indexMap.indexOf(sourceLocation) > 0)
			{
				removeItemsFromMap([item], sourceLocation)
				addItemsToMap([item], sourceLocation)
			}
		}
	}
}
}