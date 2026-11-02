namespace SFA.FCT.CrossDomain.Integration.Entities.ExcelUpload
{
    using System.Linq;
    using System.Diagnostics.CodeAnalysis;

    [SuppressMessage("StyleCop.CSharp.NamingRules", "SA1300:ElementMustBeginWithUpperCaseLetter")]
    public partial class dataLoadResults
    {
        public sheetType GetSheet(string sheetname)
        {
            return workbook.FirstOrDefault(s => s.name == sheetname);
        }

        public bool IsSuccess()
        {
            return error == null || error.Length == 0;
        }
    }
}
