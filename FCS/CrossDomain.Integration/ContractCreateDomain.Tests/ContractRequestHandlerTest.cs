namespace ContractCreateDomain.Tests
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using NServiceBus.Testing;

    [TestClass]
    public class ContractRequestHandlerTest : TestBase
    {
       
        [TestInitialize]
        public void Setup()
        {
            Test.Initialize();
        }
    }
}
