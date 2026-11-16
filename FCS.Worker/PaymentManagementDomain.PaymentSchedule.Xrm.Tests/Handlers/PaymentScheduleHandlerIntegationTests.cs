namespace PaymentManagementDomain.PaymentSchedule.Xrm.Tests.Handlers
{
    extern alias Entity;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using NServiceBus;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.PaymentSchedule;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.Framework.Logging.Interfaces;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;
    using MoreLinq;
    using PaymentSchedule.PaymentScheduleXrm;
    using PaymentSchedule.PaymentScheduleXrm.Repositories;
    using PaymentSchedule.PaymentScheduleXrm.Services;
    using SFA.FCS.Worker.Common.Crm;
    using Entity::SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using TestResource = Tests.TestResource;

    [TestClass]
    public class PaymentScheduleHandlerIntegationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentScheduleHandler_ShouldUpdateContractDeliverablePeriod_WhenPaymentScheduleHandlerCalled()
        {
            // Arrange
            PaymentScheduleEvent paymentScheduleEvent = GetEventFromFile();

            RemoveContract(paymentScheduleEvent.PaymentScheduleAllocation.ContractNumber);

            CreateContractWithPeriodsThatMatchesThePaymentSchedule(paymentScheduleEvent.PaymentScheduleAllocation);

            CrmAllocationRepository allocationRepository = new CrmAllocationRepository(GetCrmConnection());

            CrmDeliverablePeriodRepository crmDeliverablePeriodRepository = new CrmDeliverablePeriodRepository(GetCrmConnection());

            Mock<ISessionConnectionFactory> sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock.Setup(f => f.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(ConnectionInfo.CreateDefault);
            Mock<IProcessedMessageRepository> processedMessageRepMock = new Mock<IProcessedMessageRepository>();
            processedMessageRepMock.Setup(r => r.Add(It.IsAny<string>(), It.IsAny<ConnectionInfo>())).Returns(true);

            PaymentScheduleEventHandler handler = new PaymentScheduleEventHandler(
                Mock.Of<ILogger>(),
                allocationRepository, 
                crmDeliverablePeriodRepository,
                processedMessageRepMock.Object,
                sessionConnectionFactoryMock.Object,
                new PaymentScheduleService(
                    new CrmFspDeliverableRepository(GetCrmConnection()),
                    new CrmDeliverableRepository(GetCrmConnection()),
                    new CrmPeriodTypeRepository(GetCrmConnection()),
                    new CrmTransactionRequestRepository(GetCrmConnection()))
                );

            Mock<IMessageHandlerContext> mockContext = new Mock<IMessageHandlerContext>();
            // Act
            handler.Handle(paymentScheduleEvent, mockContext.Object).Wait();
            
            // Assert
            ScheduledPayment firstScheduledPayment = paymentScheduleEvent.PaymentScheduleAllocation.AllocationDeliverables.First().ScheduledPayments
                .First();

            IReadOnlyCollection<sfa_contractdeliverableperiod> periods =
                GetCrmDeliverablePeriods(paymentScheduleEvent.PaymentScheduleAllocation.AllocationNumber,
                    paymentScheduleEvent.PaymentScheduleAllocation.AllocationDeliverables.First().DeliverableCode.ToString(),
                    firstScheduledPayment.Period);

            Assert.IsNotNull(periods);
            sfa_contractdeliverableperiod period = periods.First();
            Assert.IsTrue(period.sfa_ProfilePaymentAmount == firstScheduledPayment.ProfilePaymentAmount);
        }

        private PaymentScheduleEvent GetEventFromFile()
        {
            return TestResource.FromJson<PaymentScheduleEvent>("PaymentManagementDomain.PaymentSchedule.Xrm.Tests",
                "Resources.PaymentScheduleEvent.json");
        }

        private void CreateContractWithPeriodsThatMatchesThePaymentSchedule(Allocation allocation)
        {
            Guid contractId = CreateContract(allocation.ContractNumber, allocation.VersionNumber, 0);

            sfa_contract contract = new sfa_contract
            {
                Id = contractId,
                sfa_LastApprovedVersion = true
            };

            GetCrmConnection().Update(contract);

            CreateAllocation(contractId, allocation);
        }

        private void RemoveContract(string contractNumber)
        {
            using (var context = new XrmServiceContext(GetCrmConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber)
                    .ForEach(ca => GetCrmConnection().Delete(sfa_contract.EntityLogicalName, ca.Id));
            }
        }

        private Guid CreateAllocation(Guid contractId, Allocation allocation)
        {
            sfa_contractallocation contractallocation = new sfa_contractallocation
            {
                sfa_contractallocationnumber = allocation.AllocationNumber,
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_startdate = DateTime.UtcNow,
                sfa_enddate = DateTime.UtcNow.AddYears(1)
            };

            const string deliverableRelationshipName = "sfa_sfa_contractallocation_sfa_contractdelive";

            var deliverableRelationship = new Relationship(deliverableRelationshipName);

            var relatedDeliverablesToCreate = new EntityCollection
            {
                EntityName = sfa_contractdeliverable.EntityLogicalName
            };

            IReadOnlyCollection<sfa_contractdeliverable> crmContractDeliverables = allocation.AllocationDeliverables.Select(CreateCrmDeliverable).ToList();

            relatedDeliverablesToCreate.Entities.AddRange(crmContractDeliverables);

            contractallocation.RelatedEntities.Add(deliverableRelationship, relatedDeliverablesToCreate);

            return GetCrmConnection().Create(contractallocation);
        }

        private sfa_contractdeliverable CreateCrmDeliverable(AllocationDeliverable allocationDeliverable)
        {
            sfa_contractdeliverable deliverable = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = allocationDeliverable.DeliverableCode.ToString(),
                sfa_DisplayOrder = allocationDeliverable.DeliverableCode,
                sfa_deliverablename = allocationDeliverable.DeliverableCode.ToString()
            };

            const string deliverablePeriodRelationshipName = "sfa_contractdeliverable_deliverableperiod";

            var deliverablePeriodRelationship = new Relationship(deliverablePeriodRelationshipName);

            var relatedDeliverablePeriodsToCreate = new EntityCollection
            {
                EntityName = sfa_contractdeliverableperiod.EntityLogicalName
            };

            IReadOnlyCollection<sfa_contractdeliverableperiod> contractDeliverablePeriods = allocationDeliverable.ScheduledPayments.Select(CreateCrmContractDeliveralePeriod).ToList();

            relatedDeliverablePeriodsToCreate.Entities.AddRange(contractDeliverablePeriods);

            deliverable.RelatedEntities.Add(deliverablePeriodRelationship, relatedDeliverablePeriodsToCreate);

            return deliverable;
        }

        private sfa_contractdeliverableperiod CreateCrmContractDeliveralePeriod(ScheduledPayment scheduledPayment)
        {
            sfa_contractdeliverableperiod contractdeliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_PeriodName = scheduledPayment.Period,
                sfa_Year = int.Parse(scheduledPayment.Period.Substring(0, 4)),
                sfa_Period = int.Parse(scheduledPayment.Period.Substring(4, 2)),
            };

            return contractdeliverableperiod;
        }

        private Guid CreateContract(string contractNumber, int version, int subVersion)
        {
            sfa_contract contract = new sfa_contract
            {
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_SubVersion = subVersion,
                sfa_ProviderName = GetProvider(),
                sfa_UKPRN = "1",
                sfa_FundingType = GetFundingType()
            };

            return GetCrmConnection().Create(contract);
        }

        private EntityReference GetFundingType()
        {
            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.sfa_fundingtypeSet.First().ToEntityReference();
            }
        }

        private EntityReference GetProvider()
        {
            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                return xrmContext.AccountSet.First(o => o.sfa_OrganisationID != null).ToEntityReference();
            }
        }

        private static IReadOnlyCollection<sfa_contractdeliverableperiod> GetCrmDeliverablePeriods(string contractAllocationNumber, string deliverableCode, string deliverablePeriod)
        {
            var periodName = DateTime.ParseExact(
                deliverablePeriod, "yyyyMM", null).ToString("MMM-yy");

            using (var xrmContext = new XrmServiceContext(GetCrmConnection()))
            {
                var data = from a in xrmContext.sfa_contractallocationSet
                    join c in xrmContext.sfa_contractSet on a.sfa_ContractId.Id equals c.sfa_contractId
                    join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals
                        d.sfa_ContractAllocationId.Id
                    join cdp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals
                        cdp.sfa_ContractDeliverableId.Id
                    where
                        c.sfa_LastApprovedVersion == true &&
                        a.sfa_contractallocationnumber == contractAllocationNumber &&
                        d.sfa_DeliverableCode == deliverableCode &&
                        cdp.sfa_PeriodName == periodName
                           select cdp;
                return data.ToList();
            }
        }

        private static IOrganizationService GetCrmConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }
    }
}
