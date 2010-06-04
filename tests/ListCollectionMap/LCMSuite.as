package ListCollectionMap
{
	import ListCollectionMap.tests.GeneralCase;
	import ListCollectionMap.tests.IEventDispatcherCase;
	import ListCollectionMap.tests.IListCase;
	import ListCollectionMap.tests.IMXMLObjectCase;
	import ListCollectionMap.tests.ListUpdatesCase;
	import ListCollectionMap.tests.PropertyUpdateTestCase;
	import ListCollectionMap.tests.ProxyCase;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class LCMSuite
	{
		
		public var test1:GeneralCase;
		public var test2:IListCase
		public var test3:IMXMLObjectCase
		public var test4:IEventDispatcherCase
		public var test5:ProxyCase
		public var test6:ListUpdatesCase
		public var test7:PropertyUpdateTestCase
		
	}
}