namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class DocumentsFundingStreamPeriodWriterTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsFundingStreamPeriodWriter_ShouldWriteNewRowsToDatabase()
        {
            // arrange
            IEnumerable<string> fundingStreamPeriodCodesToTest = new List<string> { "FSP1", "FSP2"};
            RemoveFsps(fundingStreamPeriodCodesToTest);

            // act
            DocumentsDomainFundingStreamPeriodWriter.WriteToPaaSDatabase(GetFundingStreamPeriodSheetType(fundingStreamPeriodCodesToTest), WriterBehaviour.AddOrUpdate);
            
            // assert
            List<FundingStreamPeriod> fundingStreamPeriods;
            using (var context = new DocumentsDomainDbContext())
            {
                fundingStreamPeriods =
                    context.FundingStreamPeriods.Where(fsp => fundingStreamPeriodCodesToTest.Contains(fsp.FundingStreamPeriodCode))
                        .ToList();
            }

            FundingStreamPeriod fsp2 = fundingStreamPeriods.Single(fsp => fsp.FundingStreamPeriodCode == "FSP2");
            Assert.AreEqual(2, fundingStreamPeriods.Count, "The number of fundingStreamPeriods is incorrect");
            Assert.AreEqual(2, fsp2.DisplayOrder, "The DisplayOrder is incorrect");
            Assert.AreEqual("Test2", fsp2.SummaryOfFundingDisplayName, "The DisplayName is incorrect");

            Assert.IsTrue(fsp2.ShouldGenerateFundingAgreement, "The ShouldGenerateFundingAgreement should be true");
            Assert.IsTrue(fsp2.ShouldUseContractAllocationDescription, "The ShouldUseContractAllocationDescription should be true");
            Assert.AreEqual("Template2", fsp2.Template, "The Template is incorrect");
            Assert.AreEqual("ExtraPagesTemplate2", fsp2.ExtraPagesTemplate, "The ExtraPagesTemplate is incorrect");
            Assert.AreEqual("Funding Agreement Display Name FSP2", fsp2.FundingAgreementDisplayName, "The FundingAgreementDisplayName is incorrect");

            RemoveFsps(fundingStreamPeriodCodesToTest);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsFundingStreamPeriodWriter_ShouldUpdateRowsInDatabase()
        {
            // arrange
            const string fundingStreamPeriodCodeToUpdate = "FSP2";
            const string fspGroup = "FSP G Test";
            IEnumerable<string> fundingStreamPeriodCodesToTest = new List<string> { "FSP1", fundingStreamPeriodCodeToUpdate };
            UpsertFspGroup(fspGroup);
            RemoveFsps(fundingStreamPeriodCodesToTest);

            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodSheetTypes = GetFundingStreamPeriodSheetType(fundingStreamPeriodCodesToTest);
            DocumentsDomainFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingStreamPeriodSheetTypes, WriterBehaviour.AddOrUpdate);

            const int displayOrderToUpdateTo = 11;
            const string displayNameToUpdateTo = "TEST_UPDATED";
            const string templateToUpdateTo = "Template_UPDATED";
            const string extraPagesTemplateToUpdateTo = "ExtraPagesTemplate_UPDATED";
            const string fundingAgreementDisplayNameToUpdateTo = "FundingAgreementDisplayName_UPDATED";

            FundingStreamPeriodSheetType fundingStreamPeriodToUpdate = fundingStreamPeriodSheetTypes.Single(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCodeToUpdate);
            fundingStreamPeriodToUpdate.ContractDocumentDisplayOrder = displayOrderToUpdateTo;
            fundingStreamPeriodToUpdate.SummaryOfFundingDisplayName = displayNameToUpdateTo;

            fundingStreamPeriodToUpdate.ShouldGenerateFundingAgreement = false;
            fundingStreamPeriodToUpdate.ShouldUseContractAllocationDescription = false;
            fundingStreamPeriodToUpdate.Template = templateToUpdateTo;
            fundingStreamPeriodToUpdate.ExtraPagesTemplate = extraPagesTemplateToUpdateTo;
            fundingStreamPeriodToUpdate.FSPGroup = fspGroup;
            fundingStreamPeriodToUpdate.FundingAgreementDisplayName = fundingAgreementDisplayNameToUpdateTo;

            // act
            DocumentsDomainFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingStreamPeriodSheetTypes, WriterBehaviour.AddOrUpdate);

            // assert
            List<FundingStreamPeriod> fundingStreamPeriods;
            using (var context = new DocumentsDomainDbContext())
            {
                fundingStreamPeriods =
                    context.FundingStreamPeriods.Where(fsp => fundingStreamPeriodCodesToTest.Contains(fsp.FundingStreamPeriodCode))
                        .ToList();
            }

            FundingStreamPeriod fsp2 = fundingStreamPeriods.Single(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCodeToUpdate);
            Assert.AreEqual(2, fundingStreamPeriods.Count, "The number of fundingStreamPeriods is incorrect");
            Assert.AreEqual(displayOrderToUpdateTo, fsp2.DisplayOrder, "The DisplayOrder is incorrect");
            Assert.AreEqual(displayNameToUpdateTo, fsp2.SummaryOfFundingDisplayName, "The DisplayName is incorrect");
            Assert.IsFalse(fsp2.ShouldGenerateFundingAgreement, "The ShouldGenerateFundingAgreement should be false");
            Assert.IsFalse(fsp2.ShouldUseContractAllocationDescription, "The ShouldUseContractAllocationDescription should be false");
            Assert.AreEqual(templateToUpdateTo, fsp2.Template, "The Template is incorrect");
            Assert.AreEqual(extraPagesTemplateToUpdateTo, fsp2.ExtraPagesTemplate, "The ExtraPagesTemplate is incorrect");
            Assert.AreEqual(fspGroup, fsp2.FSPGroupCode, "The FSPGroupCode is incorrect");
            Assert.AreEqual(fundingAgreementDisplayNameToUpdateTo, fsp2.FundingAgreementDisplayName, "The FundingAgreementDisplayName is incorrect");

            RemoveFsps(fundingStreamPeriodCodesToTest);
            ClearDownFspGroupCode(fspGroup);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsFundingStreamPeriodWriter_ShouldDeleteExpectedRowsInDatabase()
        {
            // arrange
            const string fundingStreamPeriodCodeToRetain = "FSP1";
            const string fundingStreamPeriodCodeToDelete = "FSP2";
            IEnumerable<string> fundingStreamPeriodCodesToTest = new List<string> { fundingStreamPeriodCodeToRetain, fundingStreamPeriodCodeToDelete };

            RemoveFsps(fundingStreamPeriodCodesToTest);

            IReadOnlyCollection<FundingStreamPeriodSheetType> fundingStreamPeriodSheetTypes = GetFundingStreamPeriodSheetType(fundingStreamPeriodCodesToTest);
            DocumentsDomainFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingStreamPeriodSheetTypes, WriterBehaviour.AddOrUpdate);

            FundingStreamPeriodSheetType fundingStreamPeriodToUpdate = fundingStreamPeriodSheetTypes.Single(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCodeToDelete);
            fundingStreamPeriodToUpdate.PolicyStatus = PolicyStatus.Removed;

            // act
            DocumentsDomainFundingStreamPeriodWriter.WriteToPaaSDatabase(fundingStreamPeriodSheetTypes, WriterBehaviour.Delete);

            // assert
            List<FundingStreamPeriod> fundingStreamPeriods;
            using (var context = new DocumentsDomainDbContext())
            {
                fundingStreamPeriods =
                    context.FundingStreamPeriods.Where(fsp => fundingStreamPeriodCodesToTest.Contains(fsp.FundingStreamPeriodCode))
                        .ToList();
            }

            FundingStreamPeriod fsp1 = fundingStreamPeriods.SingleOrDefault(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCodeToRetain);
            Assert.IsNotNull(fsp1, "Unexpected FSP has been deleted");

            FundingStreamPeriod fsp2 = fundingStreamPeriods.SingleOrDefault(fsp => fsp.FundingStreamPeriodCode == fundingStreamPeriodCodeToDelete);
            Assert.IsNull(fsp2, "Expected FSP has not been deleted");

            RemoveFsps(fundingStreamPeriodCodesToTest);
        }

        private static void UpsertFspGroup(string fspGTest)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                if (!context.FSPGroups.Any(g => g.FSPGroupCode == fspGTest))
                {
                    context.FSPGroups.Add(new FSPGroup(fspGTest, "some val", 1));
                    context.SaveChanges();
                }
            }
        }

        private void RemoveFsps(IEnumerable<string> fundingStreamPeriodCodesToTest)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Where(fsp => fundingStreamPeriodCodesToTest.Contains(fsp.FundingStreamPeriodCode))
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        private void ClearDownFspGroupCode(string fspGroupCode)
        {
            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPGroups.Where(fspg => fspg.FSPGroupCode == fspGroupCode).ToList()
                    .ForEach(fspg => context.FSPGroups.Remove(fspg));

                context.SaveChanges();
            }
        }

        private IReadOnlyCollection<FundingStreamPeriodSheetType> GetFundingStreamPeriodSheetType(IEnumerable<string> fundingStreamPeriodCodesToTest)
        {
            List<FundingStreamPeriodSheetType> fundingStreamPeriodSheetTypes = new List<FundingStreamPeriodSheetType>();
            int displayOrder = 1;
            fundingStreamPeriodCodesToTest.ForEach(fspCode =>
            {
                fundingStreamPeriodSheetTypes.Add(new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = fspCode,
                    ContractDocumentDisplayOrder = displayOrder,
                    SummaryOfFundingDisplayName = "Test" + displayOrder,
                    ShouldGenerateFundingAgreement = true,
                    ShouldUseContractAllocationDescription = true,
                    Template = "Template" + displayOrder,
                    ExtraPagesTemplate = "ExtraPagesTemplate" + displayOrder,
                    FundingAgreementDisplayName = "Funding Agreement Display Name " + fspCode
                });
                displayOrder++;
            });
           
            return fundingStreamPeriodSheetTypes;
        }
    }
}
