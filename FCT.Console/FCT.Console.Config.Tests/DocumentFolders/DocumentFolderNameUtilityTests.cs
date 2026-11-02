namespace FCT.Console.Config.Tests.DocumentFolders
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Config.DocumentFolders;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class DocumentFolderNameUtilityTests
    {
        private const string TestFundingTypeCode = "TESTFOLDERCREATE";
        private readonly ContractManagementDbContext _context = new ContractManagementDbContext();

        [TestInitialize]
        public void Setup()
        {
            Cleanup();
        }

        [TestCleanup]
        public void Cleanup()
        {
            var ftfpsToRemove =
                _context.FundingTypeFundingPeriodItems.Where(ftfp => ftfp.FundingTypeCode.StartsWith(TestFundingTypeCode));

            ftfpsToRemove.ForEach(ftfp => _context.FundingTypeFundingPeriodItems.Remove(ftfp));

            _context.SaveChanges();
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetAllFolderNamesIfDocsReqdNoSkipDocMerge()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {
                    SkipDocumentMerge = false,
                    DocumentsRequired = true,
                    FundingTypeCode = TestFundingTypeCode,
                    FundingPeriodName = "AY1617"
                },
                new FundingTypeFundingPeriod
                {
                    SkipDocumentMerge = false,
                    DocumentsRequired = true,
                    FundingTypeCode = TestFundingTypeCode + "2",
                    FundingPeriodName = "FY1516"
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            List<string> expectedNames = new List<string>
            {
                TestFundingTypeCode + "-1617-Input-Appendices",
                TestFundingTypeCode + "-1617-Input-Terms And Conditions",
                TestFundingTypeCode + "-1617-Output-Documents for Publication",
                TestFundingTypeCode + "-1617-Output-Merged Document",
                TestFundingTypeCode + "2-1516-Input-Appendices",
                TestFundingTypeCode + "2-1516-Input-Terms And Conditions",
                TestFundingTypeCode + "2-1516-Output-Documents for Publication",
                TestFundingTypeCode + "2-1516-Output-Merged Document"
            };

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(false).Where(f => f.StartsWith(TestFundingTypeCode)).ToList();

            // assert
            Assert.AreEqual(8, folderNames.Count, "Incorrect number of folder names was returned");
            expectedNames.ForEach(en => Assert.IsTrue(folderNames.Contains(en), $"Actual result is missing {en} folder name"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetNoFolderNamesIfNotDocsReqd()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {
                    DocumentsRequired = false,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode,
                    FundingPeriodName = "AY1617"
                },
                new FundingTypeFundingPeriod
                {
                    DocumentsRequired = false,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "2",
                    FundingPeriodName = "FY1516"
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(false).Where(f => f.StartsWith(TestFundingTypeCode));

            // assert
            Assert.IsFalse(folderNames.Any());
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetOnlyRelevantFolderNamesIfDocsReqdAndSkipDocMerge()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {
                    SkipDocumentMerge = true,
                    DocumentsRequired = true,
                    FundingTypeCode = TestFundingTypeCode,
                    FundingPeriodName = "AY1617"
                },
                new FundingTypeFundingPeriod
                {
                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "2",
                    FundingPeriodName = "FY1516"
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            List<string> expectedNames = new List<string>
            {
                TestFundingTypeCode + "-1617-Input-Appendices",
                TestFundingTypeCode + "-1617-Output-Documents for Publication",
                TestFundingTypeCode + "2-1516-Input-Appendices",
                TestFundingTypeCode + "2-1516-Input-Terms And Conditions",
                TestFundingTypeCode + "2-1516-Output-Documents for Publication",
                TestFundingTypeCode + "2-1516-Output-Merged Document"
            };

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(false).Where(f => f.StartsWith(TestFundingTypeCode)).ToList();

            // assert
            Assert.AreEqual(6, folderNames.Count, "Incorrect number of folder names was returned");
            expectedNames.ForEach(en => Assert.IsTrue(folderNames.Contains(en), $"Actual result is missing {en} folder name"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetNoFolderNamesIfPolicyStatusIsAprovedAndActivityCloseDateIsInThePast()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {
                    
                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "2",
                    FundingPeriodName = "FY1516",
                    ContractingActivityCloseDate = new DateTime(1999, 1, 1) // definitely in the past
                },
                new FundingTypeFundingPeriod
                {
                    
                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "3",
                    FundingPeriodName = "CY1718"
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            var expected = new List<string>
            {
                TestFundingTypeCode + "3-1718-Input-Appendices",
                TestFundingTypeCode + "3-1718-Input-Terms And Conditions",
                TestFundingTypeCode + "3-1718-Output-Documents for Publication",
                TestFundingTypeCode + "3-1718-Output-Merged Document"
            };

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(false).Where(f => f.StartsWith(TestFundingTypeCode)).ToList();

            // assert
            Assert.AreEqual(4, folderNames.Count);
            expected.ForEach(en => Assert.IsTrue(folderNames.Contains(en), $"Actual result is missing {en} folder name"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetFolderNamesIfPolicyStatusIsAprovedAndActivityCloseDateIsToday()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {
                    
                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "3",
                    FundingPeriodName = "CY1718",
                    ContractingActivityCloseDate = DateTime.UtcNow
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            var expected = new List<string>
            {
                TestFundingTypeCode + "3-1718-Input-Appendices",
                TestFundingTypeCode + "3-1718-Input-Terms And Conditions",
                TestFundingTypeCode + "3-1718-Output-Documents for Publication",
                TestFundingTypeCode + "3-1718-Output-Merged Document"
            };

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(false).Where(f => f.StartsWith(TestFundingTypeCode)).ToList();

            // assert
            Assert.AreEqual(4, folderNames.Count);
            expected.ForEach(en => Assert.IsTrue(folderNames.Contains(en), $"Actual result is missing {en} folder name"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetFolderNamesIfPolicyStatusIsAprovedAndActivityCloseDateIsInTheFuture()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {
                    
                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "3",
                    FundingPeriodName = "CY1718",
                    ContractingActivityCloseDate = new DateTime(2099, 1, 3)
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            var expected = new List<string>
            {
                TestFundingTypeCode + "3-1718-Input-Appendices",
                TestFundingTypeCode + "3-1718-Input-Terms And Conditions",
                TestFundingTypeCode + "3-1718-Output-Documents for Publication",
                TestFundingTypeCode + "3-1718-Output-Merged Document"
            };

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(false).Where(f => f.StartsWith(TestFundingTypeCode)).ToList();

            // assert
            Assert.AreEqual(4, folderNames.Count);
            expected.ForEach(en => Assert.IsTrue(folderNames.Contains(en), $"Actual result is missing {en} folder name"));
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentFolderNameUtility_GetFolderNames_ShouldGetFolderNamesIfPolicyStatusIsAprovedAndActivityCloseDateIsInThePastAndShouldCreateFolderNamesPastActivityClose()
        {
            // arrange
            var ftps = new List<FundingTypeFundingPeriod>
            {
                new FundingTypeFundingPeriod
                {

                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "2",
                    FundingPeriodName = "FY1516",
                    ContractingActivityCloseDate = new DateTime(1999, 1, 1) // definitely in the past
                },
                new FundingTypeFundingPeriod
                {

                    DocumentsRequired = true,
                    SkipDocumentMerge = false,
                    FundingTypeCode = TestFundingTypeCode + "3",
                    FundingPeriodName = "CY1718"
                }
            };

            ftps.ForEach(ftp => _context.FundingTypeFundingPeriodItems.Add(ftp));
            _context.SaveChanges();

            var expected = new List<string>
            {
                TestFundingTypeCode + "2-1516-Input-Appendices",
                TestFundingTypeCode + "2-1516-Input-Terms And Conditions",
                TestFundingTypeCode + "2-1516-Output-Documents for Publication",
                TestFundingTypeCode + "2-1516-Output-Merged Document",
                TestFundingTypeCode + "3-1718-Input-Appendices",
                TestFundingTypeCode + "3-1718-Input-Terms And Conditions",
                TestFundingTypeCode + "3-1718-Output-Documents for Publication",
                TestFundingTypeCode + "3-1718-Output-Merged Document"
            };

            // act
            var folderNames = DocumentFolderNameUtility.GetFolderNames(true).Where(f => f.StartsWith(TestFundingTypeCode)).ToList();

            // assert
            Assert.AreEqual(expected.Count, folderNames.Count);
            expected.ForEach(en => Assert.IsTrue(folderNames.Contains(en), $"Actual result is missing {en} folder name"));
        }
    }
}