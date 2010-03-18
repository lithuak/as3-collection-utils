package tests.ListCollectionMap.tests
{
	import flexunit.framework.Assert;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	
	import tests.ListCollectionMap.LCMTestEnvironment;

	public class IListCase extends LCMTestEnvironment
	{
		[Test(description="IList.length")]
		public function length():void {
			
			Assert.assertEquals(lcm.length, 3)
		}
		
		[Test(description="IList.addItem",expects="TypeError")]
		public function addItem():void {
			
			lcm.addItem(5)
		}
		
		[Test(description="IList.addItemAt",expects="TypeError")]
		public function addItemAt():void {
			
			lcm.addItemAt(5, 1)
		}
		
		[Test(description="IList.getItemAt")]
		public function getItemAt():void {
			
			var i:int = lcm.getItemAt(1) as int
			Assert.assertEquals(i, 3)
				
			i = lcm.getItemAt(2) as int
			Assert.assertEquals(i, 4)

			i = lcm.getItemAt(0) as int
			Assert.assertEquals(i, 2)
			
		}

		[Test(description="IList.getItemAt index &lt; 0",expects="RangeError")]
		public function getItemAtEx1():void {
			
			var i:int = lcm.getItemAt(-1) as int
		}

		[Test(description="IList.getItemAt index &gt; length",expects="RangeError")]
		public function getItemAtEx2():void {
			
			var i:int = lcm.getItemAt(3) as int
		}

		[Test(description="IList.getItemIndex")]
		public function getItemIndex():void {
			
			var result:Array = []
				
			for(var i:int = 1; i < 6; i++)
				result.push(lcm.getItemIndex(i))
			
			assertThat(result, array(-1, 0, 1, 2, -1))
		}
		
		[Test(description="IList.itemUpdated",expects="TypeError")]
		public function itemUpdated():void {
			
			lcm.itemUpdated(1)
		}
		
		[Test(description="IList.removeAll",expects="TypeError")]
		public function removeAll():void {
			
			lcm.removeAll()
		}
		
		[Test(description="IList.removeItemAt",expects="TypeError")]
		public function removeItemAt():void {
			
			lcm.removeItemAt(1)
		}
		
		[Test(description="IList.setItemAt",expects="TypeError")]
		public function setItemAt():void {
			
			lcm.setItemAt(5, 0)
		}
		
		[Test(description="IList.toArray")]
		public function toArray():void {
			
			assertThat(lcm.toArray(), array(2, 3, 4))
		}
		
	}
}