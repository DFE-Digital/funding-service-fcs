namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class ContractManagementFundingTypeFundingPeriodContractTypeWriterTests
    {
        private const string FundingTypeCode = "FTYPE_CODE";
        private const string FundingPeriodCode = "FPERIOD_CODE";
        private const string ContractType = "CONTRACTTYPE_CODE";

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementFundingTypeFundingPeriodContractTypeWriter_NewContractManagementFundingTypeFundingPeriodContractType()
        {
            // Arrange
            const string definedContractTermForProvider = "Contractor";
            RemoveFundingTypeFundingPeriodContractType(FundingTypeCode, FundingPeriodCode, ContractType);

            FTPCoTSheetType ftpCoTSheetTypeEntry = new FTPCoTSheetType
            {
                FundingTypeCode = FundingTypeCode,
                FundingPeriodCode = FundingPeriodCode,
                ContractType = ContractType,
                PolicyStatus = PolicyStatus.Approved,
                DefinedContractTermForProvider = definedContractTermForProvider
            };

            List<FTPCoTSheetType> ftpCoTSheetTypeEntries = new List<FTPCoTSheetType>
            {
                ftpCoTSheetTypeEntry
            };

            // Act
            ContractManagementFundingTypeFundingPeriodContractTypeWriter.WriteToPaaSDatabase(ftpCoTSheetTypeEntries,
                WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriodContractType testedFtfpct =
                    context.FundingTypeFundingPeriodContractTypes.SingleOrDefault(d =>
                            d.FundingTypeCode == FundingTypeCode
                         && d.FundingPeriodCode == FundingPeriodCode
                         && d.ContractType == ContractType
                         && d.DefinedContractTermForProvider == definedContractTermForProvider);

                Assert.IsNotNull(testedFtfpct);
                Assert.AreEqual(ContractType, testedFtfpct.ContractType, "Incorrect ContractType");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ContractManagementFundingTypeFundingPeriodContractTypeWriter_UpdateContractManagementFundingTypeFundingPeriodContractType()
        {
            // Arrange
            const string definedContractTermForProvider = "Contractor";
            RemoveFundingTypeFundingPeriodContractType(FundingTypeCode, FundingPeriodCode, ContractType + "_before");
            RemoveFundingTypeFundingPeriodContractType(FundingTypeCode, FundingPeriodCode, ContractType + "_after");

            FundingTypeFundingPeriodContractType ftfpctBefore = new FundingTypeFundingPeriodContractType
            (
                FundingTypeCode,
                FundingPeriodCode,
                ContractType + "_before",
                definedContractTermForProvider + "_before"
            );

            using (var context = new ContractManagementDbContext())
            {
                context.FundingTypeFundingPeriodContractTypes.Add(ftfpctBefore);
                context.SaveChanges();
            }

            FTPCoTSheetType ftpCoTSheetTypeEntry = new FTPCoTSheetType
            {
                FundingTypeCode = FundingTypeCode,
                FundingPeriodCode = FundingPeriodCode,
                ContractType = ContractType + "_after",
                PolicyStatus = PolicyStatus.Approved,
                DefinedContractTermForProvider = definedContractTermForProvider + "_after"
            };

            List<FTPCoTSheetType> ftpCoTSheetTypeEntries = new List<FTPCoTSheetType>
            {
                ftpCoTSheetTypeEntry
            };

            // Act
            ContractManagementFundingTypeFundingPeriodContractTypeWriter.WriteToPaaSDatabase(ftpCoTSheetTypeEntries, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriodContractType testedFtfpctAfter =
                    context.FundingTypeFundingPeriodContractTypes.SingleOrDefault(d =>
                        d.FundingTypeCode == FundingTypeCode
                        && d.FundingPeriodCode == FundingPeriodCode
                        && d.ContractType == ContractType + "_after"
                        && d.DefinedContractTermForProvider == definedContractTermForProvider + "_after");

                Assert.IsNotNull(testedFtfpctAfter, "ContractType was not updated");

                FundingTypeFundingPeriodContractType testedFtfpctBefore =
                    context.FundingTypeFundingPeriodContractTypes.SingleOrDefault(d =>
                        d.FundingTypeCode == FundingTypeCode
                        && d.FundingPeriodCode == FundingPeriodCode
                        && d.ContractType == ContractType + "_before"
                        && d.DefinedContractTermForProvider == definedContractTermForProvider + "_before");

                Assert.IsNull(testedFtfpctBefore, "The before ContractType was not replaced");
            }

            RemoveFundingTypeFundingPeriodContractType(FundingTypeCode, FundingPeriodCode, ContractType + "_after");
        }

        private static void RemoveFundingTypeFundingPeriodContractType(string fundingTypeCode, string fundingPeriodCode, string contractType)
        {
            using (var context = new ContractManagementDbContext())
            {
                FundingTypeFundingPeriodContractType ftfpct = context.FundingTypeFundingPeriodContractTypes.SingleOrDefault(
                    d => d.FundingTypeCode == fundingTypeCode
                         && d.FundingPeriodCode == fundingPeriodCode
                         && d.ContractType == contractType);

                if (ftfpct != null)
                {
                    context.FundingTypeFundingPeriodContractTypes.Remove(ftfpct);
                    context.SaveChanges();
                }
            }
        }
    }
}