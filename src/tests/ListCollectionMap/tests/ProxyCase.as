package tests.ListCollectionMap.tests
{
	import flash.utils.flash_proxy;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	
	import tests.ListCollectionMap.LCMTestEnvironment;

	public class ProxyCase extends LCMTestEnvironment
	{
		
		[Test(description="Proxy.getProperty")]
		public function getProperty():void
		{	
			var i:int = lcm[1] as int
			Assert.assertEquals(i, 3)
			
			i = lcm[2] as int
			Assert.assertEquals(i, 4)
			
			i = lcm[0] as int
			Assert.assertEquals(i, 2)
			
		}
		
		[Test(description="Proxy.getProperty index &lt; 0",expects="Error")]
		public function getPropertyEx1():void 
		{
			
			var i:int = lcm[-1] as int
		}
		
		[Test(description="Proxy.getProperty index &gt; length",expects="Error")]
		public function getPropertyEx2():void 
		{
			
			var i:int = lcm[3] as int
		}
		
		[Test(description="Proxy.getProperty not digit property",expects="Error")]
		public function getPropertyEx3():void 
		{
			
			var i:int = lcm['asasa'] as int
		}
		
		
		[Test(description="Proxy.setProperty",expects="TypeError")]
		public function setProperty():void
		{
			lcm[0] = 1
		}
		
		[Test(description="Proxy.hasProperty")]
		public function hasProperty():void
		{
			Assert.assertTrue(lcm.flash_proxy::hasProperty("2"))
			Assert.assertFalse(lcm.flash_proxy::hasProperty("3"))
		}
		
		[Test(description="Proxy: enumeration (nextIndex, nextIndexName, nextValue)")]
		public function enumeration():void
		{
			var result_index:Array = []
			var result_value:Array = []
			
			for(var i:String in lcm)
			{
				result_index.push(i)
			}
					
			assertThat(result_index, array("0", "1", "2"))

			for each(i in lcm)
			{
				result_value.push(i)
			}
			
			assertThat(result_value, array("2", "3", "4"))
}
		
		[Test(description="Proxy.callProperty")]
		public function callProperty():void
		{
			Assert.assertNull(lcm.flash_proxy::callProperty("asa"))
		}
	}
}