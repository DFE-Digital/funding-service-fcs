using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using Ciber.Xrm.Tests.MetaData;

namespace FCTCrmConfig.Tests
{
    [TestClass]
    public class XrmWorkflow_Tests
    {
        private XrmConfiguration CrmConfiguration;

        [ClassInitialize()]
        public void InitializeConfig()
        {
            this.CrmConfiguration = new XrmWebConfiguration(Properties.Settings.Default.CrmConnectionString);
        }

        [TestMethod]
        public void RetrieveContract()
        {
            Guid contractGuid = this.CrmConfiguration.Data().GetRecord(XrmEntityName.Contract, "CON0000001", "sfa_contract");

            Assert.IsInstanceOfType(contractGuid, typeof(Guid));
            Assert.IsTrue(contractGuid != Guid.Empty);
        }

        public void RetrieveNextAction()
        {
            Guid transitionGuid = this.CrmConfiguration.Data().GetRecord(XrmEntityName.Transition, "Send For Approval", "sfa_name");

            Assert.IsInstanceOfType(transitionGuid, typeof(Guid));
            Assert.IsTrue(transitionGuid != Guid.Empty);
        }

        public void UpdateContract()
        {
            Guid contractGuid = this.CrmConfiguration.Data().GetRecord(XrmEntityName.Contract, "CON0000001", "sfa_contract");
            Guid transitionGuid = this.CrmConfiguration.Data().GetRecord(XrmEntityName.Transition, "Send For Approval", "sfa_name");

            bool updatedContract = this.CrmConfiguration.Data().UpdateRecord(XrmEntityName.Transition, contractGuid, "sfa_transition", transitionGuid);
            Assert.IsTrue(updatedContract);
        }

        public void UpdateContractCheckTransition()
        {
            Entity = this.CrmConfiguration.Data().GetRecord(XrmEntityName.Contract, "CON0000001", "sfa_contract");
            Guid transitionGuid = this.CrmConfiguration.Data().GetRecord(XrmEntityName.Transition, "Send For Approval", "sfa_name");

            bool updatedContract = this.CrmConfiguration.Data().UpdateRecord(XrmEntityName.Transition, contractGuid, "sfa_transition", transitionGuid);


            
        }
    }
}
