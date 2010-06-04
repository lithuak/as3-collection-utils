package com.oitar.collections
{
	import mx.utils.ObjectUtil;

	/**
	 * The ListCollectionMapResult helps to implement one-to-many mapping for ListCollectionMap.
	 * Use it in your mapping function to let the ListCollectionMap know that you are 
	 * about to return the sequence of objects corresponding to one source item.       
	 */
	public dynamic class ListCollectionMapResult extends Array 
	{
		/**
		 *  The ListCollectionMapResult constructor.
		 *
		 *  @param args the elements to form a sequence
		 *  
		 */
		public function ListCollectionMapResult(... args) {
			
			super()
			
			for each(var arg:Object in args) 
			{
				push(arg)
			}
		}
		
		/**
		 * This is a factory method that you probably want to use when the
		 * sequence that you whant to return is formed in the array and
		 * you can't pass it to the constructor as an explicit set of argumets. 
		 *  
		 *  @param args the elements to form a sequence
		 *  
		 */
		public static function fromArray(items:Array):ListCollectionMapResult
		{
			var self:ListCollectionMapResult = new ListCollectionMapResult()
			
			for each(var item:Object in items) 
			{
				self.push(item)
			}
			
			return self
		}
	}
}