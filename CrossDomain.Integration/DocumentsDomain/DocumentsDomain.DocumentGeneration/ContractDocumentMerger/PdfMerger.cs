namespace SFA.FCT.DocumentsDomain.DocumentGeneration.ContractDocumentMerger
{
    using System.Collections.Generic;
    using System.IO;
    using Aspose.Pdf;
    using CrossDomain.Integration.Common;

    public class PdfMerger : IPdfMerger
    {
        public PdfMerger()
        {
            using (Stream licenseStream = LicenseManager.GetAsposeLicense())
            {
                License pdfLicense = new License();
                pdfLicense.SetLicense(licenseStream);
            }
        }

        public byte[] MergeDocumentation(List<KeyValuePair<int, byte[]>> documentsToMerge)
        {
            var mergedDocument = new Document();
            foreach (var doc in documentsToMerge)
            {
                var currentDoc = new Document(new MemoryStream(doc.Value));
                mergedDocument.Pages.Add(currentDoc.Pages);
            }

            byte[] targetPdf;

            using (var ms = new MemoryStream())
            {
                mergedDocument.Save(ms, SaveFormat.Pdf);
                targetPdf = ms.ToArray();
            }

            return targetPdf;
        }
    }
}