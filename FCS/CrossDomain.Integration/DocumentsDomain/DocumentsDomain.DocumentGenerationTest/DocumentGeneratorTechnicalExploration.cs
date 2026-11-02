namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Text;
    using Aspose.Words;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Commands;
    using Common.Models;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Models;
    using DocumentCreator;
    using DocumentDefiner;
    using DocumentLocationResolver;
    using DocumentMerger;
    using Framework.Logging;
    using iTextSharp.text.pdf;
    using iTextSharp.text.pdf.parser;
    using Integration;
    using IoC;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;
    using FundingTypeFundingPeriod = ContractManagement.DataStore.Model.FundingTypeFundingPeriod;

    [TestClass]
    public class DocumentGeneratorTechnicalExploration
    {
        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA497()
        {
            // arrange

            //We need to setup the IoC so that the Doc Part Creators get created

            SetupIoc();

            DocumentGenerator generator = GetDocumentGenerator();

            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile("DocumentGenerationCommand_ESF.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            // assert
            string[] actualLines = GetLinesFromPdfFile(documentSaveCommand.FCTDocumentDatabus);
            actualLines = actualLines.Where(l => !l.StartsWith("Date")).ToArray();
            
            string[] expectedLines = GetLinesFromFile("DAT_A497_ExpectedFileLines.txt");
            Assert.AreEqual(expectedLines.Length, actualLines.Length, "The number of lines differs");
            var firstFailureRow = expectedLines.Select((expectedLine, i) =>
                    new { Expected = expectedLine.Clean(), Index = i, Actual = actualLines[i].Clean() })
                .FirstOrDefault(r => r.Actual != r.Expected);

            Assert.IsNull(firstFailureRow, $"This line is not present - expected:{firstFailureRow?.Expected}, actual:{firstFailureRow?.Actual}, rowNumber: {firstFailureRow?.Index}");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA256()
        {
            // arrange

            //We need to setup the IoC so that the Doc Part Creators get created

            SetupIoc();

            DocumentGenerator generator = GetDocumentGenerator();

            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile("DocGenerationCommand_A256.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);
            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//A256.pdf", documentSaveCommand.FCTDocumentDatabus);
            // assert
            string[] actualLines = GetLinesFromPdfFile(documentSaveCommand.FCTDocumentDatabus);
            actualLines = actualLines.Where(l => !l.StartsWith("Date")).ToArray();
            string[] expectedLines = GetLinesFromFile("DAT_A256_ExpectedLines.txt");

            var firstFailureRow = expectedLines.Select((expectedLine, i) =>
                    new { Expected = expectedLine.Clean(), Index = i, Actual = actualLines[i].Clean() })
                .FirstOrDefault(r => r.Actual != r.Expected);

            Assert.IsNull(firstFailureRow, $"This line is not present - expected:{firstFailureRow?.Expected}, actual:{firstFailureRow?.Actual}, rowNumber: {firstFailureRow?.Index}");
            // string.Join(System.Environment.NewLine, actualLines)
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA257()
        {
            // arrange
            
            //We need to setup the IoC so that the Doc Part Creators get created
            
            SetupIoc();

            DocumentGenerator generator = GetDocumentGenerator();

            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile("DocGenCommand_A257json.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            // assert
            string[] actualLines = GetLinesFromPdfFile(documentSaveCommand.FCTDocumentDatabus);
            actualLines = actualLines.Where(l => !l.StartsWith("Date")).ToArray();
          
            string[] expectedLines = GetLinesFromFile("DAT_A257_ExpectedLines.txt");
            //Assert.Fail(string.Join(System.Environment.NewLine, actualLines));
            Assert.AreEqual(expectedLines.Length, actualLines.Length, "The number of lines is wrong");           
            var firstFailureRow = expectedLines.Select((expectedLine, i) =>
                    new {Expected = expectedLine.Clean(), Index = i, Actual = actualLines[i].Clean()})
                .FirstOrDefault(r => r.Actual != r.Expected);

            Assert.IsNull(firstFailureRow, $"This line is not present - expected:{firstFailureRow?.Expected}, actual:{firstFailureRow?.Actual}, rowNumber: {firstFailureRow?.Index}");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA322_ContractHasOneAllocationForTheContractingOrgAndNoDeliveryOrgIsNotSpecifiedInBulkUploadFile()
        {
            GenerateDocumentAndAssertExpectedLines("A322");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA877_ContractHasOneDeliveryOrgWhichMatchesTheContractingOrgAndDeliveryOrgIsSpecifiedInBulkUploadFile()
        {
            GenerateDocumentAndAssertExpectedLines("A877");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA878_ContractHasFourDeliveryOrgsNoneOfWhichMatchTheContractingOrg()
        {
            GenerateDocumentAndAssertExpectedLines("A878");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA879_ContractHasFiveDeliveryOrgsOneOfWhichMatchesTheContractingOrg()
        {
            GenerateDocumentAndAssertExpectedLines("A879");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA929_ContractForAllfWithFourDeliveryOrgsOneOfWhichIsTheContractingOrg()
        {
            GenerateDocumentAndAssertExpectedLines("A929");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA125NotAmendment()
        {
            GenerateDocumentAndAssertExpectedLines("A125NotAmendment");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA125Amendment()
        {
            GenerateDocumentAndAssertExpectedLines("A125Amendment");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA295()
        {
            GenerateDocumentAndAssertExpectedLines("A295");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA252()
        {
            GenerateDocumentAndAssertExpectedLines("A252");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA541()
        {
            GenerateDocumentAndAssertExpectedLines("A541");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA304()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("A304");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA642()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("A642");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA741()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("A741");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA111()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("A111");
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA511()
        {
            GenerateDocumentAndAssertExpectedLines("A511", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforA030()
        {
            // arrange
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.RemoveWhere(c => c.Ukprn == 10017030);
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(
                    10017030, "AEB-AS2021", 800.00m, 400.00m));
                context.SaveChanges();
            }

            // act
            GenerateDocumentAndAssertExpectedLines("A030", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA031()
        {
            // arrange
            using (var context = new DocumentsDomainDbContext())
            {
                context.ContractReferenceConfigs.RemoveWhere(c => c.Ukprn == 10017031);
                context.ContractReferenceConfigs.RemoveWhere(c => c.Ukprn == 10032931);
                context.ContractReferenceConfigs.RemoveWhere(c => c.Ukprn == 10034058);
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(10017031, "AEBC-ASCL2021", 500.00m, 400.00m));
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(10032931, "AEBC-ASCL2021", 600.00m, 500.00m));
                context.ContractReferenceConfigs.Add(new ContractReferenceConfig(10034058, "AEBC-ASCL2021", 700.00m, 600.00m));
                context.SaveChanges();
            }

            // act
            GenerateDocumentAndAssertExpectedLines("A031", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA821()
        {
            GenerateDocumentAndAssertExpectedLines("A821", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA887()
        {
            GenerateDocumentAndAssertExpectedLines("A887", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA058()
        {
            GenerateDocumentAndAssertExpectedLines("A058", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA059()
        {
            GenerateDocumentAndAssertExpectedLines("A059", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA084()
        {
            GenerateDocumentAndAssertExpectedLines("A084", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA704()
        {
            GenerateDocumentAndAssertExpectedLines("A704", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkForA731()
        {
            GenerateDocumentAndAssertExpectedLines("A731", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforLevy()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("LEVY1799", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforNCS2021()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("NCS2021", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforNCS2022()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("NCS2022", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_ShouldWorkforHTES2223()
        {
            // there is no 'lines' file for this at the moment as the acceptance test is not complete
            GenerateDocumentAndAssertExpectedLines("HTES2223", false);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_CreateEdskSummaryOfFundingWithManyDeliveryOrgs()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_EDSK_ManyDeliveryOrgs.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//EDSK_ManyDeliveryOrgs.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_ShouldGenerateDaveEdskDocumentsForStory26431()
        {
            string[] resources =
            {
                "DocGenCommand_DaveTrustTest_ESFA-97722"
            };
            resources.ToList().ForEach(resource =>
            {
                SetupIoc();
                DocumentGenerator generator = GetDocumentGenerator();

                DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"{resource}.json");
                DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);
                File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//{resource}.pdf", documentSaveCommand.FCTDocumentDatabus);
            });
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_ShouldGenerateDaveEdskDocumentsForStory25952()
        {
            string[] resources =
            {
                "DaveNewTest_80044729",
                "DaveNewTest_80008935",
                "DaveNewTest_80004285",
                "DaveNewTest_80019914",
                "DaveTrustTest_80066107",
                "DaveTrustTest_80066120"
            };

            resources.ToList().ForEach(resource =>
            {
                SetupIoc();
                DocumentGenerator generator = GetDocumentGenerator();

                DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_{resource}.json");
                DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);
                File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//{resource}.pdf", documentSaveCommand.FCTDocumentDatabus);
            });
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_ShouldGenerateDadaDocumentsForStory28889()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile("DocGenCommand_DADA.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);
            
            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//DADA.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        [TestMethod, TestCategory("DocGenIntegration")]
        public void DocumentGenerator_CreateNlaAppendix1For28766()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile("DocGenCommand_NLAP_28766.json");
            int ukprn = documentGenerationCommand.CorporateContract.contractor.ukprn;

            // act for original template
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.RemoveWhere(n => n.Ukprn == ukprn);
                context.SaveChanges();
            }

            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);
            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//NLAP_28766_original.pdf", documentSaveCommand.FCTDocumentDatabus);

            // act for new template
            using (DocumentsDomainDbContext context = new DocumentsDomainDbContext())
            {
                context.NlapFundingConfigs.Add(new NlapFundingConfig(ukprn, 1000, 2000, 3000, 4000));
                context.SaveChanges();
            }

            documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);
            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//NLAP_28766_new.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_AEB2021ProcurementContractsFor2122ForStory33807()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_AEB2021ForStory33807.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//AEB2021ForStory33807.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_AEB2023ProcurementContractsFor2324ForStory38490()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_AEB2023.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//AEB2023.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_GenerateDocumentsForStoryCreateContractAmendment_VariationOnly33229()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_VariationOnly33229.json");

            //var one = documentGenerationCommand.CorporateContract.contractAllocations[0].contractAllocationNumber;
            //var two = documentGenerationCommand.CorporateContract.contractAllocations[1].contractAllocationNumber;
            //var three = documentGenerationCommand.CorporateContract.contractAllocations[2].contractAllocationNumber;
            //documentGenerationCommand.CorporateContract.contractAllocations[0].HasBeenAdded = true;
            //documentGenerationCommand.CorporateContract.contractAllocations[1].HasBeenAdded = true;
            documentGenerationCommand.CorporateContract.contractAllocations[2].HasBeenAdded = true;

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//VariationOnly33229.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        [TestMethod, TestCategory("TechnicalExploration")]
        public void DocumentGenerator_ShouldWorkForA280()
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_A280.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//A280.pdf", documentSaveCommand.FCTDocumentDatabus);
        }

        private void GenerateDocumentAndAssertExpectedLines(string testId, bool shouldAssertExpectedLines = true)
        {
            // arrange
            SetupIoc();
            DocumentGenerator generator = GetDocumentGenerator();
            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile($"DocGenCommand_{testId}.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            File.WriteAllBytes($"{Directory.GetCurrentDirectory()}//{testId}.pdf", documentSaveCommand.FCTDocumentDatabus);

            if (shouldAssertExpectedLines)
            {
                // assert
                string[] actualLines =
                    GetLinesFromPdfFile(documentSaveCommand.FCTDocumentDatabus)
                        .Where(ln => !ln.StartsWith("Date"))
                        .Select(ln => ln.Clean())
                        .ToArray();

                IReadOnlyCollection<string[]> expectedSections =
                    GetSectionsFromTextFile($"DAT_{testId}_ExpectedLines.txt", "---")
                        .ToList();

                expectedSections
                    .ToList()
                    .ForEach(expectedLines =>
                    {
                        var temp = expectedLines;
                        string firstFailureRow = expectedLines
                            .Where(ln => !actualLines.Contains(ln.Clean())).ToList()
                            .FirstOrDefault();

                        Assert.IsNull(firstFailureRow, $"This line is not present - expected: {firstFailureRow}");

                        AssertLinesArePresentInExpectedOrder(expectedLines, actualLines);
                    });
            }
        }

        private static void AssertLinesArePresentInExpectedOrder(IEnumerable<string> expectedLines, IEnumerable<string> actualLines)
        {
            Queue<string> expectedLinesQueue = new Queue<string>(expectedLines);
            Queue<string> actualLinesQueue = new Queue<string>(actualLines);

            while (expectedLinesQueue.Any())
            {
                string expectedLine = expectedLinesQueue.Dequeue();
                bool foundMatchingLine = false;

                while (actualLinesQueue.Any())
                {
                    string actualLine = actualLinesQueue.Dequeue();

                    if (expectedLine.Clean() == actualLine)
                    {
                        foundMatchingLine = true;
                        break;
                    }
                }

                Assert.IsTrue(foundMatchingLine, $"Failed to find line in expected order: {expectedLine}");
            }
        }

        private void SetupIoc()
        {
            IWindsorContainer container = new WindsorContainer().Install(new WindsorInstallerForDocumentGenerator(new LoggerFactory()));
            container.Register(Component.For<IContractManagementDbContext>().ImplementedBy<ContractManagementDbContext>().LifestyleScoped().IsDefault());
            container.Register(Component.For<DocumentsDomainDbContext>().ImplementedBy<DocumentsDomainDbContext>().LifestyleScoped().IsDefault());
            container.Register(Component.For<IPaymentManagementPolicyContext>().ImplementedBy<PaymentManagementPolicyContext>().LifestyleScoped().IsDefault());

            container.BeginScope();
        }

        private DocumentGenerator GetDocumentGenerator()
        {
            return new DocumentGenerator(
                new CorporateContractValidator(),
                new DocumentDefiner(new DocumentPartFinder()),
                new DocumentCreator(new AsposeWrapper(), new TemplateRepository(new AzureStorageWrapper())),
                new DocumentMerger(new AsposeWrapper()), new DocumentLocationResolver(),
                new FundingTypeFundingPeriodQueryRepository(new ContractManagementDbContext(), new EntityCache<(string, string), FundingTypeFundingPeriod>()));
        }

        private static string[] GetLinesFromPdfFile(byte[] bytes)
        {
            PdfReader reader = new PdfReader(bytes);
            
            StringBuilder allLinesFromPdf = new StringBuilder();

            for (int i = 1; i <= reader.NumberOfPages; i++)
            {
                allLinesFromPdf.Append(PdfTextExtractor.GetTextFromPage(reader, i));
                allLinesFromPdf.Append("\n");
            }

            string[] linesFromPdfFile =
                allLinesFromPdf.ToString().Split('\n')
                    .AsQueryable()
                    .Where(m => m.Trim().Length > 0)
                    .Select(m => m.Trim())
                    .ToArray();

            return linesFromPdfFile;
        }

        private DocumentGenerationCommand GetContractTypeFromFile(string fileName)
        {
            return TestResource.FromJson<DocumentGenerationCommand>("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                $"Resources.{fileName}");
        }

        private string[] GetLinesFromFile(string fileName)
        {
            return TestResource.LinesFromText("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests",
                $"Resources.{fileName}")
                .Where(line => !string.IsNullOrEmpty(line))
                .ToArray();
        }

        private static IEnumerable<string[]> GetSectionsFromTextFile(string fileName, string separator)
        {
            return TestResource.LinesFromText("SFA.FCT.DocumentsDomain.DocumentGeneration.Tests", $"Resources.{fileName}")
                .Split(ln => ln == separator)
                .Select(lns => lns.Where(ln => ln != separator && !string.IsNullOrWhiteSpace(ln)).ToArray());
        }
    }

    internal static class StringExtensions
    {
        public static string Clean(this string text)
        {
            return text.Trim().Replace(" ", "");
        }
    }

    internal class LocalTemplateRepository : ITemplateRepository
    {
        private readonly TemplateRepository _templateRepository;
        private readonly byte[] _fileBytes;

        public LocalTemplateRepository(IAzureStorageWrapper azureStorageWrapper, byte[] fileBytes)
        {
            _templateRepository = new TemplateRepository(azureStorageWrapper);
            _fileBytes = fileBytes;
        }

        public Document GetTemplate(FctFile file)
        {
            using (MemoryStream stream = new MemoryStream(_fileBytes))
            {
                return new Document(stream);
            }
        }

        public bool CheckTemplateExists(FctFile file)
        {
            return _templateRepository.CheckTemplateExists(file);
        }

        public string[] GetTemplateNames(string containerName)
        {
            return _templateRepository.GetTemplateNames(containerName);
        }

        public string GetNameOfTemplateActiveOnDate(string containerName, string startsWith, DateTime contractStartDate)
        {
            return _templateRepository.GetNameOfTemplateActiveOnDate(containerName, startsWith, contractStartDate);
        }
    }
}
