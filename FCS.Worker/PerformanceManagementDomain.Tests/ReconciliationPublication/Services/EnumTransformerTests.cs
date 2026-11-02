namespace PerformanceManagementDomain.Tests.ReconciliationPublication.Services
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.ReconciliationPublication.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation;

    [TestClass]
    public class EnumTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void EnumTransformer_ShouldParseAllPeriodTypeNames()
        {
            // arrange
            bool exceptionThrown = false;

            // act
            try
            {
                foreach (PeriodTypeName periodTypeName in Enum.GetValues(typeof(PeriodTypeName)))
                {
                    EnumTransformer.TransformPeriodTypeName(periodTypeName);
                }
            }
            catch (Exception)
            {
                exceptionThrown = true;
            }

            // assert
            Assert.IsFalse(exceptionThrown);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void EnumTransformer_ShouldParseAllPeriodTypeCodes()
        {
            // arrange
            bool exceptionThrown = false;

            // act
            try
            {
                foreach (PeriodTypeCode periodTypeCode in Enum.GetValues(typeof(PeriodTypeCode)))
                {
                    EnumTransformer.TransformPeriodTypeCode(periodTypeCode);
                }
            }
            catch (Exception)
            {
                exceptionThrown = true;
            }

            // assert
            Assert.IsFalse(exceptionThrown);
        }
    }
}
