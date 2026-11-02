using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace FCTCrmConfig.ConfigPackage.Tests
{
    using System.Reactive.Subjects;
    using Microsoft.Xrm.Tooling.Connector;

    [TestClass]
    public class ConfigPackageTests
    {
        //[TestMethod]
        public void VerifyXmlDeserializationAndContractLoad()
        {
            var crmClient = new CrmServiceClient(new System.Net.NetworkCredential("dev-crmintegration", "", "FCTDEV"), "fct-crm-dev-01.cloudapp.net", "80", "FCTDevMigration");

            var eventStream = new Subject<DeploymentEvent>();

            eventStream.Subscribe(a => Console.WriteLine(a.Message));

            var loadContractNumbers = new LoadXrmContractNumbers(@"..\..\..\FCTCrmConfig.ConfigPackage\PkgFolder\Data\ConfigData\ContractNumbers.xml",
                crmClient,
                eventStream);

            loadContractNumbers.LoadContractNumbers();

        }
    }
}
