namespace ContractManagementDomain.Termination.Tests.Unit
{
    using System;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [TestClass]
    public class SetContractTerminationToCompleteInCrmHandlerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SetContractTerminationToCompleteInCrmCommand_ShouldConvertAllCrmServiceResponseConstantsToCrmGeneratedEnumEquivalents()
        {
           Enum.GetValues(typeof(SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse))
               .Cast<SetContractTerminationToCompleteInCrmCommand.CrmServiceResponse>()
               .ForEach(value => Assert.IsTrue(Enum.TryParse(value.ToString(), false, out sfa_serviceresponse _), $"Could not convert {value} to sfa_serviceresponse"));
        }
    }
}
