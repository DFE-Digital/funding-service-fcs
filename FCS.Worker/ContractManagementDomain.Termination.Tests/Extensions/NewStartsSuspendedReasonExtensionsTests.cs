namespace ContractManagementDomain.Termination.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagementDomain.Termination.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class NewStartsSuspendedReasonExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void NewStartsSuspendedReason_ToUserReadableString_ShouldTransformToUserReadableString()
        {
            // arrange
            sfa_newstartssuspendedreason value = sfa_newstartssuspendedreason.InadequateFinancialHealth;

            // act
            string userReadableString = value.ToUserReadableString();

            // assert
            Assert.AreEqual("Inadequate Financial Health", userReadableString);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NewStartsSuspendedReason_ToUserReadableString_ShouldTransformAllInstancesOfEnumWithoutException()
        {
            // arrange
            List<sfa_newstartssuspendedreason> allPossibleValues =
                Enum.GetValues(typeof(sfa_newstartssuspendedreason))
                .Cast<sfa_newstartssuspendedreason>()
                .ToList();

            allPossibleValues.ForEach(value =>
            {
                // act
                string userReadableString = value.ToUserReadableString();

                // assert
                Assert.AreEqual(value.ToString(), userReadableString.Replace(" ", ""), $"Incorrect translation for {value}");
            });
        }
    }
}
