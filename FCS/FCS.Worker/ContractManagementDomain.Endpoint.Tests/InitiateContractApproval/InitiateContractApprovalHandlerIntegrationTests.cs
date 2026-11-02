namespace ContractManagementDomain.Endpoint.Tests.InitiateContractApproval
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using Endpoint.InitiateContractApproval;
    using Endpoint.InitiateContractApproval.Repositories;
    using Endpoint.InitiateContractApproval.Services;
    using Endpoint.Repositories;
    using Endpoint.Services;
    using Infrastructure;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Moq;
    using MoreLinq;
    using NServiceBus;
    using NServiceBus.Testing;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.OverrideDate.DataStore.Services;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class InitiateContractApprovalHandlerIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldUpdateStartDateInCrmWhenThereIsOneAllocation()
        {
            // arrange 
            const string contractNumberToTest = "APPLEVY-1000";
            const string levyFsp = "LEVY1799";
            const int versionToTest = 2;

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);
            const string updatedPeriodName = "Dec-18";
            const int updatedPeriodNumber = 12;

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LEVY");
            var period = GetPeriod("LEVY1799");

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period,  false, versionToTest, initialContractStartDateTime);
            var allocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);
            var deliverableId = CreateDeliverable(allocationId);
            CreateDeliverablePeriod(deliverableId, initialContractStartDateTime.Month, initialPeriodName, updatedContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            Assert.AreEqual(updatedContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");
            Assert.AreEqual(updatedContractStartDateTime.Date, crmDates.First().AllocationDate, "Incorrect Allocation start date");
            crmDates.ForEach(
                x => {
                    Assert.AreEqual(updatedPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });

        }

        // DONE ?LEVY CONTRACT WITH 'PREVIOUS' LAST APPROVED VERSION WITHOUT NEW ALLOCATION on draft   -- no changes to any dates
        // DONE  LEVY CONTRACT WITH 'PREVIOUS' LAST APPROVED VERSION WITH NEW ALLOCATION on draft      -- only NONLEVY2019 allocation date and dps periods are updated. No change to LEVY allocation 
        // DONE ?LEVY CONTRACT WITHOUT 'PREVIOUS' LAST APPROVED VERSION WITHOUT NEW ALLOCATION on draft-- contract, levy allocations and dps dates and periods are updated
        // DONE  LEVY CONTRACT WITHOUT 'PREVIOUS' LAST APPROVED VERSION WITH NEW ALLOCATION on draft   -- contract, all allocations and dps dates and periods are updated
        // DONE  NON LEVY CONTRACT WITH 'PREVIOUS' LAST APPROVED VERSION on draft                      -- no changes to any dates
        // DONE  NON LEVY CONTRACT WITHOUT 'PREVIOUS' LAST APPROVED VERSION on draft                   -- no changes to any dates


        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldNotUpdateAnyDatesWhenLevyContractWasPreviouslyApprovedAndThereIsNoNewAllocationInTheDraft()
        {
            // LEVY CONTRACT WITH 'PREVIOUS' LAST APPROVED VERSION WITHOUT NEW ALLOCATION ON DRAFT   -- no changes to any dates
            // arrange 
            const string contractNumberToTest = "CN - Test";
            const int versionToTest = 2;
            const string levyFsp = "LEVY1799";

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";
            const int initialPeriodNumber = 5;

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LEVY");
            var period = GetPeriod("LEVY1799");

            var previousContractId = CreateTestContract(contractNumberToTest, fundingType, period, true, 1, initialContractStartDateTime);
            CreateContractAllocation(previousContractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period, false, versionToTest, initialContractStartDateTime);
            var allocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);
            var deliverableId = CreateDeliverable(allocationId);
            CreateDeliverablePeriod(contractDeliverableId: deliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");
            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().AllocationDate, "Incorrect Allocation start date");
            crmDates.ForEach(
                x => {
                    Assert.AreEqual(initialPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldOnlyUpdateNewAllocationDateAndDeliveryPeriodsWhenLevyContractWasPreviouslyApprovedAndThereIsANewAllocationInTheDraft()
        {
            // LEVY CONTRACT WITH 'PREVIOUS' LAST APPROVED VERSION WITH NEW ALLOCATION ON DRAFT      -- only NONLEVY2019 allocation date and dps periods are updated. No change to LEVY allocation 
            // arrange 
            const string contractNumberToTest = "APPLEVY-1000";
            const int versionToTest = 2;
            const string nonLevyFsp = "NONLEVY2019";
            const string levyFsp = "LEVY1799";

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";
            const int initialPeriodNumber = 5;

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);
            const string updatedPeriodName = "Dec-18";
            const int updatedPeriodNumber = 12;

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LEVY");
            var period = GetPeriod("LEVY1799");

            var previousContractId = CreateTestContract(contractNumberToTest, fundingType, period, true, 1, initialContractStartDateTime);
            CreateContractAllocation(previousContractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period, false, versionToTest, initialContractStartDateTime);
            // levy allocation
            var levyAllocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);
            var levyDeliverableId = CreateDeliverable(levyAllocationId);
            CreateDeliverablePeriod(contractDeliverableId: levyDeliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);
            // non levy allocation
            var nonLevyAllocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "NONLEVY2019ALLOC", nonLevyFsp);
            var nonLevyDeliverableId = CreateDeliverable(nonLevyAllocationId);
            CreateDeliverablePeriod(contractDeliverableId: nonLevyDeliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            // check contract date stays the same 
            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");

            // check non levy allocation - allocation date updated. dp periods updated 
            var nonLevyDates = crmDates.Where(d => d.FundingStreamPeriod == nonLevyFsp);
            var nonAllocationStartDates = nonLevyDates.Select(ad => ad.AllocationDate).Distinct();
            Assert.AreEqual(1, nonAllocationStartDates.Count(), "More than one allocation start date was returned");
            Assert.AreEqual(updatedContractStartDateTime.Date, nonAllocationStartDates.First(), "Incorrect allocation start date");

            nonLevyDates.ForEach(
                x => {
                    Assert.AreEqual(updatedPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });

            // check levy allocation - allocation date stays the same. dp periods stay the same 
            var levyDates = crmDates.Where(d => d.FundingStreamPeriod == levyFsp);
            var levyAllocationStartDates = levyDates.Select(ad => ad.AllocationDate).Distinct();
            Assert.AreEqual(initialContractStartDateTime.Date, levyAllocationStartDates.First(), "Incorrect allocation start date");
            
            levyDates.ForEach(
                x => {
                    Assert.AreEqual(initialPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldUpdateLevyContractDateAllocationDateAndDeliveryPeriodsWhenItIsFirstApprovalAndThereIsOnlyOneAllocationInTheDraft()
        {
            // LEVY CONTRACT WITHOUT 'PREVIOUS' LAST APPROVED VERSION WITHOUT NEW ALLOCATION ON DRAFT-- contract, levy allocation and dps dates and periods are updated
            // arrange 
            const string contractNumberToTest = "APPLEVY-1000";
            const int versionToTest = 2;
            const string levyFsp = "LEVY1799";

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);
            const string updatedPeriodName = "Dec-18";
            const int updatedPeriodNumber = 12;

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LEVY");
            var period = GetPeriod("LEVY1799");

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period, false, versionToTest, initialContractStartDateTime);
            // levy allocation
            var levyAllocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);
            var levyDeliverableId = CreateDeliverable(levyAllocationId);
            CreateDeliverablePeriod(contractDeliverableId: levyDeliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            // check contract date stays the same 
            Assert.AreEqual(updatedContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");

            var levyDates = crmDates.Where(d => d.FundingStreamPeriod == levyFsp);
            var levyAllocationStartDates = levyDates.Select(ad => ad.AllocationDate).Distinct();
            Assert.AreEqual(updatedContractStartDateTime.Date, levyAllocationStartDates.First(), "Incorrect allocation start date");

            levyDates.ForEach(
                x => {
                    Assert.AreEqual(updatedPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldUpdateLevyContractDateAllAllocationDatesAndDeliveryPeriodsWhenItIsFirstApprovalAndThereIsANewAllocationInTheDraft()
        {
            // LEVY CONTRACT WITHOUT 'PREVIOUS' LAST APPROVED VERSION WITH NEW ALLOCATION ON DRAFT   -- contract, all allocations and dps dates and periods are updated
            // arrange 
            const string contractNumberToTest = "APPLEVY-1000";
            const int versionToTest = 2;
            const string nonLevyFsp = "NONLEVY2019";
            const string levyFsp = "LEVY1799";

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);
            const string updatedPeriodName = "Dec-18";
            const int updatedPeriodNumber = 12;

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LEVY");
            var period = GetPeriod("LEVY1799");

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period, false, version: versionToTest, initialContractStartDateTime);
            // levy allocation
            var levyAllocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "LEVY1799ALLOC", levyFsp);
            var levyDeliverableId = CreateDeliverable(levyAllocationId);
            CreateDeliverablePeriod(contractDeliverableId: levyDeliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);
            // non levy allocation
            var nonLevyAllocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "NONLEVY2019ALLOC", nonLevyFsp);
            var nonLevyDeliverableId = CreateDeliverable(nonLevyAllocationId);
            CreateDeliverablePeriod(contractDeliverableId: nonLevyDeliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            // check contract date stays the same 
            Assert.AreEqual(updatedContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");

            // check non levy allocation - allocation date updated. dp periods updated 
            var nonLevyDates = crmDates.Where(d => d.FundingStreamPeriod == nonLevyFsp);
            var nonLevyAllocationStartDates = nonLevyDates.Select(ad => ad.AllocationDate).Distinct();
            Assert.AreEqual(updatedContractStartDateTime.Date, nonLevyAllocationStartDates.First(), "Incorrect allocation start date");

            nonLevyDates.ForEach(
                x => {
                    Assert.AreEqual(updatedPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });

            // check levy allocation - allocation date stays the same. dp periods stay the same 
            var levyDates = crmDates.Where(d => d.FundingStreamPeriod == levyFsp);
            var levyAllocationStartDates = levyDates.Select(ad => ad.AllocationDate).Distinct();
            Assert.AreEqual(updatedContractStartDateTime.Date, levyAllocationStartDates.First(), "Incorrect allocation start date");

            levyDates.ForEach(
                x => {
                    Assert.AreEqual(updatedPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(updatedContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldNotUpdateAnyDatesWhenNotALevyContractAndWasPreviouslyApproved()
        {
            // NON LEVY CONTRACT WITH 'PREVIOUS' LAST APPROVED VERSION on draft                      -- no changes to any dates
            // arrange 
            const string contractNumberToTest = "APPLEVY-1000";
            const string fsp = "ALLF1819";
            const int versionToTest = 2;

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";
            const int initialPeriodNumber = 5;

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LOANS");
            var period = GetPeriod("AY1819");

            var previousContractId = CreateTestContract(contractNumberToTest, fundingType, period, true, 1, initialContractStartDateTime);
            CreateContractAllocation(previousContractId, initialContractStartDateTime, "LEVY1799ALLOC", fsp);

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period, true, versionToTest, initialContractStartDateTime);
            var allocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "ALLOCNUMBER", fsp);
            var deliverableId = CreateDeliverable(allocationId);
            CreateDeliverablePeriod(contractDeliverableId: deliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");
            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().AllocationDate, "Incorrect Allocation start date");
            crmDates.ForEach(
                x => {
                    Assert.AreEqual(initialPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void InitiateContractApprovalHandler_ShouldNotUpdateAnyDatesWhenNotALevyContractIsFirstApproved()
        {
            // NON LEVY CONTRACT WITHOUT 'PREVIOUS' LAST APPROVED VERSION ON DRAFT                   -- no changes to any dates
            // arrange 
            const string contractNumberToTest = "CN - Test";
            const string fsp = "ALLF1819";
            const int versionToTest = 2;

            var initialContractStartDateTime = new DateTime(2017, 05, 01, 12, 0, 0);
            const string initialPeriodName = "May-17";
            const int initialPeriodNumber = 5;

            var updatedContractStartDateTime = new DateTime(2018, 12, 28, 12, 0, 0);

            var dateProviderMock = new Mock<IDateProvider>();
            dateProviderMock
                .Setup(x => x.GetDate(It.IsAny<ConnectionInfo>()))
                .Returns(updatedContractStartDateTime);

            var sessionConnectionFactoryMock = new Mock<ISessionConnectionFactory>();
            sessionConnectionFactoryMock
                .Setup(m => m.GetConnection(It.IsAny<IMessageHandlerContext>()))
                .Returns(new ConnectionInfo(null, new ContractManagementDbContext().Database.Connection));

            RemoveContract(contractNumberToTest, 1);
            RemoveContract(contractNumberToTest, versionToTest);
            var fundingType = GetFundingType("LOANS");
            var period = GetPeriod("AY1819");

            var contractId = CreateTestContract(contractNumberToTest, fundingType, period, false, versionToTest, initialContractStartDateTime);
            var allocationId = CreateContractAllocation(contractId, initialContractStartDateTime, "ALLOCNUMBER", fsp);
            var deliverableId = CreateDeliverable(allocationId);
            CreateDeliverablePeriod(contractDeliverableId: deliverableId, periodNumber: initialContractStartDateTime.Month, periodName: initialPeriodName, initialContractStartDateTime.Date.Year);

            using (var container = new WindsorContainer().Install(new WindsorInstaller(new LoggerFactory())))
            using (container.BeginScope())
            {
                var handler = new InitiateContractApprovalHandler(
                    Mock.Of<ILogger>(),
                    sessionConnectionFactoryMock.Object,
                    Mock.Of<IMonthEndHistoryRepository>(),
                    container.Resolve<IContractCheckerService>(),
                    dateProviderMock.Object,
                    container.Resolve<ICrmContractDeliverablePeriodRepository>(),
                    container.Resolve<ICrmContractRepository>(),
                    container.Resolve<ICrmContractAllocationRepository>(),
                    container.Resolve<IFundingTypeFundingPeriodService>(),
                    container.Resolve<IXrmManager>(),
                    container.Resolve<IContractsManager>());

                // act
                handler.Handle(new InitiateContractApprovalCommand
                {
                    ContractNumber = contractNumberToTest,
                    MasterContractNumber = null,
                    ContractVersionNumber = versionToTest
                }, new TestableMessageHandlerContext()).Wait();
            }

            // assert
            var crmDates = GetCrmDates(contractNumberToTest, versionToTest);

            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().ContractDate, "Incorrect Contract start date");
            Assert.AreEqual(initialContractStartDateTime.Date, crmDates.First().AllocationDate, "Incorrect Allocation start date");
            crmDates.ForEach(
                x => {
                    Assert.AreEqual(initialPeriodNumber, x.CdpPeriodNumber, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialPeriodName, x.CdpPeriodName, "Incorrect period number in contract deliverable period");
                    Assert.AreEqual(initialContractStartDateTime.Date.Year, x.CdpYear, "Incorrect year in contract deliverable period");
                });
        }

        private static IReadOnlyCollection<CrmDates> GetCrmDates(string contractNumber, int? contractVersion)
        {
            using (var xrmContext = new XrmServiceContext(GetConnection()))
            {
                return (from c in xrmContext.sfa_contractSet
                        join a in xrmContext.sfa_contractallocationSet on c.sfa_contractId equals a.sfa_ContractId.Id
                        join fsp in xrmContext.sfa_fundingstreamperiodSet on a.sfa_FundingStreamPeriodId.Id equals fsp.sfa_fundingstreamperiodId
                        join d in xrmContext.sfa_contractdeliverableSet on a.sfa_contractallocationId equals d.sfa_ContractAllocationId.Id
                        join dp in xrmContext.sfa_contractdeliverableperiodSet on d.sfa_contractdeliverableId equals dp.sfa_ContractDeliverableId.Id
                        where c.sfa_number == contractNumber && (c.sfa_Version == contractVersion || c.sfa_LatestVersion == true)
                        select new CrmDates(c.sfa_StartDate.Value.Date,
                                            a.sfa_startdate.Value.Date,
                                            dp.sfa_PeriodName,
                                            dp.sfa_Period.Value,
                                            dp.sfa_Year,
                                            dp.sfa_name,
                                            a.sfa_contractallocationnumber,
                                            fsp.sfa_fundingstreamperiodcode)).ToList();
            }
        }

        private static Guid CreateTestContract(string contractNumber, Guid fundingType, Guid period, bool lastApprovedVersion, int version, DateTime startDateTime)
        {
            var contract = new sfa_contract
            {
                sfa_UKPRN = "1111",
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = lastApprovedVersion,
                sfa_ProviderName = GetProvider().EntityReference,
                sfa_FundingType = new EntityReference(sfa_fundingtype.EntityLogicalName, fundingType),
                sfa_PeriodId = new EntityReference(sfa_period.EntityLogicalName, period),
                sfa_StartDate = startDateTime
            };
            return GetConnection().Create(contract);
        }

        private static Guid CreateContractAllocation(Guid contractId, DateTime setupDateTime, string allocationNumber, string fspCode)
        {
            var allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_contractallocationnumber = allocationNumber,
                sfa_startdate = setupDateTime,
                sfa_FundingStreamPeriodId = GetFundingStreamPeriodEntityRef(fspCode)
            };

            return GetConnection().Create(allocation);
        }

        private static Guid CreateDeliverable(Guid allocationId)
        {
            var deliverable = new sfa_contractdeliverable
            {
                sfa_ContractAllocationId = new EntityReference(sfa_contract.EntityLogicalName, allocationId),
            };

            return GetConnection().Create(deliverable);
        }

        private static void CreateDeliverablePeriod(Guid contractDeliverableId, int periodNumber, string periodName, int year)
        {
            var deliverableperiod = new sfa_contractdeliverableperiod
            {
                sfa_ContractDeliverableId = new EntityReference(sfa_contract.EntityLogicalName, contractDeliverableId),
                sfa_Period = periodNumber,
                sfa_PeriodName = periodName,
                sfa_Year = year
            };

            GetConnection().Create(deliverableperiod);
        }

        private static Provider GetProvider()
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                var org = crmContext.AccountSet.First(a => a.sfa_UKPRN != null);

                return new Provider(org.sfa_UKPRN, org.ToEntityReference());
            }
        }

        private static void RemoveContract(string contractNumber, int version)
        {
            using (var context = new XrmServiceContext(GetConnection()))
            {
                context.sfa_contractSet.Where(c => c.sfa_number == contractNumber && c.sfa_Version == version)
                    .ForEach(c => GetConnection().Delete(sfa_contract.EntityLogicalName, c.Id));
            }
        }

        public static IOrganizationService GetConnection()
        {
            return CrmConnectionFactory.GetRetryOnErrorOrganizationService();
        }

        private static Guid GetFundingType(string fundingTypeCode)
        {
            using (var serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_fundingtypeSet.First(f => f.sfa_fundingtypecode == fundingTypeCode).Id;
            }
        }

        private static Guid GetPeriod(string periodName)
        {
            using (var serviceContext = new XrmServiceContext(GetConnection()))
            {
                return serviceContext.sfa_periodSet.First(p => p.sfa_periodname == periodName).Id;
            }
        }

        private static EntityReference GetFundingStreamPeriodEntityRef(string fspCode)
        {
            using (var crmContext = new XrmServiceContext(GetConnection()))
            {
                return crmContext.sfa_fundingstreamperiodSet.First(fsp => fsp.sfa_fundingstreamperiodcode == fspCode).ToEntityReference();
            }
        }

        private class Provider
        {
            public Provider(string ukprn, EntityReference entityReference)
            {
                Ukprn = ukprn;
                EntityReference = entityReference;
            }

            public string Ukprn { get; }
            public EntityReference EntityReference { get; }
        }


        private class CrmDates
        {
            public CrmDates(DateTime contractDate, DateTime allocationDate, string cdpPeriodName, int cdpPeriodNumber, int? cdpYear, string cdpName, string allocationNumber, string fundingStreamPeriod)
            {
                ContractDate = contractDate;
                AllocationDate = allocationDate;
                CdpPeriodName = cdpPeriodName;
                CdpPeriodNumber = cdpPeriodNumber;
                CdpYear = cdpYear;
                CdpName = cdpName;
                AllocationNumber = allocationNumber;
                FundingStreamPeriod = fundingStreamPeriod;
            }

            public DateTime ContractDate { get; }

            public DateTime AllocationDate { get; }

            public string CdpPeriodName { get; }

            public int CdpPeriodNumber { get; }

            public int? CdpYear { get; }

            public string CdpName { get; }

            public string AllocationNumber { get; }

            public string FundingStreamPeriod { get; }
        }
    }
}
