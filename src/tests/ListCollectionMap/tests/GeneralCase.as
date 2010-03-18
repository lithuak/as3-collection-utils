package tests.ListCollectionMap.tests
{
	import org.flexunit.Assert;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	
	import tests.ListCollectionMap.LCMTestEnvironment;
	
	public class GeneralCase extends LCMTestEnvironment
	{
		
		[Test(description="Creation and initial state of list, map function and localIndex")]
		public function creation():void 
		{
			Assert.assertNotNull(lcm)
			Assert.assertEquals(list_int, lcm.list)
			Assert.assertEquals(f_inc, lcm.mapFunction)
			assertThat(lcm.toArray(), array(2, 3, 4))
		}

		[Test(description="Setter raises exception if mapFunction is null",expects="ArgumentError")]
		public function raisesNullMapFunction():void 
		{
			lcm.mapFunction = null
		}

		[Test(description="The result array gets cleared when the list is nulled")]
		public function clearsOnNullList():void 
		{
			lcm.list = null
			
			assertThat(lcm.toArray(), array())
		}

		[Test(description="list setter update event",async,timeout=200)]
		public function listSetterDispatchesUpdate():void {
			
			Async.proceedOnEvent(this, lcm, "listChanged")
				
			lcm.list = list_str
		}

		[Test(description="mapFunction setter update event",async,timeout=200)]
		public function mapFunctionSetterDispatchesUpdate():void {
			
			Async.proceedOnEvent(this, lcm, "mapFunctionChanged")
			
			lcm.mapFunction = f_str 
		}

		[Test(description="ListCollectionMapResult smoke test")]
		public function smokeLCMR():void {
			
			lcm.mapFunction = f_multi
			assertThat(lcm.toArray(), array(1, 1, 2, 2, 3, 3))
		}
		
	
	}
}