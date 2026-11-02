namespace CrossDomain.Integration.Common.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Common.Config;

    [TestClass]
    public class TrustedDataCollectionTests
    {

        [TestMethod, TestCategory("UnitTest")]
        public void TrustedData_ShouldGetTrustedAllocationNumbers()
        {
            // arrange
            IList<string> allocNumbers = new List<string> { "ESF", "SB2022", "SB-PAA2022", "SB2023" };

            // act
            var allocNumbersReturned = TrustedData.FundingStreamsWithTrustedAllocationNumbers;

            // assert
            Assert.AreEqual(4, allocNumbersReturned.Count, "the wrong number of allocation numbers");
            Assert.IsTrue(allocNumbers.All(a => allocNumbersReturned.Contains(a)),
                "not all the allocation numbers are present");
        }

    }
}
