package com.oitar.collections
{
	import mx.utils.ObjectUtil;

	public dynamic class ListCollectionMapResult extends Array 
	{
		public function ListCollectionMapResult(... args) {
			
			super()
			
			for each(var arg:Object in args) 
			{
				push(arg)
			}
		}
	}
}