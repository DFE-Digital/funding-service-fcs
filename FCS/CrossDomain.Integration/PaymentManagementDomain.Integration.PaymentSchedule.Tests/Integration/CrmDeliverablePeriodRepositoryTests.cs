namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using MoreLinq;
    using PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using CrmConnectionFactory = FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class CrmDeliverablePeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void CrmDeliverablePeriodRepository_ShouldInsertDeliverablePeriod()
        {
            // arrange
            const string deliverableName = "Test D";
            DeleteDeliverable(deliverableName);

            CrmDeliverablePeriodRepository deliverablePeriodRepository = new CrmDeliverablePeriodRepository(GetCrmConnection());

            Guid deliverableId = CreateDeliverable(deliverableName);
            sfa_contractdeliverableperiod valueToBeBasedOn = new sfa_contractdeliverableperiod
            {
                sfa_Period = 1,
                sfa_Year = 2017,
                sfa_PeriodName = "Jan-17",
                sfa_BalancingPaymentAmount = 11,
                sfa_ActualValue = 12,
                sfa_DisplayOrder = 13,
                sfa_CappedPaymentAmount = -15,
                sfa_ProfilePaymentAmount = 16,
                sfa_ReconciliationPaymentAmount = 17,
                OwnerId = GetAnOwner()
            };

            // act
            deliverablePeriodRepository.InsertDeliverablePeriod(basedOnContractDeliverablePeriod: valueToBeBasedOn, deliverableToRelateTo: new EntityReference(sfa_contractdeliverable.EntityLogicalName, deliverableId));

            // assert
            var createdCDPs = GetDeliverablePeriodsRelatedToDeliverable(deliverableId);

            Assert.AreEqual(1, createdCDPs.Count, "The number of cdps created is incorrect");
            sfa_contractdeliverableperiod returnedCDP = createdCDPs.First();
            Assert.AreEqual(valueToBeBasedOn.sfa_PeriodName, returnedCDP.sfa_PeriodName, "The Period Name is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_Period, returnedCDP.sfa_Period, "The Period is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_ProfilePaymentAmount, returnedCDP.sfa_ProfilePaymentAmount, "The sfa_ProfilePaymentAmount is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_BalancingPaymentAmount, returnedCDP.sfa_BalancingPaymentAmount, "The sfa_BalancingPaymentAmount is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_ActualValue, returnedCDP.sfa_ActualValue, "The sfa_ActualValue is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_DisplayOrder, returnedCDP.sfa_DisplayOrder, "The sfa_DisplayOrder is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_CappedPaymentAmount, returnedCDP.sfa_CappedPaymentAmount, "The sfa_CappedPaymentAmount is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_ProfilePaymentAmount, returnedCDP.sfa_ProfilePaymentAmount, "The sfa_ProfilePaymentAmount is incorrect");
            Assert.AreEqual(valueToBeBasedOn.sfa_ReconciliationPaymentAmount, returnedCDP.sfa_ReconciliationPaymentAmount, "The sfa_ProfilePaymentAmount is incorrect");

        }

        private void DeleteDeliverable(string deliverableName)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                crmContext.sfa_contractdeliverableSet.Where(d => d.sfa_deliverablename == deliverableName)
                    .ForEach(d => crmContext.DeleteObject(d));
            }
        }

        private static EntityReference GetAnOwner()
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return crmContext.TeamSet
                    .Single(t => t.Name == "Contract Control Management Team")
                    .ToEntityReference();
            }
        }

        private IReadOnlyCollection<sfa_contractdeliverableperiod> GetDeliverablePeriodsRelatedToDeliverable(Guid deliverableId)
        {
            using (var crmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return crmContext.sfa_contractdeliverableperiodSet.Where(dp => dp.sfa_ContractDeliverableId.Id == deliverableId)
                    .ToList();
            }
        }

        private static Guid CreateDeliverable(string deliverableName)
        {
            var deliverable = new sfa_contractdeliverable
            {
                sfa_deliverablename = deliverableName
            };

            return GetCrmConnection().Create(deliverable);
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
