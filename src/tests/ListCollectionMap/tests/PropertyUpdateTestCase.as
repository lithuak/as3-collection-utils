package tests.ListCollectionMap.tests
{
	import com.oitar.collections.ListCollectionMap;
	import com.oitar.collections.ListCollectionMapResult;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.utils.ObjectProxy;
	
	import org.flexunit.assertThat;
	import org.fluint.sequence.SequenceRunner;
	import org.fluint.sequence.SequenceWaiter;
	import org.hamcrest.object.equalTo;

	public class PropertyUpdateTestCase
	{
		public var lcm:ListCollectionMap;
		
		public var list:ArrayCollection 
		
		public function f_map(item:Object):Object {
			
			item.c = item.a + item.b
			
			return new ListCollectionMapResult(item, item) 
		}
		
		[Before]
		public function initListUpdateCase():void 
		{
			list = new ArrayCollection([
										new ObjectProxy({ 'a': 1, 'b': 2, 'o': new ObjectProxy({ 'p': 1 })}),
										new ObjectProxy({ 'a': 100, 'b': 200, 'o': new ObjectProxy({ 'p': 1 })}),
										new ObjectProxy({ 'a': 30, 'b': 40, 'o': new ObjectProxy({ 'p': 1 })})
									   ])

			lcm = new ListCollectionMap(f_map, list)
		}

		[Test(description="item property update",async)]
		public function propertyUpdate():void 
		{
			var seq:SequenceRunner = new SequenceRunner(this)
			seq.addStep(new SequenceWaiter(lcm, CollectionEvent.COLLECTION_CHANGE, 500))				
			seq.addStep(new SequenceWaiter(lcm, CollectionEvent.COLLECTION_CHANGE, 500))
			seq.run()
				
			list[1].o.a = 5
			
		}

		[Test(description="item subproperty update",async)]
		public function subpropertyUpdate():void 
		{
			var seq:SequenceRunner = new SequenceRunner(this)
			seq.addStep(new SequenceWaiter(lcm, CollectionEvent.COLLECTION_CHANGE, 500))				
			seq.addStep(new SequenceWaiter(lcm, CollectionEvent.COLLECTION_CHANGE, 500))
			seq.run()
				
			list[1].o.p = 5
		}
		
		public function assertAfterUpdateState():void 
		{
			var should_be:Array = []
			
			for each(var i:int in list) 
			{
				should_be.push(f_map(i))
				should_be.push(f_map(i))
			}
			
			assertThat(lcm.toArray(), equalTo(should_be))
		}
	}
}