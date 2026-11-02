namespace FCT.Console.Config.Tests.Crm
{
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers.CRM;

    [TestClass]
    public class CrmHelperTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmHelper_GetConnection_ShouldConnectToCrmOnline()
        {
            CrmHelper.GetConnection();
        }
    }
}
