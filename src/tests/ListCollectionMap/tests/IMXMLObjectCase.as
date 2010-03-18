package tests.ListCollectionMap.tests
{
	import tests.ListCollectionMap.LCMTestEnvironment;

	public class IMXMLObjectCase extends LCMTestEnvironment
	{
		[Test(description="IMXMLObject initialize() smoke test")]
		public function smoke():void {
			
			lcm.initialized(null, "")
		}
		
	}
}