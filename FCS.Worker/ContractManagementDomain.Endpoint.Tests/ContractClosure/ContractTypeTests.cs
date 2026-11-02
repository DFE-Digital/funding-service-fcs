namespace ContractManagementDomain.Endpoint.Tests.ContractClosure
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    [TestClass]
    public class ContractTypeTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractType_IsModified_ShouldReturnTrueWhenModificationDataPresent()
        {
            // arrange
            List<(string reason, DateTime? stopNewStartsDate, bool isModified)> inputData =
                new List<(string reason, DateTime? stopNewStartsDate, bool isModified)>
                {
                    ("some reason", null, true),
                    ("some reason", DateTime.Now, true),
                    ("", DateTime.Now, true),
                    (null, null, false),
                };
            
            inputData.ForEach(input =>
            {
                contractType childContract = new contractType
                {
                    contractAllocations = new List<contractAllocationsContractAllocation>
                    {
                        new contractAllocationsContractAllocation
                        {
                            NewStartsSuspendedReason = input.reason,
                            StopNewStartsDate = input.stopNewStartsDate
                        }
                    }
                };

                // act
                Assert.AreEqual(input.isModified, childContract.IsModified, $"This input has failed:: {input}");
            });
        }
    }
}
