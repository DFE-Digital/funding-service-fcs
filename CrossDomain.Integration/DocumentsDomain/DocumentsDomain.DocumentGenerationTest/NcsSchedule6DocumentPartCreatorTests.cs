namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.IO;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.CorporateContract;
    using CrossDomain.Integration.Messages.Commands;
    using DocumentDefiner.DocumentPartCreators;
    using Integration;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using UnitTests.Common;

    [TestClass]
    public class NcsSchedule6DocumentPartCreatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule6DocumentPartCreator_ShouldRequireDocumentPartWhenFundingPeriodIsNCS1819()
        {
            // arrange
            NcsSchedule6DocumentPartCreator documentPartCreator = new NcsSchedule6DocumentPartCreator(null, null, null);
            DocumentGenerationCommand documentGenerationCommand = GetNcsNcs1819DocumentGenerationCommand();

            // act
            bool isDocumentRequired = documentPartCreator.IsDocumentPartRequired(documentGenerationCommand.CorporateContract);

            // assert
            Assert.AreEqual(true, isDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule6DocumentPartCreator_ShouldNotRequireDocumentPartWhenFundingPeriodIsNotNCS1819()
        {
            // arrange
            NcsSchedule6DocumentPartCreator documentPartCreator = new NcsSchedule6DocumentPartCreator(null, null, null);
            DocumentGenerationCommand documentGenerationCommand = GetNcsFy1718DocumentGenerationCommand();

            // act
            bool isDocumentRequired = documentPartCreator.IsDocumentPartRequired(documentGenerationCommand.CorporateContract);

            // assert
            Assert.AreEqual(false, isDocumentRequired);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NcsSchedule6DocumentPartCreator_SupplyDocumentGenerationRequest_ShouldReturnExpectedMergeFields()
        {
            // arrange
            Mock<IFundingTypeFundingPeriodQueryRepository> fundingTypeFundingPeriodQueryRepositoryMock = new Mock<IFundingTypeFundingPeriodQueryRepository>();
            fundingTypeFundingPeriodQueryRepositoryMock.Setup(m => m.Get(It.IsAny<string>(), It.IsAny<string>())).Returns(new FundingTypeFundingPeriod());

            NcsSchedule6DocumentPartCreator documentPartCreator = new NcsSchedule6DocumentPartCreator(
                Mock.Of<ITemplateRepository>(),
                null,
                fundingTypeFundingPeriodQueryRepositoryMock.Object);

            contractType contract = GetNcsNcs1819DocumentGenerationCommand().CorporateContract;

            // act
            var documentGenerationRequest = documentPartCreator.SupplyDocumentGenerationRequest("TEST-1234", contract, string.Empty);

            // assert
            Assert.AreEqual("44045.0", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "ContractTotal").Value, "Incorrect ContractTotal for FSP 'NCS-C1819'");
            Assert.AreEqual("911", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSCDel6Volume").Value, "Incorrect volume for FSP 'NCS-C1819' DeliverableCode 6 'Customers Accessing Service'");

            Assert.AreEqual("NACRO", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "PROVIDERNAME").Value, "Incorrect PROVIDERNAME");
             
            Assert.AreEqual("32500.0", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSVDel1Jan19Value").Value, "Incorrect Total Cost for 'February 2019' payment date");
            Assert.AreEqual("32500.0", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSVDel1Feb19Value").Value, "Incorrect Total Cost for 'March 2019' payment date");
            Assert.AreEqual("35000.0", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSVDel1Mar19Value").Value, "Incorrect Total Cost for 'April 2019' payment date");
            Assert.AreEqual("100000.0", documentGenerationRequest["1000"].MergeData.MergeFields.Single(mf => mf.Name == "NCSVDel1TotalValue").Value, "Incorrect 'Total Payable 1 January 2019 – 30 April 2019'");
        }

        private static DocumentGenerationCommand GetNcsNcs1819DocumentGenerationCommand()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.DocumentGenerationCommandNCS_NCS1819.json"))
            {
                return
                    (DocumentGenerationCommand)
                        new Newtonsoft.Json.JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(DocumentGenerationCommand));
            }
        }

        private static DocumentGenerationCommand GetNcsFy1718DocumentGenerationCommand()
        {
            using (var resource = new TestResource("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", @"Resources.DocumentGenerationCommandNCS_FY1718.json"))
            {
                return
                    (DocumentGenerationCommand)
                    new Newtonsoft.Json.JsonSerializer().Deserialize(new StreamReader(resource.Stream), typeof(DocumentGenerationCommand));
            }
        }
    }
}
