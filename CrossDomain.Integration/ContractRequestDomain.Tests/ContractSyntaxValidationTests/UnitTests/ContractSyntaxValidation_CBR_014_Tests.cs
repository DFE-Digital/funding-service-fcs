namespace ContractRequestDomain.Tests.ContractSyntaxValidationTests.UnitTests
{
    extern alias RequestDomainDS;
    using System.Collections.Generic;
    using System.Linq;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using global::UnitTests.Common;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces;
    using SFA.FCT.ContractRequestDomain.BusinessLogic.Services;
    using SFA.FCT.ContractRequestDomain.Common;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore;
    using RequestDomainDS::SFA.FCT.ContractRequestDomain.DataStore.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload;
    using SFA.FCT.Framework.Logging;
    using SFA.FCT.Framework.Logging.Interfaces;

    [TestClass]
    public class ContractSyntaxValidation_CBR_014_Tests
    {
        private const string ErrorMsg = "Multiple contracts exist for the given UKPRN within the file";

        private const string ErrorMsgForEsf =
            "Multiple contracts with an intent of 'New' or 'New Amendment' exist for the given UKPRN within the file";

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_Enrich_ShouldFailContractsWithTheSameUkprn_WhereFundingTypeIsNotEsf()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
            IContractSyntaxValidation contractSyntaxValidation = GetContainer().Resolve<IContractSyntaxValidation>();

            // act
            contractSyntaxValidation.Enrich(spreadsheetData);

            // assert
            Assert.AreEqual(2, contractSyntaxValidation.Errors.Count, "the number of errors is not correct");
            Assert.IsTrue(contractSyntaxValidation.Errors.Select(e => e.Value).All(errorMsg => errorMsg == ErrorMsg), "the errorMsg is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_Enrich_ShouldFailContractsWithTheSameUkprn_WhereFundingTypeIsEsfAndOnlyOneNewIntent()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();
          
            IContractSyntaxValidation contractSyntaxValidation = GetContainer().Resolve<IContractSyntaxValidation>();
            sheetType controlSheetType = spreadsheetData.workbook[0]; 
            cellType fundingTypeCell = controlSheetType.row.First().cell.First();
            Assert.AreEqual("FundingTypeCode", fundingTypeCell.columnName, "The column we have chosen is incorrect");
            controlSheetType.row.First().cell.First().Value = "ESF";
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";


            // act
            contractSyntaxValidation.Enrich(spreadsheetData);

            // assert
            Assert.AreEqual(2, contractSyntaxValidation.Errors.Count, "the number of errors is not correct");
            Assert.IsTrue(contractSyntaxValidation.Errors.Select(e => e.Value).All(errorMsg => errorMsg == ErrorMsgForEsf), "the errorMsg is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_Enrich_ShouldFailContractsWithTheSameUkprnWhereFundingTypeIsEsfAndOnlyOneNewAmendmentIntent()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();

            IContractSyntaxValidation contractSyntaxValidation = GetContainer().Resolve<IContractSyntaxValidation>();
            sheetType controlSheetType = spreadsheetData.workbook[0];
            cellType fundingTypeCell = controlSheetType.row.First().cell.First();
            Assert.AreEqual("FundingTypeCode", fundingTypeCell.columnName, "The column we have chosen is incorrect");
            controlSheetType.row.First().cell.First().Value = "ESF";
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "New Amendment";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";

            // act
            contractSyntaxValidation.Enrich(spreadsheetData);

            // assert
            Assert.IsTrue(contractSyntaxValidation.Errors.Select(e => e.Value).All(errorMsg => errorMsg == ErrorMsgForEsf), "the errorMsg is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_Enrich_ShouldNotFailContractsWithTheSameUkprn_WhereFundingTypeIsEsfAndNoNewIntent()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();

            IContractSyntaxValidation contractSyntaxValidation = GetContainer().Resolve<IContractSyntaxValidation>();
            sheetType controlSheetType = spreadsheetData.workbook[0];
            cellType fundingTypeCell = controlSheetType.row.First().cell.First();
            Assert.AreEqual("FundingTypeCode", fundingTypeCell.columnName, "The column we have chosen is incorrect");
            controlSheetType.row.First().cell.First().Value = "ESF";
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";

            // act
            contractSyntaxValidation.Enrich(spreadsheetData);

            // assert
            Assert.AreEqual(0, contractSyntaxValidation.Errors.Count, "the number of errors is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_Enrich_ShouldFailContractsWithTheSameUkprn_WhereFundingTypeIsMainAndNoNewIntent()
        {
            // arrange
            dataLoadResults spreadsheetData = GetDataLoadResults();

            IContractSyntaxValidation contractSyntaxValidation = GetContainer().Resolve<IContractSyntaxValidation>();
            sheetType controlSheetType = spreadsheetData.workbook[0];
            cellType fundingTypeCell = controlSheetType.row.First().cell.First();
            Assert.AreEqual("FundingTypeCode", fundingTypeCell.columnName, "The column we have chosen is incorrect");
            sheetType contractSheetType = spreadsheetData.GetSheet("Contract");
            contractSheetType.row[0].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";
            contractSheetType.row[1].cell.Single(c => c.columnName == "CRMIntent").Value = "Amendment";

            // act
            contractSyntaxValidation.Enrich(spreadsheetData);

            // assert
            Assert.AreEqual(2, contractSyntaxValidation.Errors.Count, "the number of errors is not correct");
            Assert.IsTrue(contractSyntaxValidation.Errors.Select(e => e.Value).All(errorMsg => errorMsg == ErrorMsg), "the errorMsg is not correct");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractSyntaxValidation_Enrich_ShouldFailContractsWhereDeliveryOrgIsPresentAndAllowedButNotPopulatedCorrectly()
        {
            // arrange
            dataLoadResults spreadsheetData = GetSimpleDataLoadResults();
            Mock<IFundingTypeFundingPeriodRepository> repositoryMock = new Mock<IFundingTypeFundingPeriodRepository>();
            repositoryMock.Setup(
                r => r.IsFundingTypeFundingPeriodAllowedToHaveDeliveryOrg(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(true);

            ContractSyntaxValidation contractSyntaxValidation = new ContractSyntaxValidation(GetContainer().Resolve<IContractSyntaxBusinessRuleService>(), repositoryMock.Object);

            ContractBulkUpload file = new ContractBulkUpload(spreadsheetData);
            List<cellType> cellsForRow = file.ContractAllocationSheet.row[0].cell.ToList();
            cellsForRow.Add(new cellType
            {
                columnName = ContractBulkUpload.DeliveryOrganisation,
                Value = "V"
            });
            file.ContractAllocationSheet.row[0].cell = cellsForRow.ToArray();

            // act
            contractSyntaxValidation.Enrich(spreadsheetData);

            // assert
            Assert.AreEqual(1, contractSyntaxValidation.Errors.Count, "the number of errors is not correct");
            Assert.AreEqual(ErrorMessages.DeliveryOrgPresentThenAllMustBeSpecified, contractSyntaxValidation.Errors.First().Value, "The error message is not correct");
        }

        private static IWindsorContainer GetContainer()
        {
            IWindsorContainer container =
                new WindsorContainer().Install(
                    new SFA.FCT.ContractRequestDomain.Integration.BulkUpload.IoC.WindsorInstaller(new LoggerFactory()))
                   // .Register(Component.For<IContractRequestDbContext>().ImplementedBy<ContractRequestDbContext>().IsDefault())
                    .Register(Component.For<IFundingTypeFundingPeriodRepository>().Instance(Mock.Of<IFundingTypeFundingPeriodRepository>()).IsDefault())
                .Register(Component.For<IFundingAllocationReleaseRepository>().Instance(Mock.Of<IFundingAllocationReleaseRepository>()).IsDefault());
            container.BeginScope();

            return container;
        }

        private dataLoadResults GetDataLoadResults()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.MAIN AY 1516 04022016141822 v2_10017455.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }

        private dataLoadResults GetSimpleDataLoadResults()
        {
            using (TestResource resource = new TestResource("ContractRequestDomain.Tests", @"Resources.24+LOANS AY 1516 17022115090000 Demo.xlsx"))
            {
                return new ExcelFileParser().ReadFile(resource.Stream, "TestFile.xlsx");
            }
        }
    }
}
