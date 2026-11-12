namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.DeliverableAggregation
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.DeliverableAggregation;
    using SFA.FCS.Worker.Common.Crm;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos;

    [TestClass]
    public class CrmDeliverableRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverableRepository_ShouldUpdateDeliverables()
        {
            // arrange
            const string allocationNumber = "Test AN - D";
            const int version = 1;
            const int subVersion = 0;
            const string contractNumber = "Test CN - D";
            const int valMultiplyingFactor = 2;
            const int volMultiplyingFactor = 3;

            RemoveContract(contractNumber);
            Guid contractId = CreateContract(contractNumber, version, subVersion);
            Guid allocationId = CreateAllocation(contractId, allocationNumber);
            var deliverables = Enumerable.Range(1, 5).ToList();
            deliverables.ForEach(d => CreateDeliverableInCrm(d, allocationId));

            CrmDeliverableRepository repository = new CrmDeliverableRepository(GetCrmConnection());
            var deliverableActuals = deliverables.Select(d => new DeliverableActual(d, d * valMultiplyingFactor, d * volMultiplyingFactor)).ToList();

            // act
            repository.UpdateDeliverablesInCrmForAllocation(allocationNumber, version, subVersion, deliverableActuals);

            // assert
            var updatedDeliverables = GetDeliverablesForAllocation(allocationId);

            deliverables.ForEach(d =>
            {
                var matchingDeliverable = updatedDeliverables.Single(up => up.sfa_DeliverableCode == d.ToString());
                Assert.AreEqual(d * valMultiplyingFactor, matchingDeliverable.sfa_ActualValue, $"The actual value for deliverable :{d} is not correct");
                Assert.AreEqual(d * volMultiplyingFactor, matchingDeliverable.sfa_ActualVolume, $"The actual volume for deliverable :{d} is not correct");
            });

        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverableRepository_ShouldUpdateDeliverablesInCrmWhenNotAllDeliverablesArePresentInPaaS()
        {
            // arrange
            const string allocationNumber = "Test AN - D";
            const int version = 1;
            const int subVersion = 0;
            const string contractNumber = "Test CN - D";
            const int valMultiplyingFactor = 2;
            const int volMultiplyingFactor = 3;

            RemoveContract(contractNumber);
            Guid contractId = CreateContract(contractNumber, version, subVersion);
            Guid allocationId = CreateAllocation(contractId, allocationNumber);
            List<int> deliverableCodesInCrm = Enumerable.Range(1, 5).ToList();
            List<int> deliverableCodesInPaas = Enumerable.Range(1, 3).ToList();
            deliverableCodesInCrm.ForEach(d => CreateDeliverableInCrm(d, allocationId));

            CrmDeliverableRepository repository = new CrmDeliverableRepository(GetCrmConnection());
            List<DeliverableActual> deliverableActuals = deliverableCodesInPaas.Select(d => new DeliverableActual(d, d * valMultiplyingFactor, d * volMultiplyingFactor)).ToList();

            // act
            repository.UpdateDeliverablesInCrmForAllocation(allocationNumber, version, subVersion, deliverableActuals);

            // assert
            IReadOnlyCollection<sfa_contractdeliverable> updatedDeliverables = GetDeliverablesForAllocation(allocationId);

            deliverableCodesInPaas.ForEach(d =>
            {
                sfa_contractdeliverable matchingDeliverable = updatedDeliverables.Single(up => up.sfa_DeliverableCode == d.ToString());
                Assert.AreEqual(d * valMultiplyingFactor, matchingDeliverable.sfa_ActualValue, $"The actual value for deliverable :{d} is not correct");
                Assert.AreEqual(d * volMultiplyingFactor, matchingDeliverable.sfa_ActualVolume, $"The actual volume for deliverable :{d} is not correct");
            });
        }

        private IReadOnlyCollection<sfa_contractdeliverable> GetDeliverablesForAllocation(Guid allocationId)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                return context.sfa_contractdeliverableSet.Where(d => d.sfa_ContractAllocationId.Id == allocationId).ToList();
            }
        }

        private void CreateDeliverableInCrm(int deliverableCode, Guid allocationId)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_DeliverableCode = deliverableCode.ToString()
            };

            GetCrmConnection().Create(deliverable);
        }

        private void RemoveContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .ForEach(ca => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, ca.Id));
            }
        }

        private Guid CreateAllocation(Guid contractId, string allocationNumber)
        {
            sfa_contractallocation contractallocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId)
            };

            return GetCrmConnection().Create(contractallocation);
        }

        private Guid CreateContract(string contractNumber, int version, int subVersion)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1"
            };

            return GetCrmConnection().Create(contract);
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }
    }
}
