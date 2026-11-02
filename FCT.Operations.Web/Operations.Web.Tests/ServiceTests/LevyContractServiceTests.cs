namespace Operations.Web.Tests.ServiceTests
{
    using System.Collections.Generic;
    using System.Linq;
    using Dtos;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Operations.Web.Repositories;
    using Services;

    [TestClass]
    public class LevyContractServiceTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractService_GetLevyContractsThatCannotBeAmended_ShouldGetInvalidContractsOnly()
        {
            // arrange
            const string badUkprn = "122";
            const string goodUkprn = "1224";
            Mock<ICrmContractInformationRepository> crmCiRepositoryMock = new Mock<ICrmContractInformationRepository>();

            Mock<IRoatpUkprnRepository> roatpRepositoryMock = new Mock<IRoatpUkprnRepository>();
            roatpRepositoryMock.Setup(r => r.GetValidUkprns()).Returns(new List<string>
            {
                goodUkprn
            });

            crmCiRepositoryMock
                .Setup(r => r.GetLatestContractInformationByFundingTypeAndFundingPeriod(It.IsAny<string>(),
                    It.IsAny<string>())).Returns(new List<ContractInformation>
                {
                    new ContractInformation("Test Good", "Test Good M", 1, 1, goodUkprn, "Status", "SubStatus"),
                    new ContractInformation("Test Bad", "Test Bad M", 1, 1, badUkprn, "Status", "SubStatus"),
                });

            LevyContractService levyContractService = new LevyContractService(crmCiRepositoryMock.Object, roatpRepositoryMock.Object);
            
            // act
            IReadOnlyCollection<ContractInformation> invalidContracts = levyContractService.GetLevyContractsThatCannotBeAmended();

            // arrange
            Assert.AreEqual(1, invalidContracts.Count, "The number of contracts returned is incorrect");
            Assert.AreEqual(badUkprn, invalidContracts.First().Ukprn, "The contract returnedhas the wrong Ukprn is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractService_GetLevyContractsThatCannotBeAmended_ShouldGetContractsThatAreOnRoatpAndHasSubstatusAwaitingTerminationInitiationApproval()
        {
            // arrange
            const string ukprnBad = "122";
            const string ukprnGood = "1224";
            const string ukprnAwaitingTerminationInitiationApprovalSubStatus = "1225";
            const string subStatusAwaitingTerminationInitiationApproval = "Awaiting Termination Initiation Approval";

            Mock<IRoatpUkprnRepository> roatpRepositoryMock = new Mock<IRoatpUkprnRepository>();
            roatpRepositoryMock.Setup(r => r.GetValidUkprns()).Returns(new List<string>
            {
                ukprnGood,
                ukprnAwaitingTerminationInitiationApprovalSubStatus
            });

            Mock<ICrmContractInformationRepository> crmCiRepositoryMock = new Mock<ICrmContractInformationRepository>();
            crmCiRepositoryMock
                .Setup(r => r.GetLatestContractInformationByFundingTypeAndFundingPeriod(It.IsAny<string>(),
                    It.IsAny<string>())).Returns(new List<ContractInformation>
                {
                    new ContractInformation("Test Good", "Test Good M", 1, 1, ukprnGood, "Status", "SubStatus"),
                    new ContractInformation("Test Bad", "Test Bad M", 1, 1, ukprnBad, "Status", "SubStatus"),
                    new ContractInformation(
                        contractNumber: "Test Termination", masterContractNumber: "Test Termination",
                        contractVersionNumber: 1, subVersionNumber: 1,
                        ukprn: ukprnAwaitingTerminationInitiationApprovalSubStatus, contractStatus:"Status", 
                        contractSubStatus: subStatusAwaitingTerminationInitiationApproval),
                });

            LevyContractService levyContractService = new LevyContractService(crmCiRepositoryMock.Object, roatpRepositoryMock.Object);

            // act
            IReadOnlyCollection<ContractInformation> invalidContracts = levyContractService.GetLevyContractsThatCannotBeAmended();

            // arrange
            Assert.AreEqual(2, invalidContracts.Count, "The number of contracts returned is incorrect");

            var assertContract = invalidContracts.Where(ic =>
                ic.Ukprn == ukprnAwaitingTerminationInitiationApprovalSubStatus &&
                ic.ContractSubStatus == subStatusAwaitingTerminationInitiationApproval);

            Assert.IsNotNull(assertContract, "The contract with substatus 'Awaiting Termination Initiation Approval' was not included");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractService_GetLevyContractsThatCannotBeAmended_ShouldGetContractsThatAreNotOnRoatpAndHasSubstatusAwaitingTerminationInitiationApproval()
        {
            // arrange
            const string ukprnBad = "122";
            const string ukprnGood = "1224";
            const string ukprnAwaitingTerminationInitiationApprovalSubStatus = "1225";
            const string subStatusAwaitingTerminationInitiationApproval = "Awaiting Termination Initiation Approval";

            Mock<IRoatpUkprnRepository> roatpRepositoryMock = new Mock<IRoatpUkprnRepository>();
            roatpRepositoryMock.Setup(r => r.GetValidUkprns()).Returns(new List<string>
            {
                ukprnGood
            });

            Mock<ICrmContractInformationRepository> crmCiRepositoryMock = new Mock<ICrmContractInformationRepository>();
            crmCiRepositoryMock
                .Setup(r => r.GetLatestContractInformationByFundingTypeAndFundingPeriod(It.IsAny<string>(),
                    It.IsAny<string>())).Returns(new List<ContractInformation>
                {
                    new ContractInformation("Test Good", "Test Good M", 1, 1, ukprnGood, "Status", "SubStatus"),
                    new ContractInformation("Test Bad", "Test Bad M", 1, 1, ukprnBad, "Status", "SubStatus"),
                    new ContractInformation(
                        contractNumber: "Test Termination", masterContractNumber: "Test Termination",
                        contractVersionNumber: 1, subVersionNumber: 1,
                        ukprn: ukprnAwaitingTerminationInitiationApprovalSubStatus, contractStatus:"Status",
                        contractSubStatus: subStatusAwaitingTerminationInitiationApproval),
                });

            LevyContractService levyContractService = new LevyContractService(crmCiRepositoryMock.Object, roatpRepositoryMock.Object);

            // act
            IReadOnlyCollection<ContractInformation> invalidContracts = levyContractService.GetLevyContractsThatCannotBeAmended();

            // arrange
            Assert.AreEqual(2, invalidContracts.Count, "The number of contracts returned is incorrect");

            var assertContract = invalidContracts.Where(ic =>
                ic.Ukprn == ukprnAwaitingTerminationInitiationApprovalSubStatus &&
                ic.ContractSubStatus == subStatusAwaitingTerminationInitiationApproval);

            Assert.IsNotNull(assertContract, "The contract with substatus 'Awaiting Termination Initiation Approval' was not included");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractService_GetLevyContractsThatCannotBeAmended_ShouldGetContractsThatHaveSubstatusForTerminationModificationOrClosure()
        {
            // arrange
            const string ukprn = "1";
            List<(bool shouldAppearOnLevyContractList, string subStatus)> inputData =
                new List<(bool shouldAppearOnLevyContractList, string subStatus)>
                {
                    (true, "Awaiting Closure Approval"),
                    (true, "Closure Initiation in Progress"),
                    (true, "Awaiting Termination Initiation Approval"),
                    (true, "Awaiting Modification Approval"),
                    (false, "Some Other Status")
                };

            Mock<IRoatpUkprnRepository> roatpRepositoryMock = new Mock<IRoatpUkprnRepository>();
            roatpRepositoryMock
                .Setup(r => r.GetValidUkprns())
                .Returns(new List<string>
                {
                    ukprn
                });

            inputData.ForEach(input =>
            {
                Mock<ICrmContractInformationRepository> crmCiRepositoryMock = new Mock<ICrmContractInformationRepository>();
                crmCiRepositoryMock
                    .Setup(r => r.GetLatestContractInformationByFundingTypeAndFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                    .Returns(new List<ContractInformation>
                    {
                        new ContractInformation(
                            "Test Awaiting Closure Approval",
                            "Test Awaiting Closure Approval",
                            1,
                            1,
                            ukprn,
                            "APPROVED",
                            input.subStatus)
                    });

                LevyContractService levyContractService = new LevyContractService(crmCiRepositoryMock.Object, roatpRepositoryMock.Object);

                // act
                IReadOnlyCollection<ContractInformation> invalidContracts = levyContractService.GetLevyContractsThatCannotBeAmended();

                // arrange
                Assert.AreEqual(invalidContracts.Any(), input.shouldAppearOnLevyContractList, $"The number of contracts returned is incorrect for this subStatus: {input.subStatus}");
            });
        }

        //Closure Initiation in Progress
        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractService_GetLevyContractsThatCannotBeAmended_ShouldGetContractsThatHaveSubstatusOfClosureInitiationinProgress()
        {
            // arrange
            const string ukprnClosureInitiationinProgress = "1";
            const string subStatusClosureInitiationinProgress = "Closure Initiation in Progress";

            Mock<IRoatpUkprnRepository> roatpRepositoryMock = new Mock<IRoatpUkprnRepository>();
            roatpRepositoryMock
                .Setup(r => r.GetValidUkprns())
                .Returns(new List<string>
                {
                    ukprnClosureInitiationinProgress
                });

            Mock<ICrmContractInformationRepository> crmCiRepositoryMock = new Mock<ICrmContractInformationRepository>();
            crmCiRepositoryMock
                .Setup(r => r.GetLatestContractInformationByFundingTypeAndFundingPeriod(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(new List<ContractInformation>
                {
                    new ContractInformation(
                        "Test Awaiting Closure Approval",
                        "Test Awaiting Closure Approval",
                        1,
                        1,
                        ukprnClosureInitiationinProgress,
                        "APPROVED",
                        subStatusClosureInitiationinProgress)
                });

            LevyContractService levyContractService = new LevyContractService(crmCiRepositoryMock.Object, roatpRepositoryMock.Object);

            // act
            IReadOnlyCollection<ContractInformation> invalidContracts = levyContractService.GetLevyContractsThatCannotBeAmended();

            // arrange
            Assert.AreEqual(1, invalidContracts.Count, "The number of contracts returned is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void LevyContractService_GetLevyContractsThatCannotBeAmended_ShouldNotGetClosedContracts()
        {
            // arrange
            const string ukprnGood = "1224";
            const string ukprnBad = "1234";
            const string contactNumberThatShouldBeOnList = "C1";

            Mock<IRoatpUkprnRepository> roatpRepositoryMock = new Mock<IRoatpUkprnRepository>();
            roatpRepositoryMock.Setup(r => r.GetValidUkprns()).Returns(new List<string>
            {
                ukprnGood
            });

            Mock<ICrmContractInformationRepository> crmCiRepositoryMock = new Mock<ICrmContractInformationRepository>();
            crmCiRepositoryMock
                .Setup(r => r.GetLatestContractInformationByFundingTypeAndFundingPeriod(It.IsAny<string>(),
                    It.IsAny<string>())).Returns(new List<ContractInformation>
                {
                    new ContractInformation("Should Not 2", "M2", 1, 1, ukprnBad, "Closed", "Terminated"),
                    new ContractInformation("Should Not 1", "M1", 1, 1, ukprnBad, "Closed", "Closed"),
                    new ContractInformation(contactNumberThatShouldBeOnList, "M3", 1, 1, ukprnBad, "Status", "SubStatus"),
                });

            LevyContractService levyContractService = new LevyContractService(crmCiRepositoryMock.Object, roatpRepositoryMock.Object);

            // act
            IReadOnlyCollection<ContractInformation> invalidContracts = levyContractService.GetLevyContractsThatCannotBeAmended();

            // arrange
            Assert.AreEqual(1, invalidContracts.Count, "The number of contracts returned is incorrect");
            Assert.IsTrue(invalidContracts.Any(c => c.ContractNumber == contactNumberThatShouldBeOnList), "The expected contract number is not on the list");
        }
    }
}
