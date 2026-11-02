namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;
    using SFA.FCT.ContractCreateDomain.Implementation;

    [TestClass]
    public class LookupManagerCleanTests
    {
        [TestMethod, TestCategory("IntegrationTest")]

        public void LookupManager_GetOptionsetValue_ShouldGetTerminationReasons()
        {
            // arrange
            var lookupManager = new LookupManager
            {
                OrganizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService(),
                BatchCacheManager = new BatchCacheManager(),
                EnduringCacheManager = new EnduringCacheManager()
            };

            IEnumerable<sfa_TerminationReasons> terminationReasons = EnumHelper.GetAllItems<sfa_TerminationReasons>();

            // act
            terminationReasons.ForEach(tr =>
                {
                    int? optionSetValue = lookupManager.GetOptionsetValue("sfa_terminationreasons",
                        CrmOptionSetType.TerminationReason.GetOptionValue(tr.ToString()));

                    // assert
                    Assert.IsTrue(optionSetValue.HasValue, $"There is no termination reason that maps to: {tr}");
                });
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
