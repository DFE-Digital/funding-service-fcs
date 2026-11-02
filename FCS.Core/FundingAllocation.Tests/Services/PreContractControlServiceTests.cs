namespace FundingAllocation.Tests.Services
{
    using System.Collections.Generic;
    using System.Data.SqlClient;
    using System.Linq;
    using DataStore;
    using FluentAssertions;
    using FundingAllocation.Dto;
    using FundingAllocation.Extensions;
    using FundingAllocation.Repositories;
    using FundingAllocation.Services;
    using Microsoft.EntityFrameworkCore;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using DataStore.Model;
    using TestHelpers;
    using TestHelpers.Extensions;

    [TestClass]
    public class PreContractControlServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlService_GetParkCheckResult_ShouldReturnThoseThatNeedParkingAndThoseThatDont()
        {
            // arrange
            const string fundingIdThatIsInContractControlOne = "1619-AY-2021-Contract-Provider-10017059-2_0";
            const string fundingIdThatIsInContractControlTwo = "1619-AY-2021-Contract-Provider-10017060-2_0";
            const int someReadId = 2;
            List<int> indexesOfFundingIdsForContractControl = new List<int> {0, 1, 4};
            List<string> fundingIdsThatAreInContractControl = new List<string>
                {fundingIdThatIsInContractControlOne, fundingIdThatIsInContractControlTwo};
            List<string> fundingIds = new List<string>
            {
                "1619-AY-2021-Contract-Provider-10017057-2_0",
                "1619-AY-2021-Contract-Provider-10017058-2_0",
                fundingIdThatIsInContractControlOne,
                fundingIdThatIsInContractControlTwo,
                "1619-AY-2021-Contract-Provider-10017061-2_0"
            };

            Mock<IFundingAllocationRepository> fundingAllocationRepMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepMock.Setup(r =>
                    r.GetFundingAllocationNamesInContractControlWithoutOutcome(It.IsAny<IReadOnlyCollection<string>>(), It.IsAny<int>()))
                .ReturnsAsync(fundingIdsThatAreInContractControl.Select(fId => fId.RemoveVersionFromId()).ToList());
            fundingAllocationRepMock.Setup(r =>
                    r.GetFundingAllocationsIncludingProvidersAndLines(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync((IEnumerable<string> fundingIdsInput) =>
                    fundingIdsInput.Select(fId => FundingAllocationHelper.FundingAllocationWithFundingId(fId).WithProviderAndLines(1)).ToList());

            Mock<INonMaterialCheckService> nonMaterialCheckMock = new Mock<INonMaterialCheckService>();
            nonMaterialCheckMock.Setup(s => s.GetFilterCheckResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync((IReadOnlyCollection<string> fIds) => new FilterCheckResult(fIds, new List<string>()));

            nonMaterialCheckMock.Setup(s => s.GetLoanFilterCheckResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync((IReadOnlyCollection<string> fIds) => new FilterCheckResult(fIds, new List<string>()));

            Mock<IConfigValidationService> configValidationServiceMock = new Mock<IConfigValidationService>();
            configValidationServiceMock.Setup(c =>
                    c.GetAwaitingConfigFilterResult(It.IsAny<IReadOnlyCollection<FundingAllocationValidationInput>>()))
                .ReturnsAsync((IReadOnlyCollection<FundingAllocationValidationInput> input) =>
                    new ConfigValidationResult(
                        new List<string>(),
                        new List<string>(),
                        new List<string>(),
                        input.Select(i => i.FundingId).ToList()));

            PreContractControlService service =
                new PreContractControlService(
                    fundingAllocationRepMock.Object,
                    nonMaterialCheckMock.Object,
                    configValidationServiceMock.Object);

            // act
            var parkResult = service.GetParkCheckResult(fundingIds, someReadId).Result;

            // assert
            parkResult.FundingAllocationsForContractControl.Count.Should().Be(indexesOfFundingIdsForContractControl.Count);
            indexesOfFundingIdsForContractControl.ForEach(i =>
            {
                parkResult.FundingAllocationsForContractControl.Select(fa => fa.FundingId).Should().Contain(fundingIds[i]);
            });

            parkResult.FundingIdsForParkingAwaitingOutcome.Count.Should().Be(fundingIdsThatAreInContractControl.Count);
            fundingIdsThatAreInContractControl.ForEach(f => { parkResult.FundingIdsForParkingAwaitingOutcome.Should().Contain(f); });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlService_GetParkCheckResult_ShouldReturnFailedContractTypeConfigFundingIdsAheadOfCheckForAwaitingOutcome()
        {
            // arrange
            const string fundingIdThatIsInContractControlOne = "1619-AY-2021-Contract-Provider-10017059-2_0";
            const string fundingIdThatIsInContractControlTwo = "1619-AY-2021-Contract-Provider-10017060-2_0";
            const int someReadId = 2;
            List<int> indexesOfFundingIdsForContractControl = new List<int> { 0, 1, 4 };
            List<string> fundingIdsThatAreInContractControl = new List<string>
                {fundingIdThatIsInContractControlOne, fundingIdThatIsInContractControlTwo};
            List<string> fundingIds = new List<string>
            {
                "1619-AY-2021-Contract-Provider-10017057-2_0",
                "1619-AY-2021-Contract-Provider-10017058-2_0",
                fundingIdThatIsInContractControlOne,
                fundingIdThatIsInContractControlTwo,
                "1619-AY-2021-Contract-Provider-10017061-2_0"
            };

            Mock<IFundingAllocationRepository> fundingAllocationRepMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepMock.Setup(r =>
                    r.GetFundingAllocationNamesInContractControlWithoutOutcome(It.IsAny<IReadOnlyCollection<string>>(), It.IsAny<int>()))
                .ReturnsAsync(fundingIdsThatAreInContractControl.Select(fId => fId.RemoveVersionFromId()).ToList());
            fundingAllocationRepMock.Setup(r =>
                    r.GetFundingAllocationsIncludingProvidersAndLines(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync((IEnumerable<string> fundingIdsInput) =>
                    fundingIdsInput.Select(fId => FundingAllocationHelper.FundingAllocationWithFundingId(fId).WithProviderAndLines(1)).ToList());

            Mock<INonMaterialCheckService> nonMaterialCheckMock = new Mock<INonMaterialCheckService>();
            nonMaterialCheckMock.Setup(s => s.GetFilterCheckResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync((IReadOnlyCollection<string> fIds) => new FilterCheckResult(fIds, new List<string>()));
           
            nonMaterialCheckMock.Setup(s => s.GetLoanFilterCheckResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync((IReadOnlyCollection<string> fIds) => new FilterCheckResult(fIds, new List<string>()));

            Mock<IConfigValidationService> configValidationServiceMock = new Mock<IConfigValidationService>();
            configValidationServiceMock.Setup(c =>
                    c.GetAwaitingConfigFilterResult(It.IsAny<IReadOnlyCollection<FundingAllocationValidationInput>>()))
                .ReturnsAsync((IReadOnlyCollection<FundingAllocationValidationInput> input) =>
                    new ConfigValidationResult(
                        new List<string>(),
                        input.Select(i => i.FundingId).ToList(),
                        new List<string>(),
                        new List<string>()));

            PreContractControlService service =
                new PreContractControlService(
                    fundingAllocationRepMock.Object,
                    nonMaterialCheckMock.Object,
                    configValidationServiceMock.Object);

            // act
            var parkResult = service.GetParkCheckResult(fundingIds, someReadId).Result;

            // assert
            parkResult.FundingAllocationsForContractControl.Count.Should().Be(0);
            parkResult.FundingIdsAwaitingContractTypeConfig.Count.Should().Be(fundingIds.Count);
            parkResult.FundingIdsAwaitingContractTypeConfig.Should()
                .BeEquivalentTo(parkResult.FundingIdsAwaitingContractTypeConfig);
            
            parkResult.FundingIdsForParkingAwaitingOutcome.Count.Should().Be(0);
            parkResult.FundingIdsAwaitingFundingLineConfig.Count.Should().Be(0);
            parkResult.FundingIdsAwaitingFundingAllocationConfig.Count.Should().Be(0);
            parkResult.FundingIdsForDiscardingNonMaterialUpdate.Count.Should().Be(0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreContractControlService_GetParkCheckResult_ShouldReturnSomeFailedAndSomeForContractControl()
        {
            // arrange
            
            const int someReadId = 2;
            const string fundingIdExpectedToFailContractType = "1619-AY-2021-Contract-Provider-10017057-2_0";
            const string fundingIdExpectedToFailFundingAllocation = "1619-AY-2021-Contract-Provider-10017058-2_0";
            const string fundingIdExpectedToFailFundingLine = "1619-AY-2021-Contract-Provider-10017059-2_0";
            List<string> fundingIdsThatPassConfigValidation = new List<string>
            {
                "1619-AY-2021-Contract-Provider-10017060-2_0",
                "1619-AY-2021-Contract-Provider-10017061-2_0"
            };
            List<string> fundingIds = new List<string>(fundingIdsThatPassConfigValidation)
            {
                fundingIdExpectedToFailContractType,
                fundingIdExpectedToFailFundingAllocation,
                fundingIdExpectedToFailFundingLine,
            };

            Mock<IFundingAllocationRepository> fundingAllocationRepMock = new Mock<IFundingAllocationRepository>();
            fundingAllocationRepMock.Setup(r =>
                    r.GetFundingAllocationNamesInContractControlWithoutOutcome(It.IsAny<IReadOnlyCollection<string>>(), It.IsAny<int>()))
                .ReturnsAsync(new List<string>());
            fundingAllocationRepMock.Setup(r =>
                    r.GetFundingAllocationsIncludingProvidersAndLines(It.IsAny<IEnumerable<string>>()))
                .ReturnsAsync((IEnumerable<string> fundingIdsInput) =>
                    fundingIdsInput.Select(fId => FundingAllocationHelper.FundingAllocationWithFundingId(fId).WithProviderAndLines(1)).ToList());

            Mock<INonMaterialCheckService> nonMaterialCheckMock = new Mock<INonMaterialCheckService>();
            nonMaterialCheckMock.Setup(s => s.GetFilterCheckResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync((IReadOnlyCollection<string> fIds) => new FilterCheckResult(fIds, new List<string>()));
            nonMaterialCheckMock.Setup(s => s.GetLoanFilterCheckResult(It.IsAny<IReadOnlyCollection<string>>()))
                .ReturnsAsync((IReadOnlyCollection<string> fIds) => new FilterCheckResult(fIds, new List<string>()));

            Mock<IConfigValidationService> configValidationServiceMock = new Mock<IConfigValidationService>();
            configValidationServiceMock.Setup(c =>
                    c.GetAwaitingConfigFilterResult(It.IsAny<IReadOnlyCollection<FundingAllocationValidationInput>>()))
                .ReturnsAsync(new ConfigValidationResult(
                        new List<string>{ fundingIdExpectedToFailFundingAllocation },
                        new List<string>{ fundingIdExpectedToFailContractType }, 
                        new List<string>{ fundingIdExpectedToFailFundingLine },
                        new List<string>(fundingIdsThatPassConfigValidation)));

            PreContractControlService service =
                new PreContractControlService(
                    fundingAllocationRepMock.Object,
                    nonMaterialCheckMock.Object,
                    configValidationServiceMock.Object);

            // act
            var parkResult = service.GetParkCheckResult(fundingIds, someReadId).Result;

            // assert
            parkResult.FundingAllocationsForContractControl.Select(fa=> fa.FundingId).Should()
                .BeEquivalentTo(fundingIdsThatPassConfigValidation);
            parkResult.FundingIdsForDiscardingNonMaterialUpdate.Should().BeEquivalentTo(new List<string>());
            parkResult.FundingIdsAwaitingContractTypeConfig.Should().BeEquivalentTo(new List<string>{fundingIdExpectedToFailContractType});
            parkResult.FundingIdsAwaitingFundingAllocationConfig.Should().BeEquivalentTo(new List<string> { fundingIdExpectedToFailFundingAllocation });
            parkResult.FundingIdsAwaitingFundingLineConfig.Should().BeEquivalentTo(new List<string> { fundingIdExpectedToFailFundingLine });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreContractControlService_SetStatuses_ShouldSetStatusAndSubStatusWhenOneInContractControl()
        {
            // arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingIdInContractControl = "1619-AS-2021-Contract-Provider-10017561-1_6";
            const string fundingId2 = "1619-AS-2021-Contract-Provider-10017561-2_0";
            const int pageNumber = 1;

            var fundingIdsForDiscarding = Enumerable.Empty<string>().ToList();
            var fundingIdsForParking = new List<string>{ fundingId2 };

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocationInContractControl = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdInContractControl)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            var fundingAllocationForParking = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId2)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(
                    fundingAllocationInContractControl.WithReadId(feedReadId).ForContract(contract.Id),
                    fundingAllocationForParking.WithReadId(feedReadId).ForContract(contract.Id)) 
                .SaveChanges();

            PreContractControlService service =
                new PreContractControlService(new FundingAllocationRepository(context),
                    Mock.Of<INonMaterialCheckService>(),
                     Mock.Of<IConfigValidationService>());

            // act
            service.SetStatuses(
                fundingIdsForParking,
                fundingIdsForDiscarding,
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string>()).Wait();

            // assert
            fundingAllocationInContractControl = GetFundingAllocation(fundingIdInContractControl);
            fundingAllocationInContractControl.Status.Should().Be(null);
            fundingAllocationInContractControl.SubStatus.Should().Be(null);
            var fundingAllocation2 = GetFundingAllocation(fundingId2);
            fundingAllocation2.Status.Should().Be(FundingAllocationStatus.Parked.ToString());
            fundingAllocation2.SubStatus.Should().Be(FundingAllocationSubStatus.AwaitingOutcome.ToString());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreContractControlService_SetStatuses_ShouldSetStatusAndSubStatusWhenOneInContractControlAndOneAlreadyParked()
        {
            // arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingIdInContractControl = "1619-AS-2021-Contract-Provider-10017561-1_6";
            const string fundingIdAlreadyParked = "1619-AS-2021-Contract-Provider-10017561-2_0";
            const string fundingId3 = "1619-AS-2021-Contract-Provider-10017561-3_0";
            const int pageNumber = 1;

            var fundingIdsForDiscarding = Enumerable.Empty<string>().ToList();
            var fundingIdsForParking = new List<string> { fundingId3 };

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocationInContractControl = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdInContractControl)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            var fundingAllocationAlreadyParked = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAlreadyParked)
                .WithStatus(FundingAllocationStatus.Parked)
                .WithSubStatus(FundingAllocationSubStatus.AwaitingOutcome)
                .WithPageNumber(pageNumber);

            var fundingAllocation3 = FundingAllocationHelper.FundingAllocationWithFundingId(fundingId3)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(
                    fundingAllocationInContractControl.WithReadId(feedReadId).ForContract(contract.Id),
                    fundingAllocationAlreadyParked.WithReadId(feedReadId).ForContract(contract.Id),
                    fundingAllocation3.WithReadId(feedReadId).ForContract(contract.Id))
                .SaveChanges();

            PreContractControlService service =
                new PreContractControlService(new FundingAllocationRepository(context),
                    Mock.Of<INonMaterialCheckService>(),
                     Mock.Of<IConfigValidationService>());

            // act
            service.SetStatuses(
                fundingIdsForParking,
                fundingIdsForDiscarding,
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string>()).Wait();

            // assert
            fundingAllocationInContractControl = GetFundingAllocation(fundingIdInContractControl);
            fundingAllocationInContractControl.Status.Should().Be(null);
            fundingAllocationInContractControl.SubStatus.Should().Be(null);
            fundingAllocationAlreadyParked = GetFundingAllocation(fundingIdAlreadyParked);
            fundingAllocationAlreadyParked.Status.Should().Be(FundingAllocationStatus.Parked.ToString());
            fundingAllocationAlreadyParked.SubStatus.Should().Be(FundingAllocationSubStatus.AwaitingOutcome.ToString());
            fundingAllocation3 = GetFundingAllocation(fundingId3);
            fundingAllocation3.Status.Should().Be(FundingAllocationStatus.Parked.ToString());
            fundingAllocation3.SubStatus.Should().Be(FundingAllocationSubStatus.AwaitingOutcome.ToString());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreContractControlService_SetStatuses_ShouldSetStatusAndSubStatusCorrectlyForDiscardedNonMaterial()
        {
            // arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingIdNonMaterial = "1619-AS-2021-Contract-Provider-10017561-1_6";
            const int pageNumber = 1;

            var fundingIdsForDiscardingNonMaterial = new List<string>{fundingIdNonMaterial};
            var fundingIdsForParking = Enumerable.Empty<string>().ToList();

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var fundingAllocationNonMaterial = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdNonMaterial)
                .WithStatus(FundingAllocationStatus.NotSet)
                .WithSubStatus(FundingAllocationSubStatus.NotSet)
                .WithPageNumber(pageNumber);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(
                    fundingAllocationNonMaterial.WithReadId(feedReadId).ForContract(contract.Id)) 
                .SaveChanges();

            PreContractControlService service =
                new PreContractControlService(new FundingAllocationRepository(context),
                    Mock.Of<INonMaterialCheckService>(),
                     Mock.Of<IConfigValidationService>());

            // act
            service.SetStatuses(
                fundingIdsForParking,
                fundingIdsForDiscardingNonMaterial,
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string>()).Wait();

            // assert
            fundingAllocationNonMaterial = GetFundingAllocation(fundingIdNonMaterial);
            fundingAllocationNonMaterial.Status.Should().Be(FundingAllocationStatus.Discarded.ToString());
            fundingAllocationNonMaterial.SubStatus.Should().Be(FundingAllocationSubStatus.NonMaterialUpdate.ToString());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreContractControlService_SetStatuses_ShouldSetStatusAndSubStatusCorrectlyForFundingAllocationsAwaitingConfig()
        {
            // arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingIdAwaitingContractType = "fundingIdAwaitingContractType";
            const string fundingIdAwaitingFundingLine = "fundingIdAwaitingFundingLine";
            const string fundingIdAwaitingFundingAllocation = "fundingIdAwaitingFundingAllocation";
            const int pageNumber = 1;

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var faAwaitingContractType = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAwaitingContractType);
            var faAwaitingFundingLine = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAwaitingFundingLine);
            var faAwaitingFundingAllocationConfig = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAwaitingFundingAllocation);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(faAwaitingContractType.WithReadId(feedReadId).ForContract(contract.Id).WithPageNumber(pageNumber))
                .AddFundingAllocations(faAwaitingFundingLine.WithReadId(feedReadId).ForContract(contract.Id).WithPageNumber(pageNumber))
                .AddFundingAllocations(faAwaitingFundingAllocationConfig.WithReadId(feedReadId).ForContract(contract.Id).WithPageNumber(pageNumber))
                .SaveChanges();

            PreContractControlService service =
                new PreContractControlService(new FundingAllocationRepository(context),
                    Mock.Of<INonMaterialCheckService>(),
                     Mock.Of<IConfigValidationService>());

            // act
            service.SetStatuses(
                new List<string>(),
                new List<string>(),
                new List<string> {fundingIdAwaitingContractType},
                new List<string> {fundingIdAwaitingFundingAllocation},
                new List<string> {fundingIdAwaitingFundingLine},
                new List<string>()).Wait();

            // assert
            var fundingAllocation = GetFundingAllocation(fundingIdAwaitingContractType);
            fundingAllocation.FundingAllocationStatus.Should().Be(FundingAllocationStatus.Parked);
            fundingAllocation.FundingAllocationSubStatus.Should().Be(FundingAllocationSubStatus.AwaitingContractTypeConfig);
            
            fundingAllocation = GetFundingAllocation(fundingIdAwaitingFundingLine);
            fundingAllocation.FundingAllocationStatus.Should().Be(FundingAllocationStatus.Parked);
            fundingAllocation.FundingAllocationSubStatus.Should().Be(FundingAllocationSubStatus.AwaitingFundingLineConfig);

            fundingAllocation = GetFundingAllocation(fundingIdAwaitingFundingAllocation);
            fundingAllocation.FundingAllocationStatus.Should().Be(FundingAllocationStatus.Parked);
            fundingAllocation.FundingAllocationSubStatus.Should().Be(FundingAllocationSubStatus.AwaitingFundingAllocationConfig);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PreContractControlService_SetStatuses_ShouldSetStatusAndSubStatusCorrectlyForFundingAllocationsInContractControl()
        {
            // arrange
            const string contractNumber = "contractNumber";
            const int contractVersionNumber = 22;
            const int contractSubVersionNumber = 44;
            const string fundingIdAwaitingContractType = "fundingIdAwaitingContractType";
            const string fundingIdAwaitingFundingLine = "fundingIdAwaitingFundingLine";
            const string fundingIdAwaitingFundingAllocation = "fundingIdAwaitingFundingAllocation";
            const int pageNumber = 1;

            var contract = new Contract(contractNumber, contractVersionNumber, contractSubVersionNumber);

            var faAwaitingContractType = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAwaitingContractType);
            var faAwaitingFundingLine = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAwaitingFundingLine);
            var faAwaitingFundingAllocationConfig = FundingAllocationHelper.FundingAllocationWithFundingId(fundingIdAwaitingFundingAllocation);

            using var context = new FundingAllocationContext(DbContextOptions);
            context.RemoveAllContractsAndReferences();

            context.CreateFeedRead(out var feedReadId)
                .AddAllAndSave(new FundingAllocationPageControl(feedReadId, pageNumber))
                .AddContracts(contract)
                .AddFundingAllocations(faAwaitingContractType.WithReadId(feedReadId)
                    .WithStatusAndSubstatus(FundingAllocationStatus.Parked, FundingAllocationSubStatus.AwaitingContractTypeConfig)
                    .ForContract(contract.Id).WithPageNumber(pageNumber))
                .AddFundingAllocations(faAwaitingFundingLine.WithReadId(feedReadId)
                    .WithStatusAndSubstatus(FundingAllocationStatus.Parked, FundingAllocationSubStatus.AwaitingFundingLineConfig)
                    .ForContract(contract.Id).WithPageNumber(pageNumber))
                .AddFundingAllocations(faAwaitingFundingAllocationConfig.WithReadId(feedReadId)
                    .WithStatusAndSubstatus(FundingAllocationStatus.Parked, FundingAllocationSubStatus.AwaitingFundingAllocationConfig)
                    .ForContract(contract.Id).WithPageNumber(pageNumber))
                .SaveChanges();

            PreContractControlService service =
                new PreContractControlService(new FundingAllocationRepository(context),
                    Mock.Of<INonMaterialCheckService>(),
                     Mock.Of<IConfigValidationService>());

            // act
            service.SetStatuses(
                new List<string>(),
                new List<string>(),
                new List<string>(),
                new List<string> {fundingIdAwaitingFundingAllocation},
                new List<string>(),
                new List<string>{fundingIdAwaitingContractType, fundingIdAwaitingFundingLine}).Wait();

            // assert
            var fundingAllocationWasParkedAwaitingContractType = GetFundingAllocation(fundingIdAwaitingContractType);
            fundingAllocationWasParkedAwaitingContractType.Status.Should().BeNull();
            fundingAllocationWasParkedAwaitingContractType.SubStatus.Should().BeNull();

            var fundingAllocationWasParkedAwaitingFundingLine = GetFundingAllocation(fundingIdAwaitingFundingLine);
            fundingAllocationWasParkedAwaitingFundingLine.Status.Should().BeNull();
            fundingAllocationWasParkedAwaitingFundingLine.SubStatus.Should().BeNull();

            var fundingAllocationStillParkedAwaitingFundingAllocationConfig = GetFundingAllocation(fundingIdAwaitingFundingAllocation);
            fundingAllocationStillParkedAwaitingFundingAllocationConfig.FundingAllocationStatus.Should().Be(FundingAllocationStatus.Parked);
            fundingAllocationStillParkedAwaitingFundingAllocationConfig.FundingAllocationSubStatus.Should().Be(FundingAllocationSubStatus.AwaitingFundingAllocationConfig);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PreContractControlService_GetParkCheckResult_ShouldWork()
        {
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            PreContractControlService service = new PreContractControlService(
                new FundingAllocationRepository(context),
                new NonMaterialCheckService(new FundingAllocationRepository(context)),
                
                GetConfigValidationService(context));

            var result = service
                .GetParkCheckResult(new List<string> { "LOANS-AY-2425-Contract-Provider-10018056-3_5" }, 2912).Result;
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void PreContractControlService_GetFundingIdsToBeUnParkedOnApproval_ShouldWork()
        {
            FundingAllocationContext context = new FundingAllocationContext(DbContextOptions);
            PreContractControlService service = new PreContractControlService(
                new FundingAllocationRepository(context),
                new NonMaterialCheckService(new FundingAllocationRepository(context)),
                GetConfigValidationService(context));

            var result = service
                .GetFundingIdsToBeUnParkedOnApproval(new List<string> { "1619-AS-2021-Contract-Provider-10017561-5_1" }).Result;
        }

        private DbContextOptions<FundingAllocationContext> DbContextOptions => new DbContextOptionsBuilder<FundingAllocationContext>()
            .UseSqlServer(new SqlConnection(AppConfiguration.Configuration()["ConnectionStrings:NServiceBus/Persistence"]))
            .Options;

        private FundingAllocation GetFundingAllocation(string fundingId)
        {
            using var context = new FundingAllocationContext(DbContextOptions);

            return context.FundingAllocations.Single(fa => fa.FundingId == fundingId);
        }

        private IConfigValidationService GetConfigValidationService(FundingAllocationContext context)
        {
            return new ConfigValidationService(new ProviderCategoryRepository(context), new AllocationFundingStreamConfigRepository(context), new ContractTypeRepository(context), new AllocationLineConfigRepository(context));
        }
    }
}
