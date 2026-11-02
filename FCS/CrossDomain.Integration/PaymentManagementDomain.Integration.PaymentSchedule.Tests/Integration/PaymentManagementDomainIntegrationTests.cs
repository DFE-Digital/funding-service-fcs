namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Integration
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using BusinessLogic;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Framework.Logging.Interfaces;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.WindowsAzure.Storage;
    using Microsoft.WindowsAzure.Storage.Blob;
    using Moq;
    using MoreLinq;
    using PolicyCache.DataStore.Model;
    using PolicyCache.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.PaymentManagementDomain.Integration.RulesEngine;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using Utils;

    [TestClass]
    public class PaymentManagementDomainIntegrationTests
    {
        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void PaymentManager_CalculatePaymentScheduleOnApproval_ShouldReturnNonNullResult()
        {
            // arrange
            allocationType allocation = TestAllocation.Create("24+ALLBC1516");

            PaymentManager manager = GetPaymentManager();
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            dateProviderMock.Setup(r => r.GetCalculationDate())
                .Returns(new DateTime(2015, 08, 01, 0, 0, 0, DateTimeKind.Utc));
            dateProviderMock.Setup(r => r.GetCalculationDateWithKey(It.IsAny<string>()))
                .Returns(new DateTime(2015, 08, 01, 0, 0, 0, DateTimeKind.Utc));
            manager.DateManager = dateProviderMock.Object;
            manager.PayCalcPolicyQueryRepository = PayCalcPolicyQueryRepository.CreateInstance(new PaymentManagementPolicyContext());

            // act 
            Allocation result = manager.CalculatePaymentScheduleOnApproval(allocation);

            // assert
            Assert.IsNotNull(result);
        }

        [TestMethod, TestCategory("IntegrationTestNightlyBuild")]
        public void PaymentManager_CalculatePaymentScheduleOnApproval_ShouldSaveOpaOutputToBlobStorageWhenConfiguredInAppSettings()
        {
            // arrange
            ConfigurationManager.AppSettings["Opa.OutputXmlBlob"] = "true";
            
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(ConfigurationManager.ConnectionStrings["StorageConnectionString"].ConnectionString);
            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            CloudBlobContainer container = blobClient.GetContainerReference(ConfigurationManager.AppSettings["Opa.OutputContainer"]);

            container.ListBlobs()
                .OfType<CloudBlockBlob>()
                .Where(blob => blob.Name.EndsWith(".xds"))
                .Select(blob => container.GetBlockBlobReference(blob.Name))
                .ForEach(blob => blob.DeleteIfExists());

            allocationType allocation = TestAllocation.Create("24+ALLBC1516");

            PaymentManager manager = GetPaymentManager();
            Mock<IDate> dateProviderMock = new Mock<IDate>();
            dateProviderMock.Setup(r => r.GetCalculationDate())
                .Returns(new DateTime(2015, 08, 01, 0, 0, 0, DateTimeKind.Utc));
            dateProviderMock.Setup(r => r.GetCalculationDateWithKey(It.IsAny<string>()))
                .Returns(new DateTime(2015, 08, 01, 0, 0, 0, DateTimeKind.Utc));
            manager.DateManager = dateProviderMock.Object;
            manager.PayCalcPolicyQueryRepository = new PayCalcPolicyQueryRepository(new PaymentManagementPolicyContext(), new EntityCache<string, PolicyFundingStreamPeriod>(), new EntityCache<string, IReadOnlyCollection<PolicyDeliverable>>(), new EntityCache<string, IReadOnlyCollection<CappingGroup>>());

            // act 
            manager.CalculatePaymentScheduleOnApproval(allocation);

            // assert
            Assert.IsTrue(container.ListBlobs().Any(blob => blob.Uri.ToString().EndsWith(".xds")), "No .xds OPA output file was created in blob storage");
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void PaymentManager_CalculatePaymentScheduleOnApproval_ShouldSuccessfullyConvertContractAllocationToPaymentSchedule()
        {
            Mock<IPayCalcPolicyQueryRepository> payCalcPolicyQueryRepositoryMock = new Mock<IPayCalcPolicyQueryRepository>();
            payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriodDeliverables(It.IsAny<string>()))
                .Returns(new[]
                {
                    new PolicyDeliverable
                    {
                        FundingStreamPeriod = "FSPC1",
                        DeliverableCode = 1
                    }
                });
            payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriod(It.IsAny<string>()))
                .Returns(new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = "FSPC1",
                    PaymentMethod = PaymentMethod.PayOnActuals,
                });
            payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriodCensusDates(It.IsAny<string>()))
                .Returns(new[]
                {
                    new PolicyFundingStreamCensusDate
                    {
                        CensusDate = DateTime.Now,
                        FundingStreamPeriod = "FSPC1",
                        CalendarYear = 2015,
                        CalendarPeriod = 1
                    }
                });
            payCalcPolicyQueryRepositoryMock
                .Setup(m => m.GetFundingStreamPeriodCappingGroups(It.IsAny<string>()))
                .Returns(new List<CappingGroup>());

            payCalcPolicyQueryRepositoryMock.Setup(
                r => r.GetDeliverableCodesWherePlannedValueShouldNotBeUsedInCalc(It.IsAny<string>()))
                .Returns(new List<int>());

            PaymentManager manager = GetPaymentManager();
            manager.PayCalcPolicyQueryRepository = payCalcPolicyQueryRepositoryMock.Object;

            //Act 
            var allocation = TestAllocation.Create();

            Allocation result = manager.CalculatePaymentScheduleOnApproval(allocation);

            //Assert 
            Assert.IsNotNull(result, "Result should not be null.");
            Assert.IsTrue(result.ContractNumber == allocation.contractReference.contractNumber);
            Assert.IsTrue(result.VersionNumber == allocation.contractReference.contractVersionNumber);
        }

        private PaymentManager GetPaymentManager()
        {
            return new PaymentManager
            {                 
                PublishedPayableFcrAllocationRepository = new PublishedPayableFcrAllocationRepository(new PaymentSchedulePolicyContext()),
                Logger = Mock.Of<ILogger>(),
                DateManager = new SystemDate(),
                AllocationRepository = new AllocationRepository(new PaymentSchedulePolicyContext()),
                RulesEngine = new RulesEngine
                {
                    StorageWrapper = new AzureStorageWriter()
                }
            };
        }
    }
}
