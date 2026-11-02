namespace FCT.Operations.FundingAllocationExtract
{
    using System.Collections.Generic;
    using Aspose.Cells;
    using DTOs;

    public interface IExcelGenerator
    {
        Workbook GenerateWorkbook(IReadOnlyCollection<ExtractRow> parkedExtractRows, IReadOnlyCollection<ExtractRow> discardedExtractRows);
    }
}