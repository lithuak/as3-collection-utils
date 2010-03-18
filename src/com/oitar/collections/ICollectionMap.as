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

/**
 *  Dispatched when the ICollectionView has been updated in some way.
 *
 *  @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
 */
[Event(name="collectionChange", type="mx.events.CollectionEvent")]


/**
 * 
 * The ICollectionMap is a mapping of a collection of data.
 * 
 */
public interface ICollectionMap
{
	
	/**
	 * A function that is applied to each item to perform
	 * an actual mapping.
	 * 
	 * A mapFunction is expected to have the following signature:
	 *
	 * <pre>f(item:Object):Object</pre>
	 *
	 * where the return value is any object for one-to-one mapping
	 * or ListCollectionViewResult instance for one-to-many mapping.
	 * 
	 * The mapping function is mandatory and must be specified when
	 * calling the constructor. Later it can be changed by setting this
	 * property.
	 *
	 */	
	function get mapFunction():Function;
	
	/**
	 * @private
	 */ 
	function set mapFunction(value:Function):void;
	
	/**
	 * Clears resulting collection and creates it from scratch
	 */
	function refresh():void;
}
}