namespace ContractManagementDomain.Endpoint.Tests.LevyAmendmentEndpoint.Extensions
{
    using Endpoint.LevyAmendmentEndpoint.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class ContractInformationExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractInformationExtensions_IsStatusValidForAmendment_ShouldReturnFalseWhenAllowUnderTerminationIsFalseAndSubStatusIsUnderTermination()
        {
            // arrange
            var contractInformation = new ContractInformation("", "", 1, 0, 
                string.Empty, ContractStatus.Approved, ContractSubStatus.UnderTermination);

            // act
            var isValid = contractInformation.IsStatusValidForAmendment(false);

            // assert
            Assert.IsFalse(isValid, "UnderTermination is not allowed so this should not be valid");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractInformationExtensions_IsStatusValidForAmendment_ShouldReturnTrueWhenAllowUnderTerminationIsTrueAndSubStatusIsUnderTermination()
        {
            // arrange
            var contractInformation = new ContractInformation("", "", 1, 0, 
                string.Empty, ContractStatus.Approved, ContractSubStatus.UnderTermination);

            // act
            var isValid = contractInformation.IsStatusValidForAmendment(true);

            // assert
            Assert.IsTrue(isValid, "UnderTermination is allowed so this should be valid");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractInformationExtensions_IsStatusValidForAmendment_ShouldReturnTrueWhenAllowUnderTerminationIsFalseAndSubStatusIsModified()
        {
            // arrange
            var contractInformation = new ContractInformation("", "", 1, 0,
                string.Empty, ContractStatus.Approved, ContractSubStatus.Modified);

            // act
            var isValid = contractInformation.IsStatusValidForAmendment(false);

            // assert
            Assert.IsTrue(isValid, "Modified is allowed so this should be valid");
        }
    }
}
