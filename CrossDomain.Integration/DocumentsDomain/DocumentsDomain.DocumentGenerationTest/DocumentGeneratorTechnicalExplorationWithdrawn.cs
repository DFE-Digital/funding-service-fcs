namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests
{
    using System.Linq;
    using System.Text;
    using Castle.MicroKernel.Lifestyle;
    using Castle.MicroKernel.Registration;
    using Castle.Windsor;
    using Common.Commands;
    using ContractManagement.DataStore;
    using ContractManagement.DataStore.Model;
    using ContractManagement.DataStore.Repositories;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Messages.Commands;
    using DataStore;
    using DataStore.Repositories;
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
    using Moq;
    using PaymentManagementDomain.PolicyCache.DataStore;
    using UnitTests.Common;

    class DocumentGeneratorTechnicalExplorationWithdrawn
    {
        [TestMethod, TestCategory("DocGenIntegrationWithdrawn")]
        public void DocumentGenerator_ShouldWorkforA310()
        {
            // arrange

            //We need to setup the IoC so that the Doc Part Creators get created

            SetupIoc();

            DocumentGenerator generator = GetDocumentGenerator();


            DocumentGenerationCommand documentGenerationCommand = GetContractTypeFromFile("DocumentGenerationCommand_NLA_1920.json");

            // act
            DocumentSaveCommand documentSaveCommand = generator.GenerateDocument("", documentGenerationCommand.CorporateContract, documentGenerationCommand.MasterContractNumber);

            // assert
            string[] actualLines = GetLinesFromPdfFile(documentSaveCommand.FCTDocumentDatabus);
            actualLines = actualLines.Where(l => !l.StartsWith("Date")).ToArray();
            string[] expectedLines = GetLinesFromFile("DAT_A310_ExpectedLines.txt");
            Assert.AreEqual(expectedLines.Length, actualLines.Length, "The number of lines is wrong");
            var firstFailureRow = expectedLines.Select((expectedLine, i) =>
                    new { Expected = expectedLine.Clean(), Index = i, Actual = actualLines[i].Clean() })
                .FirstOrDefault(r => r.Actual != r.Expected);

            Assert.IsNull(firstFailureRow, $"This line is not present - expected:{firstFailureRow?.Expected}, actual:{firstFailureRow?.Actual}, rowNumber: {firstFailureRow?.Index}");
        }

        private void SetupIoc()
        {
            IWindsorContainer container = new WindsorContainer().Install(new SFA.FCT.DocumentsDomain.DocumentGeneration.IoC.WindsorInstallerForDocumentGenerator(new LoggerFactory()));
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

        private string[] GetLinesFromPdfFile(byte[] bytes)
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
                $"Resources.{fileName}").ToArray();
        }

    }
}
