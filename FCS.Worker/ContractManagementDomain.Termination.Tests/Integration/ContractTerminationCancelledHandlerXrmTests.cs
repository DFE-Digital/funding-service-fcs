namespace ContractManagementDomain.Termination.Tests.Integration
{
    using System;
    using System.Configuration;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagementDomain.Termination.Xrm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using MoreLinq;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractTerminationCancelledHandlerXrmTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminationCancelledHandlerXrm_ShouldSetContractToApproved()
        {
            // arrange
            const string contactNumber = "Test - C1";
            const int version = 1;
            const int subVersion = 0;

            DeleteContract(contactNumber);
            Guid contractId = CreateContract(contactNumber, version, subVersion, sfa_contractstatus.Approved, "Termination Cancellation in Progress");


            ContractTerminationCancelledEvent cancelledEvent = new ContractTerminationCancelledEvent
            {
                ContractNumber = contactNumber,
                VersionNumber = version,
                SubVersionNumber = subVersion
            };

            // act
            _ = GetHandler().Handle(cancelledEvent, null);

            // assert
            string newStatus = GetContractSubStatus(contractId);
            Assert.AreEqual("Approved", newStatus, "The new status is not correct");
        }

        private Guid CreateContract(string contractNumber, int version, int subVersion, sfa_contractstatus status, string subStatus)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1"
            };

            Guid contractId = GetCrmConnection().Create(contract);


            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int)status);
            contract.sfa_SubStatus = GetSubStatusEntityReference(subStatus);
            contract.EntityState = EntityState.Changed;
            GetCrmConnection().Update(contract);

            return contractId;
        }

        private EntityReference GetSubStatusEntityReference(string subStatus)
        {
            IOrganizationService orgService = GetCrmConnection();

            using (var context = new XrmServiceContext(orgService))
            {
                return context.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private ContractTerminationCancelledHandler GetHandler()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractTerminationCancelledHandler>().ImplementedBy<ContractTerminationCancelledHandler>());
            _ = container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());

            _ = container.BeginScope();

            return container.Resolve<ContractTerminationCancelledHandler>();
        }

        private void DeleteContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.sfa_contractId.Value)
                    .ForEach(id => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private string GetContractSubStatus(Guid contractId)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                return (from c in context.sfa_contractSet
                    join status in context.sfa_statusSet on c.sfa_SubStatus.Id equals status.sfa_statusId
                    where c.sfa_contractId == contractId
                    select status.sfa_name).Single();
            }
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
