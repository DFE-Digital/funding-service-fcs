namespace FCT.Operations.Tests.PaymentSummary.Extensions
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary.Extensions;

    [TestClass]
    public class IntExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void IntExtensions_GetExcelColumnName_ShouldReturnCorrectColumn()
        {
            List<(int index, string columnName)> inputList =
                new List<(int index, string columnName)>
                {
                    (0, "A"),
                    (1, "B"),
                    (2, "C"),
                    (25, "Z"),
                    (26, "AA"),
                    (27, "AB"),
                    (51, "AZ"),
                    (77, "BZ"),
                };

            // act 
            inputList.ForEach(inputItem =>
            {
                var columnName = inputItem.index.GetExcelColumnName();
                Assert.AreEqual(inputItem.columnName, columnName, $"We have the wrong column for: {inputItem.index}");
            });
        }
    }
}
