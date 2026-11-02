namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using CrossDomain.Integration.Common;
    using CrossDomain.Integration.Common.Storage;
    using Microsoft.SharePoint.Client;
    using Microsoft.Test.ObjectComparison;
    using CrossDomain.Integration.OverrideDate;
    using Infrastructure.DTO;
    using Infrastructure.DTO.PaymentGeneration;
    using Infrastructure.Services;

    public class PaymentGenerationPageObject
    {
        private readonly IOffice365Adapter _office365Adapter = new Office365StorageWrapper();
        private readonly IDate _date;

        private const string PtsFolderName = "PTS Files";

        public PaymentGenerationPageObject()
        {
            _date = new StaticDate(new OverrideDateDBContext());
        }

        public bool IsPaymentFileCreatedInDropLocation(string paymentInstructionFile)
        {
            return _office365Adapter.DoesFileExist(PtsFolderName, GetLatestFolderName(), paymentInstructionFile);
        }

        public bool IsPaymentFileCreatedInOffice365(string paymentInstructionFile, string folderName)
        {
            return _office365Adapter.DoesFileExist(PtsFolderName, folderName, paymentInstructionFile);
        }

        public PaymentInstruction GetLinesFromPaymentInstructionFile(string paymentInstructionFile, string folderName)
        {
            return new PaymentInstruction
            {
                Lines = CreatInstructionLines(GetRows(PtsFolderName, folderName, paymentInstructionFile))
            };
        }

        public SummaryInstruction GetLinesFromPaymentSummaryFile(string paymentInstructionFile, string folderName)
        {
            return new SummaryInstruction
            {
                Lines = CreateSummaryLines(GetRows(PtsFolderName, folderName, paymentInstructionFile))
            };
        }

        private static List<InstructionLine> CreatInstructionLines(List<string[]> rows)
        {
            var lines = new List<InstructionLine>();

            rows.ForEach(r =>
            {
                lines.Add(new InstructionLine
                {
                    LinkCode = r[0],
                    CompanyCode = r[1],
                    Element1 = r[2],
                    Element2 = r[3],
                    Element3 = r[4],
                    Element4 = r[5],
                    Element6 = r[7],
                    Amount = (r[13]),
                    LineType = r[15],
                    SubnominalShortDescription = r[17],
                    ExtRef3 = r[22],
                    Element25 = r[25]
                });
            });
            
            return lines;
        }

        private List<string[]> GetRows(string ptsFolderName, string archivefolderName, string fileName)
        {
            byte[] file = _office365Adapter.GetFileContents(ptsFolderName, archivefolderName, fileName);

            List<string> lines = new List<string>();

            using (var ms = new MemoryStream(file))
            using (var sr = new StreamReader(ms))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    lines.Add(line);
                }
            }

            return lines.Select(l => l.Split(',')).ToList();
        }

        private string GetLatestFolderName()
        {
            return _date.GetCalculationDate().ToString("dd-MMM-yyyy");
        }

        private List<SummaryInstructionLine> CreateSummaryLines(List<string[]> rows)
        {
            var lines = new List<SummaryInstructionLine>();

            rows.ForEach(r =>
            {
                lines.Add(new SummaryInstructionLine
                {
                    PaymentFileName = r[1],
                    ErrorFileName = r[4],
                    NumberOfPayments = r[2],
                    ValueOfPayments = r[3],
                    NumberOfErrorPayments = r[5],
                    ValueOfErrorPayments = r[6]
                });
            });

            return lines;
        }

        public void DeleteFilesFromOffice365InPtsFolder()
        {
            using (var clientContext = SharePointAuthenticationHelper.GetClientContext())
            {
                List list = clientContext.Web.Lists.GetByTitle(PtsFolderName);

                clientContext.Load(list.RootFolder.Folders);
                clientContext.ExecuteQuery();
                List<Folder> folders = list.RootFolder.Folders.Where(f => f.Name != "Forms").ToList();
                folders
                    .ForEach(f =>
                    {
                        f.DeleteObject();
                        clientContext.ExecuteQuery();
                    });
            }
        }      

        public IEnumerable<ObjectComparisonMismatch> ComparePayGenObjects(object expectedTransInstruction, object actualTransInstruction)
        {
            //compare objects using comparison tool
            // Perform the compare operation
            IEnumerable<ObjectComparisonMismatch> mismatches = new List<ObjectComparisonMismatch>();
            var factory = new PublicPropertyObjectGraphFactory();
            var comparer = new ObjectGraphComparer();

            var expectedGraph = factory.CreateObjectGraph(expectedTransInstruction);
            var actualGraph = factory.CreateObjectGraph(actualTransInstruction);

            comparer.Compare(expectedGraph, actualGraph, out mismatches);
            
            return mismatches;
        }
    }
}
