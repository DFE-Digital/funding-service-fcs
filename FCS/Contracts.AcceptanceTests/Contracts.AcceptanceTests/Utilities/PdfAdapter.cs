namespace SFA.FCT.Contracts.AcceptanceTests.Utilities
{
    using System;
    using System.Linq;
    using System.Text;
    using iTextSharp.text.pdf;
    using iTextSharp.text.pdf.parser;
    using NUnit.Framework;

    public class PdfAdapter
    {
        private readonly byte[] _pdfFileContents;

        public PdfAdapter(byte[] pdfFileContents)
        {
            _pdfFileContents = pdfFileContents;
        }

        public void VerifyLinesInOrderAndAssertIfNotFound(string multilineText)
        {
            string[] expectedLines =
                multilineText.Split('\n')
                    .AsQueryable()
                    .Select(m => m.Trim().TrimEnd('\r'))
                    .Where(l => l.Length > 0)
                    .ToArray();

            VerifyLinesInOrderAndAssertIfNotFound(expectedLines);
        }

        public void VerifyLinesAreNotPresentInOrderAndAssertIfFound(string multilineText)
        {
            string[] textThatShouldBeAbsent =
                multilineText.Split('\n')
                    .AsQueryable()
                    .Select(m => m.Trim().TrimEnd('\r'))
                    .ToArray();

            VerifyLinesNotPresentInOrderAndAssertIfNotFound(textThatShouldBeAbsent);
        }

        public void VerifyTextNotPresentAndAssertIfFound(string multilineText)
        {
            string[] linesFromPdfFile = GetLinesFromPdfFile();

            foreach (string line in linesFromPdfFile)
            {
                if (line.Contains(multilineText))
                {
                    Assert.Fail("Text:{0} is present in pdf and it should not be.", multilineText);
                }
            }
        }

        public decimal ExtractLineIfFound(string searchString)
        {
            if (GetLinesFromPdfFile().Any(m => m.IndexOf(searchString) != -1))
            {
                string value = (from l in GetLinesFromPdfFile()
                    where l.IndexOf(searchString) != -1
                    select l.Substring(l.IndexOf("£") + 1, l.Length - l.IndexOf("£") - 1)).First();

                if (!string.IsNullOrEmpty(value))
                {
                    decimal returnValue;
                    if (decimal.TryParse(value, out returnValue))
                        return returnValue;
                }
            }
            return decimal.MinValue;
        }

        private void VerifyLinesInOrderAndAssertIfNotFound(string[] expectedLines)
        {
            string[] linesFromPdfFile = GetLinesFromPdfFile();

            int atLineNumber = 0;
            foreach (string expectedLine in expectedLines)
            {
                bool found = false;
                for (int lineNumber = atLineNumber; lineNumber < linesFromPdfFile.Length; lineNumber++)
                {
                    if (linesFromPdfFile[lineNumber] == expectedLine)
                    {
                        atLineNumber = lineNumber + 1;
                        found = true;
                        break;
                    }
                    else
                    {
                        int i = 1;
                    }
                }

                if (!found)
                {
                    for (int lineNumber = 0; lineNumber < linesFromPdfFile.Length; lineNumber++)
                    {
                        if (linesFromPdfFile[lineNumber] == expectedLine)
                        {
                            found = true;
                        }
                    }

                    string message = "Couldn't find expected line in pdf file, line expected is";
                    if (found)
                    {
                        message = "Found expected line in document but not in the right place, line expected is";
                    }

                    Assert.Fail(message + " \"" + expectedLine + "\"" + Environment.NewLine + string.Join(Environment.NewLine, linesFromPdfFile));
                }
            }
        }

        private string[] GetLinesFromPdfFile()
        {
            PdfReader reader = new PdfReader(_pdfFileContents);
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

        private void VerifyLinesNotPresentInOrderAndAssertIfNotFound(string[] textThatShouldBeAbsent)
        {
            string[] linesFromPdfFile = GetLinesFromPdfFile();

            foreach (string absentText in textThatShouldBeAbsent)
            {
                foreach (string line in linesFromPdfFile)
                {
                    if (line == absentText)
                    {
                        Assert.Fail("Text:{0} is present in pdf and it should not be.", absentText);
                    }
                }
            }
        }
    }
}