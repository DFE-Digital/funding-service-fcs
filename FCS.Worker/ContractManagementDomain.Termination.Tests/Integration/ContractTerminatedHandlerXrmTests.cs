namespace ContractManagementDomain.Termination.Tests.Integration
{
    using System;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using ContractManagementDomain.Termination.Xrm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
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
    public class ContractTerminatedHandlerXrmTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminatedHandlerXrm_ShouldSetContractToTerminated()
        {
            // arrange
            const string contactNumber = "Test - C1";
            const int version = 1;
            const int subVersion = 0;

            DeleteContract(contactNumber);
            Guid contractId = CreateContract(contactNumber, version, subVersion, sfa_contractstatus.Approved, "Under Termination", new DateTime(2018, 10, 9));

            ContractTerminatedEvent terminatedEvent = new ContractTerminatedEvent
            {
                ContractNumber = contactNumber,
                VersionNumber = version,
                SubVersionNumber = subVersion
            };

            // act
            _ = GetHandler().Handle(terminatedEvent, null);

            // assert
            StatusInfo statusValues = GetContractStatus(contractId);
            Assert.AreEqual(sfa_contractstatus.Closed, statusValues.ContractStatus, "The new status is not correct");
            Assert.AreEqual("Terminated", statusValues.SubStatus, "The new substatus is not correct");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractTerminatedHandlerXrm_ShouldSetContractEndDate()
        {
            // arrange
            const string contactNumber = "Test - C1";
            const int version = 1;
            const int subVersion = 0;
            DateTime expectedEndDate = DateTime.UtcNow.Date;

            DeleteContract(contactNumber);
            Guid contractId = CreateContract(contactNumber, version, subVersion, sfa_contractstatus.Approved, "Under Termination", terminationDate: expectedEndDate);

            ContractTerminatedEvent terminatedEvent = new ContractTerminatedEvent
            {
                ContractNumber = contactNumber,
                VersionNumber = version,
                SubVersionNumber = subVersion
            };

            // act
            _ = GetHandler().Handle(terminatedEvent, null);

            // assert
            DateTime? contractEndDate = GetContractEndDate(contractId);
            Assert.AreEqual(expectedEndDate, contractEndDate, "The new contract end date is not correct");
        }

        private static Guid CreateContract(string contractNumber, int version, int subVersion, sfa_contractstatus status, string subStatus, DateTime terminationDate)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1",
                sfa_terminationdate = terminationDate
            };

            Guid contractId = GetCrmConnection().Create(contract);

            contract.Id = contractId;
            contract.sfa_ContractStatus = new OptionSetValue((int) status);
            contract.sfa_SubStatus = GetSubStatusEntityReference(subStatus);
            contract.EntityState = EntityState.Changed;
            GetCrmConnection().Update(contract);

            return contractId;
        }

        private static EntityReference GetSubStatusEntityReference(string subStatus)
        {
            IOrganizationService orgService = GetCrmConnection();

            using (var context = new XrmServiceContext(orgService))
            {
                return context.sfa_statusSet.First(s => s.sfa_name == subStatus).ToEntityReference();
            }
        }

        private static EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private static ContractTerminatedHandler GetHandler()
        {
            IWindsorContainer container = new WindsorContainer()
                .Install(new WindsorInstaller(new LoggerFactory()))
                .Register(Component.For<ContractTerminatedHandler>()
                    .ImplementedBy<ContractTerminatedHandler>());
            _ = container.Register(Component.For<ILogger>().Instance(Mock.Of<ILogger>()).IsDefault());

            _ = container.BeginScope();

            return container.Resolve<ContractTerminatedHandler>();
        }

        private static void DeleteContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .Select(c => c.sfa_contractId.Value)
                    .ForEach(id => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, id));
            }
        }

        private static StatusInfo GetContractStatus(Guid contractId)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                var resp = (from contract in context.sfa_contractSet
                    join sfaStatus in context.sfa_statusSet on contract.sfa_SubStatus.Id equals sfaStatus.Id
                    where contract.sfa_contractId == contractId
                    select new
                    {
                        CrmContractstatus = (sfa_contractstatus)contract.sfa_ContractStatus.Value,
                        SubStatus = sfaStatus.sfa_name
                    }).Single();

                return new StatusInfo(resp.CrmContractstatus, resp.SubStatus);
            }
        }

        private static DateTime? GetContractEndDate(Guid contractId)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                return (from contract in context.sfa_contractSet
                    where contract.sfa_contractId == contractId
                    select contract.sfa_EndDate).Single();
            }
        }

        private static IOrganizationService GetCrmConnection() => CrmConnectionFactory.GetRetryOnErrorOrganizationService();
    }

    internal class StatusInfo
    {
        public StatusInfo(sfa_contractstatus contractstatus, string subStatus)
        {
            ContractStatus = contractstatus;
            SubStatus = subStatus;
        }

        public sfa_contractstatus ContractStatus { get; }

        public string SubStatus { get; }
    }
}