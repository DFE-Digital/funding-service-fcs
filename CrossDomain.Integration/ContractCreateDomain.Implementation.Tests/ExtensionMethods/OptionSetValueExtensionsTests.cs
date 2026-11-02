namespace ContractCreateDomain.Implementation.Tests.ExtensionMethods
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class OptionSetValueExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void OptionSetValueExtensions_GetText_ShouldReturnTextEquivaluent()
        {
            // arrange
            List<(int code, string desc)> codesWithDescriptions = new List<(int code, string desc)>
            {
                (229660003, "ProviderChange"),
                (229660009, "ContractNovation"),
            };
            codesWithDescriptions.ForEach(pair =>
            {
                OptionSetValue optionSetValue = new OptionSetValue(pair.code);

                // act
                var text = optionSetValue.GetText<sfa_TerminationReasons>();

                // assert
                Assert.AreEqual(pair.desc, text);
            });
        }
    }
}
