namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;

    [TestClass]
    public class CrmOptionSetTypeExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void CrmOptionSetTypeExtensions_ShouldSupportAllTerminationReasons()
        {
            // arrange
            IEnumerable<sfa_TerminationReasons> terminationReasons = EnumHelper.GetAllItems<sfa_TerminationReasons>();
            
            // act
            try
            {
                terminationReasons.ForEach(tr => CrmOptionSetType.TerminationReason.GetOptionValue(tr.ToString()));
            }
            catch (ArgumentException e)
            {
                // assert
                Assert.Fail(e.Message);
            }
        }

        private static class EnumHelper
        {
            public static IEnumerable<T> GetAllItems<T>() where T : struct
            {
                foreach (object item in Enum.GetValues(typeof(T)))
                {
                    yield return (T)item;
                }
            }
        }
    }
}
