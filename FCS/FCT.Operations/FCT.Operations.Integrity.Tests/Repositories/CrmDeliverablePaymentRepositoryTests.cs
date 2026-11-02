namespace FCT.Operations.Integrity.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Metadata;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.Operations.Integrity.Repositories;
    using SFA.FCT.Operations.Integrity.DTOs;
    using SFA.FCS.Worker.Common.Crm;

    [TestClass]
    public class CrmDeliverablePaymentRepositoryTests
    {
        private const string AllocationNumberTest = "Alloc Test";
        private const string ContractNumberTest = "Contract Test";
        private const int ContractVersionTest = 1;
        private const int DeliverableCodeTest = 1;
        private const string PeriodNameTest = "Apr-16";

        [TestInitialize]
        public void CleanUp()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                var deliverablePeriodDetails =
                    (from c in crmContext.sfa_contractSet
                        join a in crmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                        join d in crmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                            d.sfa_ContractAllocationId.Id
                        join dp in crmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                            dp.sfa_ContractDeliverableId.Id
                        join acc in crmContext.AccountSet on c.sfa_ProviderName.Id equals acc.Id
                        where a.sfa_contractallocationnumber == AllocationNumberTest
                        where c.sfa_Version.Value == ContractVersionTest
                     select new CrmDeliverablePeriodDetail (dp.sfa_contractdeliverableperiodId.Value, d.sfa_contractdeliverableId.Value, a.sfa_contractallocationId.Value, c.Id, acc.AccountId.Value)).ToList();

                var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
                deliverablePeriodDetails.ForEach(dpd =>
                {
                    crmConnection.Delete(sfa_contractdeliverableperiod.EntityLogicalName, dpd.DeliverablePeriodGuid);
                    crmConnection.Delete(sfa_contractdeliverable.EntityLogicalName, dpd.DeliverableGuid);
                    crmConnection.Delete(sfa_contractallocation.EntityLogicalName, dpd.AllocationGuid);
                    crmConnection.Delete(sfa_contract.EntityLogicalName, dpd.ContractGuid);
                    crmConnection.Delete(Account.EntityLogicalName, dpd.AccountGuid);
                });
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverablePaymentRepository_ShouldGetByAllocationVersionDeliverableCodeAndVersion()
        {
            // arrange
            var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            Account account = new Account
            {
                sfa_UKPRN = "Test"
            };

            Guid accountGuid = crmConnection.Create(account);
            int? approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), "Approved");
            sfa_contract contract = new sfa_contract
            {
                sfa_number = ContractNumberTest,
                sfa_Version = ContractVersionTest,
                sfa_ProviderName = new EntityReference(Account.EntityLogicalName, accountGuid),
                sfa_ContractStatus = new OptionSetValue(approvedStatusId.Value)
            };

            Guid contractGuid = crmConnection.Create(contract);
            contract.Id = contractGuid;

            crmConnection.Update(contract);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractGuid),
                sfa_contractallocationnumber = AllocationNumberTest
            };

            Guid allocationGuid = crmConnection.Create(allocation);

            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationGuid),
                sfa_DeliverableCode = DeliverableCodeTest.ToString()
            };

            Guid deliverableGuid = crmConnection.Create(deliverable);

            sfa_contractdeliverableperiod deliverablePeriod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableGuid),
                sfa_PeriodName = PeriodNameTest
            };

            crmConnection.Create(deliverablePeriod);

            // act
            IReadOnlyCollection<CrmDeliverablePaymentData> deliverablePeriods = new CrmDeliverablePaymentRepository(new LocalConfig()).GetByAllocationVersionDeliverableCodeAndVersion(AllocationNumberTest,
                ContractVersionTest, DeliverableCodeTest, "201604");

            // assert
            Assert.AreEqual(1, deliverablePeriods.Count, "The number of deliverablePeriods returned is not correct");
        }


        [TestMethod, TestCategory("TechnicalExplorationUsingCrmDatabaseDirectly")]
        public void CrmDeliverablePaymentRepository_ShouldGetByAllocationNumberAndVersion()
        {
            // arrange
            var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            Account account = new Account
            {
                sfa_UKPRN = "Test"
            };

            Guid accountGuid = crmConnection.Create(account);
            int? approvedStatusId = GetOptionsetValue(CrmOptionSetType.Status.GetOptionSetName(), "Approved");
            sfa_contract contract = new sfa_contract
            {
                sfa_number = ContractNumberTest,
                sfa_Version = ContractVersionTest,
                sfa_ProviderName = new EntityReference(Account.EntityLogicalName, accountGuid),
                sfa_ContractStatus = new OptionSetValue(approvedStatusId.Value)
            };

            Guid contractGuid = crmConnection.Create(contract);
            contract.Id = contractGuid;

            crmConnection.Update(contract);

            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractGuid),
                sfa_contractallocationnumber = AllocationNumberTest
            };

            Guid allocationGuid = crmConnection.Create(allocation);

            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationGuid),
                sfa_DeliverableCode = DeliverableCodeTest.ToString()
            };

            Guid deliverableGuid = crmConnection.Create(deliverable);

            sfa_contractdeliverableperiod deliverablePeriod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableGuid),
                sfa_PeriodName = PeriodNameTest
            };

            crmConnection.Create(deliverablePeriod);

            // act
            IReadOnlyCollection<CrmDeliverablePaymentData> deliverablePeriods = new CrmDeliverablePaymentRepository(new LocalConfig()).GetByAllocationNumberAndVersion(AllocationNumberTest,
                ContractVersionTest);

            // assert
            Assert.AreEqual(1, deliverablePeriods.Count, "The number of deliverablePeriods returned is not correct");
        }

        [TestMethod, TestCategory("TechnicalExplorationUsingCrmDatabaseDirectly")]
        public void CrmDeliverablePaymentRepository_ShouldGetByFsps()
        {
            // arrange
            var crmConnection = CrmConnectionFactory.GetRetryOnErrorOrganizationService();
            List<string> fsps = new List<string>
            {
                "16-18FU2021", "16-18NLAP2018", "16-18NLAP-AS2019", "16-18TRN1819", "16-18TRN1920"
            };

            // act
            IReadOnlyCollection<CrmDeliverablePaymentData> deliverablePeriods = new CrmDeliverablePaymentRepository(new LocalConfig()).GetApprovedRowsByFsps(fsps);

            // assert
            Assert.IsTrue(deliverablePeriods.Any(), "There isn't any data");
        }

        private static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        public static int? GetOptionsetValue(string optionsetName, string label)
        {
            int? optionsetValue = null;
            RetrieveOptionSetRequest retrieveOptionSetRequest =
                new RetrieveOptionSetRequest
                {
                    Name = optionsetName
                };

            // Execute the request.
            RetrieveOptionSetResponse retrieveOptionSetResponse =
                (RetrieveOptionSetResponse)GetConnection().Execute(retrieveOptionSetRequest);

            // Access the retrieved OptionSetMetadata.
            OptionSetMetadata retrievedOptionSetMetadata =
                (OptionSetMetadata)retrieveOptionSetResponse.OptionSetMetadata;

            // Get the current options list for the retrieved attribute.
            OptionMetadata[] optionList = retrievedOptionSetMetadata.Options.ToArray();
            foreach (OptionMetadata optionMetadata in optionList)
            {
                if (optionMetadata.Label.LocalizedLabels.First().Label == label)
                {
                    optionsetValue = optionMetadata.Value;
                    break;
                }
            }

            return optionsetValue;
        }

        private class CrmDeliverablePeriodDetail
        {
            public CrmDeliverablePeriodDetail(Guid deliverablePeriodGuid, Guid deliverableGuid, Guid allocationGuid, Guid contractGuid, Guid accountGuid)
            {
                DeliverablePeriodGuid = deliverablePeriodGuid;
                DeliverableGuid = deliverableGuid;
                AllocationGuid = allocationGuid;
                ContractGuid = contractGuid;
                AccountGuid = accountGuid;
            }

            public Guid DeliverablePeriodGuid { get; }

            public Guid DeliverableGuid { get; }

            public Guid AllocationGuid { get; }

            public Guid ContractGuid { get; }

            public Guid AccountGuid { get; }
        }
    }
}
