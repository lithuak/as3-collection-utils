package tests.ListCollectionMap.tests
{
	import flash.events.Event;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	
	import tests.ListCollectionMap.LCMTestEnvironment;

	public class IEventDispatcherCase extends LCMTestEnvironment
	{
		[Test(description="IEventDispatcher.addEventListener")]
		public function addEventListener():void
		{
			lcm.addEventListener("testevent", function ():void {});
			
			Assert.assertTrue(lcm.hasEventListener("testevent"))
		}
		
		[Test(description="IEventDispatcher.removeEventListener")]
		public function removeEventListener():void
		{
			
			var f:Function = function ():void {}
			
			lcm.addEventListener("testevent", f);
			
			Assert.assertTrue(lcm.hasEventListener("testevent"))

			lcm.removeEventListener("testevent", f) 
			
			Assert.assertFalse(lcm.hasEventListener("testevent"))
		}
		
		[Test(description="IEventDispatcher.dispatchEvent",async,timeout=200)]
		public function dispatchEvent():void
		{
			Async.proceedOnEvent(this, lcm, "testevent")

			lcm.dispatchEvent(new Event("testevent"));
		}
		
		[Test(description="IEventDispatcher.hasEventListener")]
		public function hasEventListener():void
		{
			// already tested with above tests
		}
		
		[Test(description="IEventDispatcher.willTrigger")]
		public function willTrigger():void
		{
			lcm.addEventListener("testevent", function ():void {});
			
			Assert.assertTrue(lcm.hasEventListener("testevent"))

			Assert.assertFalse(lcm.hasEventListener("testevent2"))
		}
	}
}