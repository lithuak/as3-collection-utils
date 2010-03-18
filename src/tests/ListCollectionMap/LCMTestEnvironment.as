package tests.ListCollectionMap
{
	import com.oitar.collections.ListCollectionMap;
	import com.oitar.collections.ListCollectionMapResult;
	
	import mx.collections.ArrayCollection;

	public class LCMTestEnvironment
	{
		public var lcm:ListCollectionMap;
		
		public var list_int:ArrayCollection 
		
		public var list_str:ArrayCollection
		
		public var list_obj:ArrayCollection 
		
		public function LCMTestEnvironment()
		{
			list_int = new ArrayCollection([1, 2 , 3])
			list_str = new ArrayCollection(["a", "b" , "c"])
			list_obj = new ArrayCollection([{'i': 1}, {'i': 2} , {'i': 3}])
		}
		
		public function f_inc(item:Object):Object {
			
			return item + 1
		}
		
		public function f_str(item:Object):Object {
			
			return "*" + item + "*"
		}
		
		public function f_multi(item:Object):Object {
			
			return new ListCollectionMapResult(item, item) 
		}
		
		[Before]
		public function prepare():void 
		{
			
			lcm = new ListCollectionMap(f_inc, list_int)
		} 
		
		[After]
		public function clean():void 
		{
			
			lcm = null
		} 
}
}