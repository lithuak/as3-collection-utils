package tests.ListCollectionMap
{
	import tests.ListCollectionMap.tests.GeneralCase;
	import tests.ListCollectionMap.tests.IEventDispatcherCase;
	import tests.ListCollectionMap.tests.IListCase;
	import tests.ListCollectionMap.tests.IMXMLObjectCase;
	import tests.ListCollectionMap.tests.ProxyCase;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class LCMSuite
	{
		
		public var test1:tests.ListCollectionMap.tests.GeneralCase;
		public var test2:IListCase
		public var test3:IMXMLObjectCase
		public var test4:IEventDispatcherCase
		public var test5:ProxyCase
		
	}
}