package tests.ListCollectionMap.tests
{
	import com.oitar.collections.ListCollectionMap;
	import com.oitar.collections.ListCollectionMapResult;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;
	
	public class ListUpdatesCase
	{
		
		public var lcm:ListCollectionMap;

		public var list_int:ArrayCollection 

		public function f_inc(item:Object):Object {
			
			return item + 1
		}
		
		public function f_multi(item:Object):Object {
			
			return new ListCollectionMapResult(f_inc(item), f_inc(item)) 
		}
		
		[Before]
		public function initListUpdateCase():void 
		{
			list_int = new ArrayCollection([1, 2, 3, 4, 5, 6, 7, 8, 9, 0])
			lcm = new ListCollectionMap(f_multi, list_int)
		}
		
		private function add_item_test(item:int, index:int):void {
			
			register_responder(CollectionEventKind.ADD)
		
			list_int.addItemAt(item, index)
		}

		[Test(description="ADD1",async)]
		public function ADD1():void 
		{
			register_responder(CollectionEventKind.ADD)
			list_int.addItem(20)

			register_responder(CollectionEventKind.ADD)
			list_int.addItem(30)
		}
		
		[Test(description="ADD2",async)]
		public function ADD2():void 
		{
			add_item_test(88, 0)
			add_item_test(99, 2)
			add_item_test(111, 1)
			add_item_test(222, 2)
			add_item_test(333, 4)
			add_item_test(444, 0)
			register_responder(CollectionEventKind.ADD)
			list_int.addItem(20)
			add_item_test(555, 6)
		}

		[Test(description="ADD all",async)]
		public function ADD3():void 
		{
			var list_to_add:ArrayCollection = new ArrayCollection([17, 189, 500])

			register_responder(CollectionEventKind.ADD)
			list_int.addAll(list_to_add)
			
			register_responder(CollectionEventKind.ADD)
			list_int.addAllAt(list_to_add, 0)

			register_responder(CollectionEventKind.ADD)
			list_int.addAllAt(list_to_add, 5)
		}

		[Test(description="REMOVE",async)]
		public function REMOVE():void
		{
			register_responder(CollectionEventKind.REMOVE)
			list_int.removeItemAt(0)
			register_responder(CollectionEventKind.REMOVE)
			list_int.removeItemAt(0)
			register_responder(CollectionEventKind.ADD)
			list_int.addItemAt(12, 0)
			register_responder(CollectionEventKind.REMOVE)
			list_int.removeItemAt(0)
			register_responder(CollectionEventKind.REMOVE)
			list_int.removeItemAt(5)
			register_responder(CollectionEventKind.REMOVE)
			list_int.removeItemAt(list_int.length-1)
			register_responder(CollectionEventKind.ADD)
			list_int.addItem(0)
		}

		[Test(description="REMOVE all",async)]
		public function REMOVE_ALL():void
		{
			register_responder(CollectionEventKind.RESET)
			list_int.removeAll()			
		}

		[Test(description="REPLACE",async)]
		public function REPLACE():void
		{
			// has to wait for two events, may be will test it properly later...
			list_int.setItemAt(555, 0)
		}

		private function register_responder(kind:String = ""):void {
			
			Async.handleEvent(this, lcm, CollectionEvent.COLLECTION_CHANGE, on_list_change_event, 500, kind)
		}
		
		public function on_list_change_event(event:CollectionEvent, kind:String):void {

			var should_be:Array = []
				
			for each(var i:int in list_int) 
			{
				should_be.push(f_inc(i))
				should_be.push(f_inc(i))
			}
			
			assertThat(lcm.toArray(), equalTo(should_be))
			
			if(kind)
				assertThat(event.kind, equalTo(kind))
		}
		
	}
}