namespace FCT.Operations.Extensions
{
    using System.IO;
    using Aspose.Cells;

    public static class WorkbookExtensions
    {
        public static byte[] ToBytes(this Workbook workbook)
        {
            var memoryStream = new MemoryStream();

            workbook.Save(memoryStream, (SaveFormat)workbook.FileFormat);
            return memoryStream.ToArray();
        }
    }
}
