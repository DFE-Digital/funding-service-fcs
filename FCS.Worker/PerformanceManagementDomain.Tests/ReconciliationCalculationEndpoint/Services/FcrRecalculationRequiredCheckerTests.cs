namespace PerformanceManagementDomain.Tests.ReconciliationCalculationEndpoint.Services
{
    using System;
    using System.Collections.Generic;
    using Castle.MicroKernel.Lifestyle;
    using Castle.Windsor;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.Framework.Logging;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.CrmRepositories;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint.Services;
    using Castle.MicroKernel.Registration;
    using SFA.FCT.Framework.Logging.Interfaces;
    using PerformanceManagementDomain.ReconciliationCalculationEndpoint;

    [TestClass]
    public class FcrRecalculationRequiredCheckerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FcrRecalculationRequiredChecker_CheckIfRecalculationRequired_ShouldReturnTrueWhenPlannedValueIsDifferentAndDraftPresent()
        {
            // arrange
            const string allocationNumber = "allocNo";
            const decimal newPlannedValue = 10;
            decimal? existingValue = 5;

            IReadOnlyCollection<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo> allocationsPlannedValue =
                new List<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo>
                {
                    new PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo(allocationNumber, existingValue)
                };

            Mock<ICrmFundingClaimReconciliationRepository> crmFundingClaimReconciliationRepository =
                new Mock<ICrmFundingClaimReconciliationRepository>();
            crmFundingClaimReconciliationRepository.Setup(
                r => r.GetFundingClaimReconciliationInfos(It.IsAny<string>())).Returns(new List<FundingClaimReconciliationInformation>
                {
                    new FundingClaimReconciliationInformation(true,
                        string.Empty,
                        string.Empty,
                        string.Empty,
                        string.Empty,
                        0,
                        string.Empty,
                        Guid.Empty, 
                        0)
                });

            FcrRecalculationRequiredChecker checker = new FcrRecalculationRequiredChecker(crmFundingClaimReconciliationRepository.Object);

            // act
            var result = checker.CheckIfRecalculationRequired(allocationsPlannedValue, allocationNumber, newPlannedValue);

            // assert
            Assert.AreEqual(true, result.IsCalculationRequired, "A Calculation is required");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FcrRecalculationRequiredChecker_CheckIfRecalculationRequired_ShouldReturnFalseWhenPlannedValueIsTheSameAndDraftPresent()
        {
            // arrange
            const string allocationNumber = "allocNo";
            const decimal newPlannedValue = 5;
            decimal? existingValue = 5;

            IReadOnlyCollection<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo> allocationsPlannedValue = 
                new List<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo>
                    { new PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo(allocationNumber, existingValue)};

            Mock<ICrmFundingClaimReconciliationRepository> crmFundingClaimReconciliationRepository =
                new Mock<ICrmFundingClaimReconciliationRepository>();
            crmFundingClaimReconciliationRepository.Setup(
                r => r.GetFundingClaimReconciliationInfos(It.IsAny<string>())).Returns(new List<FundingClaimReconciliationInformation>
                {
                    new FundingClaimReconciliationInformation(true,
                        string.Empty,
                        string.Empty,
                        string.Empty,
                        string.Empty,
                        0,
                        string.Empty,
                        Guid.Empty,
                        0)
                });

            FcrRecalculationRequiredChecker checker = new FcrRecalculationRequiredChecker(crmFundingClaimReconciliationRepository.Object);

            // act
            var result = checker.CheckIfRecalculationRequired(allocationsPlannedValue, allocationNumber, newPlannedValue);

            // assert
            Assert.AreEqual(false, result.IsCalculationRequired, "A Calculation is not required");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FcrRecalculationRequiredChecker_CheckIfRecalculationRequired_ShouldReturnTrueWhenAllocationNotPresentInDb()
        {
            // arrange
            const string allocationNumber = "allocNo";
            const decimal newPlannedValue = 5;
            decimal? existingValue = 5;

            IReadOnlyCollection<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo> allocationsPlannedValue =
                new List<PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo>
                    { new PerformanceManagementDomain.ReconciliationCalculationEndpoint.DTOs.AllocationInfo(allocationNumber, existingValue)};

            Mock<ICrmFundingClaimReconciliationRepository> crmFundingClaimReconciliationRepository =
                new Mock<ICrmFundingClaimReconciliationRepository>();
            crmFundingClaimReconciliationRepository.Setup(
                r => r.GetFundingClaimReconciliationInfos(It.IsAny<string>())).Returns(new List<FundingClaimReconciliationInformation>());

            FcrRecalculationRequiredChecker checker = new FcrRecalculationRequiredChecker(crmFundingClaimReconciliationRepository.Object);

            // act
            var result = checker.CheckIfRecalculationRequired(allocationsPlannedValue, "Some other", newPlannedValue);

            // assert
            Assert.AreEqual(false, result.IsCalculationRequired, "A Calculation is not required");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FcrRecalculationRequiredChecker_ShouldResolve()
        {
            var checker = GetContainer().Resolve<IFcrRecalculationRequiredChecker>();

            Assert.IsNotNull(checker);
        }

        private static IWindsorContainer GetContainer()
        {
            ILoggerFactory factory = new LoggerFactory();

            IWindsorContainer container =
                new WindsorContainer().Install(new WindsorInstaller(factory));
            container.Register(
              Component.For<IPerformanceManagementDbContext>()
                  .ImplementedBy<PerformanceManagementDbContext>().IsDefault()
                  .LifestyleSingleton());
            container.BeginScope();

            return container;
        }
    }
}